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

import com.ibm.ra.remy.common.impl.RemyRecommendationsEvent;
import com.ibm.ra.remy.common.impl.RemyRestaurantEvent;
import com.ibm.ra.remy.common.model.RemyEvent;
import com.ibm.ra.remy.common.model.RemyEventDate;
import com.ibm.ra.remy.common.model.RemyItinerary;
import com.ibm.ra.remy.common.model.RemyRecs;

/**
 * This class captures features related to weather recommendations and
 * also aids in programmatically generating itinerary versions for an
 * MVP demonstration application.
 * 
 * Example Use:
 * 1. Start with an itinerary that includes outdoor events on the third day.
 * 2. Call injectBadWeather to set the third day to "Rainy."
 * 3. Call recommendWeatherAlternatives to inject an alert and recommended
 *        alternative events.
 * 4. Call chooseWeatherAlternative to generate a new itinerary version
 *        that contains a "user-chosen" weather recommendation.
 */

public class RecEngineWeather {
	
	private static final String USERNAME_KEY="PI_USERNAME";
	private static final String PASSWORD_KEY="PI_PASSWORD";
	private static final String USER1_TEXT_KEY="USER1_TEXT";
	private static final String RESTAURANT1_TEXT_KEY="RESTAURANT1_TEXT";
	private static final String RESTAURANT2_TEXT_KEY="RESTAURANT2_TEXT";
	private static final String RESTAURANT3_TEXT_KEY="RESTAURANT3_TEXT";
	private static final String RESTAURANT4_TEXT_KEY="RESTAURANT4_TEXT";
	private static final String RESTAURANT5_TEXT_KEY="RESTAURANT5_TEXT";

	/**
	 * Inject bad weather into the given itinerary, according to the user's
	 * story.
	 * 
	 * @param itinerary An itinerary with good weather.
	 * @return A copied itinerary with bad weather injected according to the
	 * user's story.
	 */
	public static RemyItinerary injectBadWeather(RemyItinerary itinerary) {
		RemyItinerary updatedItinerary = (RemyItinerary) DeepCopy.copy(itinerary);
		RemyEventDate thirdDay = updatedItinerary.getAllDates().get(2);
		thirdDay.setCondition("Rain");
		return updatedItinerary;
	}
	
	/**
	 * Process an itinerary to determine whether any events may be affected
	 * by inclement weather. If so, then inject an alert message into the
	 * affected event(s), along with recommendations for alternative event
	 * locations.
	 * 
	 * @param itinerary An itinerary that may contain events affected by
	 * inclement weather.
	 * @param options The available options that can be recommended.
	 * @param locale The requested locale.
	 * @return A copied itinerary with weather recommendations injected.
	 */
	public static RemyItinerary recommendWeatherAlternatives(RemyItinerary itinerary, RemyRecs options, String locale) {
		RemyItinerary updatedItinerary = (RemyItinerary) DeepCopy.copy(itinerary);
		List<RemyEvent> affectedEvents = identifyEventsAffectedByWeather(updatedItinerary);
		for (RemyEvent affectedEvent : affectedEvents) {
			List<RemyRestaurantEvent> alternatives = lookupAlternatives(options);
			List<RemyRestaurantEvent> sortedAlternatives = null;
			try {
				sortedAlternatives = sortAlternatives(alternatives);
			} catch(Exception ex) {
				sortedAlternatives = alternatives;
			}
			
			injectWeatherAlternatives(updatedItinerary, affectedEvent, options.getRestaurantRecs(), sortedAlternatives);
		}
		return updatedItinerary;
	}
	
	/**
	 * This function chooses an alternative event location according to the
	 * user's story for any events affected by inclement weather.
	 * 
	 * @param itinerary An itinerary containing an event that may be affected
	 * by inclement weather, along with an alert message and recommended
	 * alternative locations.
	 * @return A copied itinerary containing an updated location for the event
	 * that may be affected by inclement weather. (The alert message and
	 * recommendations are removed.)
	 */
	public static RemyItinerary chooseWeatherAlternative(RemyItinerary itinerary) {
		RemyItinerary updatedItinerary = (RemyItinerary) DeepCopy.copy(itinerary);
		
		// We'll grab the restaurant event that needs to be replaced. It's the only one with
		// a recommendation event buried in it.
		RemyEventDate recDate = null;
		RemyRecommendationsEvent recList = null;
		RemyRestaurantEvent restaurantEvent = null;
		for (RemyEventDate d : updatedItinerary.getAllDates()) {
			for (RemyEvent e : d.getEvents()) {
				if (RemyEvent.RESTAURANT.equals(e.getSubtype())) {
					if (((RemyRestaurantEvent) e).getRecommendedReplacements() != null) {
						recDate = d;
						restaurantEvent = (RemyRestaurantEvent) e;
						recList = restaurantEvent.getRecommendedReplacements();
					}
				}
			}
		}
		// Now remove it from the itinerary.
		recDate.removeEvent(restaurantEvent);
		
		// We can now add the restaurant event we chose, and sort the events.
		RemyRestaurantEvent recommendedRestaurant = (RemyRestaurantEvent) recList.getRecommendationList().get(0);
		recDate.addEvent(recommendedRestaurant);
		
		updatedItinerary.sortAllEvents();
		return updatedItinerary;
	}
	
	/**************************************************************************
	 * Helper Functions
	 *************************************************************************/
	
	/**
	 * This function tags all events in an itinerary that may be affected
	 * by weather. For each event, the affectedByWeather instance variable
	 * is set to either true or false, accordingly.
	 *
	 * @param itinerary An itinerary.
	 */
	private static List<RemyEvent> identifyEventsAffectedByWeather(RemyItinerary itinerary) {
		List<RemyEvent> affectedEvents = new ArrayList<RemyEvent>();
		for (RemyEventDate date : itinerary.getAllDates()) {
			for (RemyEvent event : date.getEvents()) {
				if (event.isOutdoor() && date.getCondition().equals("Rain")) {
					event.setAffectedByWeather(true);
					affectedEvents.add(event);
				}
			}
		}
		return affectedEvents;
	}

	/**
	 * Search for available alternatives to an event that may be affected
	 * by weather.
	 *
	 * For this MVP, we simply use a hard-coded set of alternative
	 * restaurant options that are returned from the database. In a
	 * real implementation, this function might call a POI API to
	 * dynamically load alternative options.
	 *
	 * @param options An object that includes hard-coded restaurants
	 * alternatives.
	 */
	private static List<RemyRestaurantEvent> lookupAlternatives(RemyRecs options) {
		List<RemyRestaurantEvent> alternatives = new ArrayList<RemyRestaurantEvent>();
		if (options.getRestaurantRecs() != null) {
			for (RemyEvent event : options.getRestaurantRecs().getRecommendationList()) {
				alternatives.add((RemyRestaurantEvent) event);
			}
		}
		return alternatives;
	}

	/**
	 * Sort the hotel bookings. For this MVP, we simply move any loyalty
	 * bookings to the front of the list, followed by any promotional
	 * bookings without loyalty discounts, then all the remaining
	 * bookings.
	 * 
	 * @param bookings An unsorted list of recommended hotel bookings.
	 * @return A sorted list of recommended hotel bookings.
	 */

	/**
	 * Sort the recommended transportation alternatives using Watson Personality
	 * Insights. Representative text of the user and of each alternative event
	 * is analyzed by Watson Personality Insights to compute a personality.
	 * Alternative events are then sorted according to their similarity of their
	 * personality to the user's personality.
	 *
	 * @param alternatives A list of alternatives to recommend, which will be
	 * sorted according to their similarity to the user's personality.
	 */
	private static List<RemyRestaurantEvent> sortAlternatives(List<RemyRestaurantEvent> alternatives) {
		// get credentials for Personality Insights
		PropertiesReader constants = PropertiesReader.getInstance();
		String username = constants.getStringProperty(USERNAME_KEY);
		String password = constants.getStringProperty(PASSWORD_KEY);

		// get representational text of user and each alternative
		// (we would normally scrape these websites live, but for
		// consistency between demos, we have pre-scraped by using
		// jaunt and then searching for each paragraph on the page)
		String userText = constants.getStringProperty(USER1_TEXT_KEY);
		String alternative1Text = constants.getStringProperty(RESTAURANT1_TEXT_KEY);
		String alternative2Text = constants.getStringProperty(RESTAURANT2_TEXT_KEY);
		String alternative3Text = constants.getStringProperty(RESTAURANT3_TEXT_KEY);
		String alternative4Text = constants.getStringProperty(RESTAURANT4_TEXT_KEY);
		String alternative5Text = constants.getStringProperty(RESTAURANT5_TEXT_KEY);

		// analyze personality of user and each alternative
		PersonalityProfile userProfile = new PersonalityProfile(username, password, userText);
		PersonalityProfile alternative1Profile = new PersonalityProfile(username, password, alternative1Text);
		PersonalityProfile alternative2Profile = new PersonalityProfile(username, password, alternative2Text);
		PersonalityProfile alternative3Profile = new PersonalityProfile(username, password, alternative3Text);
		PersonalityProfile alternative4Profile = new PersonalityProfile(username, password, alternative4Text);
		PersonalityProfile alternative5Profile = new PersonalityProfile(username, password, alternative5Text);

		// construct collection of profiles
		List<PersonalityProfile> alternativeProfiles = new ArrayList<PersonalityProfile>();
		alternativeProfiles.add(alternative1Profile);
		alternativeProfiles.add(alternative2Profile);
		alternativeProfiles.add(alternative3Profile);
		alternativeProfiles.add(alternative4Profile);
		alternativeProfiles.add(alternative5Profile);

		// map profiles to their event
		HashMap<PersonalityProfile, RemyRestaurantEvent> map = new HashMap<PersonalityProfile, RemyRestaurantEvent>();
		int mappings = Math.min(alternatives.size(), alternativeProfiles.size());
		for (int i = 0; i < mappings; i++) {
			map.put(alternativeProfiles.get(i), alternatives.get(i));
		}

		// sort profiles according to their similarity to the user
		int k = alternativeProfiles.size();
		List<PersonalityProfile> sortedAlternativeProfiles = userProfile.kNearestNeighbors(k, alternativeProfiles);

		// sort alternatives according to their similarity to the user
		List<RemyRestaurantEvent> sortedAlternatives = new ArrayList<RemyRestaurantEvent>();
		for (int i = 0; i < mappings; i++) {
			PersonalityProfile profile = sortedAlternativeProfiles.get(i);
			RemyRestaurantEvent alternative = map.get(profile);
			sortedAlternatives.add(alternative);
		}

		return sortedAlternatives;
		// return alternatives;
	}

	/**
	 * Inject recommended alternatives for the specified event into the
	 * itinerary. We assume that the event may be affected by inclement
	 * weather. A RemyRecommendationsEvent object is constructed from the
	 * given alternatives and injected immediately after the specified event.
	 * 
	 * @param itinerary An itinerary containing the specified event.
	 * @param event An event that may be affected by inclement weather.
	 * @param message The message to display on the itinerary screen.
	 * @param alternatives The list of possible alternative events to suggest.
	 */
	private static void injectWeatherAlternatives(RemyItinerary itinerary, RemyEvent event, RemyRecommendationsEvent weatherRecommendations, List<RemyRestaurantEvent> alternatives) {
		// convert RemyRestaurantEvent objects to RemyEvent objects
		List<RemyEvent> recommendations = new ArrayList<RemyEvent>();
		for (RemyRestaurantEvent alternative : alternatives) {
			recommendations.add((RemyEvent) alternative);
		}
		
		// Update recommendations event
		if (alternatives.size() > 0) {
			weatherRecommendations.setRecommendationList(recommendations);
		}
		
		// Inject recommendations event into the postponed restaurant event
		((RemyRestaurantEvent) event).setRecommendedReplacements(weatherRecommendations);
	}
}
