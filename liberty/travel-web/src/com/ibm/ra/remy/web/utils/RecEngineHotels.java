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
import java.util.List;
import java.util.logging.Logger;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.ibm.ra.remy.common.impl.RemyLodgingEvent;
import com.ibm.ra.remy.common.impl.RemyRecommendationsEvent;
import com.ibm.ra.remy.common.model.RemyEvent;
import com.ibm.ra.remy.common.model.RemyEventDate;
import com.ibm.ra.remy.common.model.RemyItinerary;
import com.ibm.ra.remy.common.model.RemyRecs;

/**
 * This class captures features related to hotel recommendations and
 * also aids in programmatically generating itinerary versions for an
 * MVP demonstration application.
 * 
 * Example Use:
 * 1. Start with an itinerary that lacks lodging.
 * 2. Call recommendHotels() to generate a new itinerary version that
 *        contains hotel recommendations.
 * 3. Call chooseHotel() to generate a new itinerary version that
 *        contains a "user-chosen" hotel recommendations.
 */

public class RecEngineHotels {
	
	/**
	 * Process an itinerary to determine whether it contains sufficient
	 * lodging. If not, then recommend hotel bookings for the user to
	 * choose from, with available loyalty discounts applied. All
	 * recommended bookings will have the same check-in and check-out
	 * dates. Note that the given itinerary is not modified; instead,
	 * a new itinerary is returned that contains any recommendations.
	 * 
	 * @param itinerary An itinerary that may or may not contain lodging.
	 * @param options The set of options from which recommendations can be made.
	 * @return An updated itinerary that contains a hotel recommendation
	 * event injected at the end of the booking's first day.
	 */
	public static RemyItinerary recommendHotels(RemyItinerary itinerary, RemyRecs options, String locale) {
		RemyItinerary updatedItinerary = (RemyItinerary) DeepCopy.copy(itinerary);
		long[] bookingDates = recommendBookingDates(updatedItinerary);
		if (bookingDates.length == 2) {
			long checkIn = bookingDates[0];
			long checkOut = bookingDates[1];
			List<RemyLodgingEvent> bookings = lookupBookings(options, checkIn, checkOut);
			List<RemyLodgingEvent> adjustedBookings = new ArrayList<RemyLodgingEvent>();
			for (RemyLodgingEvent booking : bookings) {
				RemyLodgingEvent adjustedBooking = applyLoyaltyDiscounts(updatedItinerary.getUser(), booking, locale);
				adjustedBookings.add(adjustedBooking);
			}
			List<RemyLodgingEvent> sortedBookings = sortBookings(adjustedBookings);
			injectHotelRecommendations(updatedItinerary, options.getLodgingRecs(), sortedBookings);
		}
		return updatedItinerary;
	}
	
	/**
	 * This function chooses a hotel from a set of hotel booking
	 * recommendations based on the user's story. It also propagates the
	 * hotel event throughout the itinerary so it can be displayed at the
	 * appropriate times (check-in, stay, check-out).
	 * 
	 * @param itinerary An itinerary containing hotel recommendations.
	 * @return An itinerary containing a selected hotel booking (the hotel
	 * recommendations are removed from the itinerary).
	 */
	public static RemyItinerary chooseHotel(RemyItinerary itinerary, String locale) {
		RemyItinerary updatedItinerary = (RemyItinerary) DeepCopy.copy(itinerary);
		
		// We'll grab the injected hotel recommendation object first.
		RemyEventDate recDate = null;
		RemyRecommendationsEvent recList = null;
		for (RemyEventDate d : updatedItinerary.getAllDates()) {
			for (RemyEvent e : d.getEvents()) {
				if (RemyEvent.RECOMMENDATIONS.equals(e.getSubtype())) {
					if (RemyEvent.LODGING.equals(((RemyRecommendationsEvent) e).getRecType())) {
						recDate = d;
						recList = (RemyRecommendationsEvent) e;
					}
				}
			}
		}
		RemyLodgingEvent recommendedHotel = (RemyLodgingEvent) recList.getRecommendationList().get(0);
		// Now we can remove the recommendation list from the itinerary.
		recDate.removeEvent(recList);
		
		// Now we take the recommended hotel and propagate it through the itinerary,
		// adding a variety of events as needed.
		final long lengthOfDay = 86400000;
		long checkin = recommendedHotel.getCheckin();
		long checkout = recommendedHotel.getCheckout();
		for (RemyEventDate d : updatedItinerary.getAllDates()) {
			// In this scenario, we add a checkin event.
			if (d.getDate() <= checkin && (d.getDate() + lengthOfDay) < checkout) {
				RemyLodgingEvent checkinEvent = (RemyLodgingEvent) DeepCopy.copy(recommendedHotel);
				checkinEvent.setStart_time(checkin);
				checkinEvent.setEnd_time(checkin);
				checkinEvent.setDisplayType(RemyEvent.HOTEL_CHECKIN);
				d.addEvent(checkinEvent);
			}
			// In this scenario, we add a stay event.
			else if (checkin < d.getDate() && (d.getDate() + lengthOfDay) < checkout) {
				RemyLodgingEvent stayEvent = (RemyLodgingEvent) DeepCopy.copy(recommendedHotel);
				// We set the time to this so the hotel is always the last thing to appear.
				stayEvent.setStart_time(d.getDate() + lengthOfDay - 1);
				stayEvent.setEnd_time(d.getDate() + lengthOfDay - 1);
				stayEvent.setDisplayType(RemyEvent.HOTEL_STAY);
				d.addEvent(stayEvent);
			}
			// In this scenario, we add a checkout event.
			else if (checkin < d.getDate() && checkout < (d.getDate() + lengthOfDay)) {
				RemyLodgingEvent checkoutEvent = (RemyLodgingEvent) DeepCopy.copy(recommendedHotel);
				checkoutEvent.setStart_time(checkout);
				checkoutEvent.setEnd_time(checkout);
				checkoutEvent.setDisplayType(RemyEvent.HOTEL_CHECKOUT);
				d.addEvent(checkoutEvent);
			}
		}
		
		updatedItinerary.sortAllEvents();
		return updatedItinerary;
	}
	
	/**************************************************************************
	 * Helper Functions
	 *************************************************************************/
	
	/**
	 * Process an itinerary to determine whether it contains sufficient
	 * lodging. If not, then recommend check-in and check-out dates
	 * that can be used to search for available bookings.
	 * 
	 * For the MVP, this function simply scans the itinerary to determine
	 * whether the user has *any* lodging. If no events in the itinerary
	 * are of type RemyEvent.LODGING, then it recommends bookings for
	 * the duration of the event.
	 * 
	 * @param itinerary An itinerary that may or may not contain lodging.
	 * @return If lodging is *not* necessary, then the returned array
	 * of longs will be empty. Otherwise, the first element of the
	 * array will contain the recommended check-in date, while
	 * the second element of the array will contain the recommended
	 * check-out date.
	 */
	private static long[] recommendBookingDates(RemyItinerary itinerary) {
		for (RemyEventDate date : itinerary.getAllDates()) {
			for (RemyEvent event : date.getEvents()) {
				if (event.getSubtype() == RemyEvent.LODGING) {
					return new long[0];
				}
			}
		}
		long[] dates = {itinerary.getStartTime(), itinerary.getEndTime()};
		return dates;
	}
	
	/**
	 * Search for available hotel bookings.
	 * 
	 * For this MVP, we simply use a hard-coded set of possible bookings
	 * that are returned from the database. In a real implementation,
	 * this function might call a booking API with a check-in and
	 * check-out date to dynamically load available bookings.
	 * 
	 * @param options An object that includes hard-coded hotels to recommend.
	 * @param checkin A long representing the date of check-in.
	 * @param checkout A long representing the date of check-out.
	 * @return A list of bookings, represented as RemyLodgingEvents.
	 */
	private static List<RemyLodgingEvent> lookupBookings(RemyRecs options, long checkin, long checkout) {
		List<RemyEvent> bookingOptions = options.getLodgingRecs().getRecommendationList();
		List<RemyLodgingEvent> bookings = new ArrayList<RemyLodgingEvent>();
		for (RemyEvent bookingOption : bookingOptions) {
			RemyLodgingEvent booking = (RemyLodgingEvent) bookingOption;
			bookings.add(booking);
		}
		return bookings;
	}
	
	/**
	 * Use the user's loyalty information to apply any applicable loyalty
	 * discounts.
	 * 
	 * For this MVP, we simply use the user to lookup hard-coded hotels
	 * and loyalty programs. In the future, however, the user object can
	 * be expanded in order to support dynamic loyalty discounts.
	 * 
	 * @param user A string representing the user searching for hotel bookings.
	 * @param hotel A representation of the hotel booking to which any
	 * loyalty discounts should be applied.
	 */
	private static RemyLodgingEvent applyLoyaltyDiscounts(String user, RemyLodgingEvent booking, String locale) {
		String bookingJson = "{\"lodgingEvent\": " + new Gson().toJson(booking) + "}";
		RemyLodgingEvent adjustedBooking = booking;
		try {
			String adjustedBookingWrapperJson = BusinessRulesUtils.invokeRulesService(bookingJson);
			JsonObject adjustedBookingWrapperMap = new Gson().fromJson(adjustedBookingWrapperJson, JsonObject.class);
			String adjustedBookingJson = adjustedBookingWrapperMap.get("lodgingEvent").toString();
			adjustedBooking = new Gson().fromJson(adjustedBookingJson, RemyLodgingEvent.class);
		} catch (Exception e) {
			Logger logger = Logger.getLogger(RecommendationUtils.class.getName());
			MessageUtils mUtils = MessageUtils.getInstance();
			logger.warning(mUtils.getMessage("MSG0012", locale));
			logger.warning(e.getLocalizedMessage());
		}
		return adjustedBooking;
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
	private static List<RemyLodgingEvent> sortBookings(List<RemyLodgingEvent> bookings) {
		List<RemyLodgingEvent> sortedBookings = new ArrayList<RemyLodgingEvent>();
		
		// collect loyalty and promotional bookings
		for (RemyLodgingEvent booking : bookings) {
			if (booking.getIsLoyaltyMember() && booking.getHasPromotionalDiscount()) {
				sortedBookings.add(booking);
			}
		}
		
		// collect loyalty bookings
		for (RemyLodgingEvent booking : bookings) {
			if (booking.getIsLoyaltyMember() && !booking.getHasPromotionalDiscount()) {
				sortedBookings.add(booking);
			}
		}
		
		// collect promotional bookings
		for (RemyLodgingEvent booking : bookings) {
			if (!booking.getIsLoyaltyMember() && booking.getHasPromotionalDiscount()) {
				sortedBookings.add(booking);
			}
		}
		
		// collect all remaining bookings
		for (RemyLodgingEvent booking : bookings) {
			if (!booking.getIsLoyaltyMember() && ! booking.getHasPromotionalDiscount()) {
				sortedBookings.add(booking);
			}
		}
		
		return sortedBookings;
	}
	
	/**
	 * Insert bookings into the RemyRecommendationsEvent, then insert the
	 * RemyRecommendationsEvent object at the end of the booking's first day.
	 * 
	 * We assume that all bookings have a check-in day of the itinerary's
	 * first day. This should be generalized in order to support users who
	 * require bookings for multiple destinations or otherwise for multiple
	 * hotels during their stay.
	 * 
	 * We assume that the events for each itinerary day are already sorted.
	 * 
	 * The given itinerary is modified to include recommendations for hotels
	 * at the end of the first day on which a hotel booking is needed.
	 * 
	 * @param itinerary The itinerary for injecting recommendations.
	 * @param message The message that will be displayed to the user,
	 * representing this recommendations object within the itinerary view.
	 * @param bookings A sorted list of bookings to inject.
	 */
	private static void injectHotelRecommendations(RemyItinerary itinerary, RemyRecommendationsEvent hotelRecommendations, List<RemyLodgingEvent> bookings) {
		// convert RemyLodgingEvent objects to RemyEvent objects
		List<RemyEvent> recommendations = new ArrayList<RemyEvent>();
		for (RemyLodgingEvent recommendation : bookings) {
			recommendations.add((RemyEvent) recommendation);
		}
		
		// get first day events
		List<RemyEvent> firstDayEvents = null;
		if (itinerary != null && itinerary.getAllDates() != null) {
			if (!itinerary.getAllDates().isEmpty()) {
				RemyEventDate firstDay = itinerary.getAllDates().get(0);
				if (firstDay != null && firstDay.getEvents() != null) {
					firstDayEvents = firstDay.getEvents();
				}
			}
		}
		
		// update recommendations event
		if (bookings.size() > 0) {
			hotelRecommendations.setRecommendationList(recommendations);
		}
		
		// inject recommendations event into itinerary
		if (firstDayEvents != null && hotelRecommendations != null) {
			firstDayEvents.add(hotelRecommendations);
		}
		
		// sort itinerary to ensure proper ordering of events
		if (itinerary != null) {
			itinerary.sortAllEvents();
		}
	}
}
