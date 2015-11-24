/* 
 * Licensed Materials - Property of IBM © Copyright IBM Corporation 2015. All
 * Rights Reserved. This sample program is provided AS IS and may be used,
 * executed, copied and modified without royalty payment by customer (a) for its
 * own instruction and study, (b) in order to develop applications designed to
 * run with an IBM product, either for customer's own internal use or for
 * redistribution by customer, as part of such an application, in customer's own
 * products.
 */

package com.ibm.ra.remy.common.model;

/**
 * Interface representing a Remy event in Cloudant.  There are multiple types of events, namely:
 * 
 *     1. Restaurant
 *     2. Flight
 *     3. Meeting
 *     4. Transit
 *     5. Recommendation
 *     6. Hotel
 *     
 * Each of these has multiple fields that need to be returned to the front end yet we do not use on the back end. 
 */
public interface RemyEvent {
	public static final String RESTAURANT = "restaurant";
	public static final String FLIGHT = "flight";
	public static final String MEETING = "meeting";
	public static final String TRANSIT = "transit";
	public static final String LODGING = "lodging";
	public static final String RECOMMENDATIONS = "recommendations";
	public static final String EVENT = "event";
	public static final String ITINERARY = "itinerary";

	public static final String RECOMMENDATION_TYPE = "recs";
	public static final String SUBTYPE_KEY = "subtype";
	public static final String TYPE_KEY = "type";
	public static final String RECTYPE_KEY = "rec_type";
	public static final String HOTEL_CHECKIN = "checkin";
	public static final String HOTEL_STAY = "stay";
	public static final String HOTEL_CHECKOUT = "checkout";
	
	/**
	 * Gets the ID for the given event.
	 * @return The id for this event.
	 */
	public String getId();
	
	/**
	 * Gets the type for this event.
	 * @return The type for the event.
	 */
	public String getType();
	/**
	 * The ID of the itinerary that this event belongs too.
	 * @return The ID of the owning itinerary.
	 */
	public String getItineraryId();
	/**
	 * Returns the current time associated with this event.
	 * @return The time of this event.
	 */
	public long getTime();
	/**
	 * Retrieves the sub type of this event.
	 * @return The sub type of this event.
	 */
	public String getSubtype();
	/**
	 * Converts the stored offset time to a real point in time.
	 */
	public void fixTime();
	/**
	 * Returns whether the given event is outdoors.
	 * @return If the event is outdoors, then true. Otherwise, false.
	 */
	public boolean isOutdoor();
	/**
	 * Returns whether the given event is affected by weather.
	 * @return If the event is affected by weather, then true. Otherwise, false.
	 */
	public boolean getAffectedByWeather();
	/**
	 * Sets whether the given event is affected by weather.
	 * @param affectedByWeather A boolean representing whether the event
	 * is affected by weather.
	 */
	public void setAffectedByWeather(boolean affectedByWeather);
}
