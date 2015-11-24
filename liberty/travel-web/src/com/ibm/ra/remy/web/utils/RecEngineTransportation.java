/* 
 * Licensed Materials - Property of IBM © Copyright IBM Corporation 2015. All
 * Rights Reserved. This sample program is provided AS IS and may be used,
 * executed, copied and modified without royalty payment by customer (a) for its
 * own instruction and study, (b) in order to develop applications designed to
 * run with an IBM product, either for customer's own internal use or for
 * redistribution by customer, as part of such an application, in customer's own
 * products.
 */

package com.ibm.ra.remy.web.utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.ibm.ra.remy.common.impl.LatLong;
import com.ibm.ra.remy.common.impl.RemyMeetingEvent;
import com.ibm.ra.remy.common.impl.RemyRecommendationsEvent;
import com.ibm.ra.remy.common.impl.RemyRestaurantEvent;
import com.ibm.ra.remy.common.impl.RemyTransitEvent;
import com.ibm.ra.remy.common.model.RemyItinerary;
import com.ibm.ra.remy.common.model.RemyEvent;
import com.ibm.ra.remy.common.model.RemyEventDate;
import com.ibm.ra.remy.common.model.RemyRecs;

import com.ibm.watson.developer_cloud.tradeoff_analytics.v1.TradeoffAnalytics;
import com.ibm.watson.developer_cloud.tradeoff_analytics.v1.model.Dilemma;
import com.ibm.watson.developer_cloud.tradeoff_analytics.v1.model.Option;
import com.ibm.watson.developer_cloud.tradeoff_analytics.v1.model.Problem;
import com.ibm.watson.developer_cloud.tradeoff_analytics.v1.model.Solution;
import com.ibm.watson.developer_cloud.tradeoff_analytics.v1.model.column.Column;
import com.ibm.watson.developer_cloud.tradeoff_analytics.v1.model.column.Column.Goal;
import com.ibm.watson.developer_cloud.tradeoff_analytics.v1.model.column.NumericColumn;

/**
 * This class captures features related to transportation recommendations and
 * also aids in programmatically generating itinerary versions for an
 * MVP demonstration application.
 * 
 * Example Use:
 * 1. Start with an itinerary that includes subsequent events that are far away.
 * 2. Call recommendTransportation to inject transportation recommendations
 *        between any subsequent events that are far away from each other.
 * 3. Call chooseTransportation to generate a new itinerary version that
 *        contains a "user-chosen" transportation recommendation.
 */

public class RecEngineTransportation {
	
	private static final String USERNAME_KEY="TA_USERNAME";
	private static final String PASSWORD_KEY="TA_PASSWORD";

	/**
	 * Process an itinerary by injecting transportation recommendations
	 * between events that are far apart.
	 * 
	 * @param itinerary An itinerary with events.
	 * @param options The available options that can be recommended.
	 * @param locale The requested locale.
	 * @return A copied itinerary with weather recommendations injected.
	 */
	public static RemyItinerary recommendTransportation(RemyItinerary itinerary, RemyRecs options, String locale) {
		RemyItinerary updatedItinerary = (RemyItinerary) DeepCopy.copy(itinerary);
		List<Pair> farAwayEventsList = identifyFarAwayEvents(updatedItinerary);
		for (Pair farAwayEvents : farAwayEventsList) {
			List<RemyTransitEvent> transportation = lookupTransit(farAwayEvents, options);
			List<RemyTransitEvent> sortedTransportation = null;
			try {
				sortedTransportation = sortTransit(farAwayEvents, transportation);
			} catch (Exception e) {
				sortedTransportation = transportation;
			}
			injectTransportationRecommendations(updatedItinerary, farAwayEvents, options.getTransitRecs(), sortedTransportation);
		}
		return updatedItinerary;
	}
	

	/**
	 * This function chooses a transportation option from a set of recommended
	 * transportation options based on the user's story.
	 *
	 * @param itinerary An itinerary containing transportation recommendations
	 * @return A copy of the itinerary containing a selected transportation
	 * option (the transportation recommendations are removed from the
	 * itinerary).
	 */
	public static RemyItinerary chooseTransportation(RemyItinerary itinerary) {
		RemyItinerary updatedItinerary = (RemyItinerary) DeepCopy.copy(itinerary);
		
		// We'll grab the injected transit recommendation object first.
		RemyEventDate recDate = null;
		RemyRecommendationsEvent recList = null;
		for (RemyEventDate d : updatedItinerary.getAllDates()) {
			for (RemyEvent e : d.getEvents()) {
				if (RemyEvent.RECOMMENDATIONS.equals(e.getSubtype())) {
					if (RemyEvent.TRANSIT.equals(((RemyRecommendationsEvent) e).getRecType())) {
						recDate = d;
						recList = (RemyRecommendationsEvent) e;
					}
				}
			}
		}
		RemyTransitEvent recommendedTransit = (RemyTransitEvent) recList.getRecommendationList().get(0);
		// Now we can remove the recommendation list from the itinerary.
		recDate.removeEvent(recList);
		
		// Now we take the recommended transit and add it to the itinerary.
		recDate.addEvent(recommendedTransit);
		
		// Then sort the events and return.
		updatedItinerary.sortAllEvents();
		return updatedItinerary;
	}

	/**************************************************************************
	 * Helper Functions
	 *************************************************************************/

	/**
	 * A Pair represents two sequential events in an itinerary.
	 */
	private static class Pair {
		RemyEvent firstEvent;
		
		@SuppressWarnings("unused")
		RemyEvent secondEvent;

		public Pair(RemyEvent firstEvent, RemyEvent secondEvent) {
			this.firstEvent = firstEvent;
			this.secondEvent = secondEvent;
		}
	}
	
	/**
	 * Identify any pairs of events that are geographically far from each other.
	 * The events must be on the same day, and subsequent in the itinerary.
	 *
	 * @param itinerary The itinerary.
	 * @return A list of pairs, where each pair contains subsequent events that
	 * are located far away from each other.
	 */
	private static List<Pair> identifyFarAwayEvents(RemyItinerary itinerary) {
		List<Pair> farAwayEventsList = new ArrayList<Pair>();
		double maxWalkingDistanceMeters = 2000;
		for (RemyEventDate date : itinerary.getAllDates()) {
			List<RemyEvent> events = date.getEvents();
			for (int i = 0; i < events.size()-1; i++) {
				RemyEvent event1 = events.get(i);
				RemyEvent event2 = events.get(i+1);
				boolean requiresTransportation = (hasLocation(event1) && hasLocation(event2));
				if (requiresTransportation) {
					LatLong location1 = getLocation(event1);
					LatLong location2 = getLocation(event2);
					if (location1 != null && location2 != null) {
						if (location1.distanceTo(location2) > maxWalkingDistanceMeters) {
							Pair pair = new Pair(event1, event2);
							farAwayEventsList.add(pair);
						}
					}
				}
			}
		}
		return farAwayEventsList;
	}
	
	/**
	 * Return whether the given event may require transportation to reach.
	 * In other words, does the event have a geographical location?
	 * 
	 * @param event The event.
	 * @return If the event is of type meeting or restaurant, then true.
	 * Otherwise, false.
	 */
	private static boolean hasLocation(RemyEvent event) {
		boolean isMeeting = event.getSubtype().equals(RemyEvent.MEETING);
		boolean isRestaurant = event.getSubtype().equals(RemyEvent.RESTAURANT);
		boolean requiresTransportation = isMeeting | isRestaurant;
		return requiresTransportation;
	}
	
	/**
	 * Return the location of the given event, if applicable.
	 *
	 * @param event An event that may or may not be associated with a
	 * geographical location.
	 * @return A LatLong object capturing the latitude and longitude of
	 * the event's location, if it is a lodging event, meeting event,
	 * or restaurant event. Otherwise, null.
	 */
	private static LatLong getLocation(RemyEvent event) {
		if (event.getClass() == RemyMeetingEvent.class) {
			RemyMeetingEvent meetingEvent = (RemyMeetingEvent) event;
			return new LatLong(meetingEvent.getGeometry().getLocation().getLat(),
					           meetingEvent.getGeometry().getLocation().getLng());
		}
		
		if (event.getClass() == RemyRestaurantEvent.class) {
			RemyRestaurantEvent restaurantEvent = (RemyRestaurantEvent) event;
			return new LatLong(restaurantEvent.getGeometry().getLocation().getLat(),
					           restaurantEvent.getGeometry().getLocation().getLng());
		}

		return null;
	}

	/**
	 * Search for available transportation options.
	 *
	 * For this MVP, we simply use a hard-coded set of transportation options
	 * that are returned from the database. In a real implementation, this
	 * function might call an API with origin and destination locations to
	 * dynamically load available transportation options.
	 *
	 * @param farAwayEvent A pair of events such that transportation shall be
	 * recommended from the first event to the second.
	 * @param options The hard-coded transportation options that are available.
	 * @return A list of transportation options, represented as
	 * RemyTransitEvents.
	 */
	private static List<RemyTransitEvent> lookupTransit(Pair farAwayEvents, RemyRecs options) {
		List<RemyTransitEvent> transportation = new ArrayList<RemyTransitEvent>();
		for (RemyEvent e : options.getTransitRecs().getRecommendationList()) {
			transportation.add((RemyTransitEvent) e);
		}
		return transportation;
	}
	
	/**
	 * Sort the transportation recommendations taking into consideration:
	 *     - price
	 *     - waiting time
	 *     - number of transfers
	 *     - total trip duration
	 *     - walking distance
	 *
	 * @param farAwayEvents The pair of events between which transportation is
	 * being recommended.
	 * @param transportation An unsorted list of transportation recommendations.
	 * @return A sorted list of transportation recommendations.
	 */
	private static List<RemyTransitEvent> sortTransit(Pair farAwayEvents, List<RemyTransitEvent> transportation) {		
		// since Tradeoff Analytics returns a stable sort of optimal solutions,
		// we need to bring the "walk_rail_rail_walk" option to the top of the
		// input list in order to make sure it appears first amont the optimal
		// solutions (this is just to align the results with Lara's story)
		String STORY_TRANSIT_OPTION = "walk_rail_rail_walk";
		List<RemyTransitEvent> presortedTransportation = new ArrayList<RemyTransitEvent>();
		for (RemyTransitEvent e : transportation) {
			if (STORY_TRANSIT_OPTION.equals(e.getIos_transit_name())) {
				presortedTransportation.add(e);
			}
		}
		for (RemyTransitEvent e : transportation) {
			if (!STORY_TRANSIT_OPTION.equals(e.getIos_transit_name())) {
				presortedTransportation.add(e);
			}
		}
		transportation = presortedTransportation;

		// get credentials for Tradeoff Analytics
		PropertiesReader constants = PropertiesReader.getInstance();
		String username = constants.getStringProperty(USERNAME_KEY);
		String password = constants.getStringProperty(PASSWORD_KEY);
		
		// initialize Tradeoff Analytics service
		TradeoffAnalytics tradeoffAnalytics = new TradeoffAnalytics();
		tradeoffAnalytics.setUsernameAndPassword(username, password);
		Problem problem = new Problem("transportation");
		 		
		// define objective keys
		String price = "price";
		String waitingTime = "waiting_time";
		String numTransfers = "num_transfers";
		String totalDuration = "total_duration";
		String walkingDistance = "walking_distance";
		 		
		// define objectives
		List<Column> columns = new ArrayList<Column>();
		problem.setColumns(columns);
		columns.add(new NumericColumn().withKey(price).withGoal(Goal.MIN).withObjective(true));
		columns.add(new NumericColumn().withKey(waitingTime).withGoal(Goal.MIN).withObjective(true));
		columns.add(new NumericColumn().withKey(numTransfers).withGoal(Goal.MIN).withObjective(true));
		columns.add(new NumericColumn().withKey(totalDuration).withGoal(Goal.MIN).withObjective(true));
		columns.add(new NumericColumn().withKey(walkingDistance).withGoal(Goal.MIN).withObjective(true));
		
		// define options, mapping their keys to the corresponding RemyTransitEvent
		List<Option> options = new ArrayList<Option>();
		HashMap<String, RemyTransitEvent> map = new HashMap<String, RemyTransitEvent>();
		problem.setOptions(options);
		for (int i = 0; i < transportation.size(); i++) {
			HashMap<String, Object> transitParams = new HashMap<String, Object>();
			RemyTransitEvent transitEvent = transportation.get(i);
			transitParams.put(price, transitEvent.getCostDouble());
			transitParams.put(waitingTime, transitEvent.getWaitingTime());
			transitParams.put(numTransfers, transitEvent.getNumTransfers());
			transitParams.put(totalDuration, transitEvent.getTotalDuration());
			transitParams.put(walkingDistance, transitEvent.getWalkingDistance());
			String key = "" + i;
			String name = "Transit Option " + i;
			options.add(new Option(key, name).withValues(transitParams));
			map.put(key, transitEvent);
		}
		
		// call the service and get the solution
		List<RemyTransitEvent> sortedTransportation = transportation;
		try {
			Dilemma dilemma = tradeoffAnalytics.dilemmas(problem);
			sortedTransportation = new ArrayList<RemyTransitEvent>();
			
			// define solution keys
			String front = "FRONT";
			String excluded = "EXCLUDED";
			String incomplete = "INCOMPLETE";
			String doesNotMeetPreference = "DOES_NOT_MEET_PREFERENCE";
			
			// collect front solutions (top options for the problem)
			for (Solution solution : dilemma.getResolution().getSolutions()) {
				if (solution.getStatus().equals(front)) {
					String key = solution.getSolutionRef();
					RemyTransitEvent transitEvent = map.get(key);
					sortedTransportation.add(transitEvent);
				}
			}

			 // collect excluded solutions (top options for the problem)
			 for (Solution solution : dilemma.getResolution().getSolutions()) {
			 	if (solution.getStatus().equals(excluded)) {
			 		String key = solution.getSolutionRef();
			 		RemyTransitEvent transitEvent = map.get(key);
			 		sortedTransportation.add(transitEvent);
			 	}
			 }

			 // collect incomplete solutions (top options for the problem)
			 for (Solution solution : dilemma.getResolution().getSolutions()) {
			 	if (solution.getStatus().equals(incomplete)) {
			 		String key = solution.getSolutionRef();
			 		RemyTransitEvent transitEvent = map.get(key);
			 		sortedTransportation.add(transitEvent);
			 	}
			 }

			 // collect doesNotMeetPreference solutions (top options for the problem)
			 for (Solution solution : dilemma.getResolution().getSolutions()) {
			 	if (solution.getStatus().equals(doesNotMeetPreference)) {
			 		String key = solution.getSolutionRef();
			 		RemyTransitEvent transitEvent = map.get(key);
			 		sortedTransportation.add(transitEvent);
			 	}
			 }
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e.getMessage());
		}

		return sortedTransportation;
	}

	/**
	 * Insert recommended transportation into the RemyRecommendationsEvent, then
	 * insert the RemyRecommendationsEvent object between the specified pair
	 * of events.
	 *
	 * @param itinerary The itinerary for injecting recommendations.
	 * @param events The pair of events between which transportation is being
	 * recommended.
	 * @param transitRecommendations A RemyRecommendationsEvent containing an
	 * appropriate message for the front-end user.
	 * @param transportation A list of recommended transportation.
	 */
	private static void injectTransportationRecommendations(RemyItinerary itinerary, Pair events, RemyRecommendationsEvent transitRecommendations, List<RemyTransitEvent> transportation) {
		// convert RemyRestaurantEvent objects to RemyEvent objects
		List<RemyEvent> recommendations = new ArrayList<RemyEvent>();
		for (RemyTransitEvent transitOptions : transportation) {
			recommendations.add((RemyEvent) transitOptions);
		}

		// get day of given event - we'll use the first one
		RemyEventDate eventDate = null;
		for (RemyEventDate dateCandidate : itinerary.getAllDates()) {
			for (RemyEvent eventCandidate : dateCandidate.getEvents()) {
				if (events.firstEvent.getId().equals(eventCandidate.getId())) {
					eventDate = dateCandidate;
				}
			}
		}
		
		// Update recommendations event
		if (transportation.size() > 0) {
			transitRecommendations.setRecommendationList(recommendations);
		}
		
		// Inject it into the date we found.
		eventDate.addEvent(transitRecommendations);
		
		// Now sort all the events.
		itinerary.sortAllEvents();
	}
}
