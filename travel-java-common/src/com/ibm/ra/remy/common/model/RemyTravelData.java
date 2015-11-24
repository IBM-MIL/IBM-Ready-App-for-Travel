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

import java.util.List;
import com.ibm.ra.remy.common.model.RemyItinerary;

/**
 * Object that represents the travel data for a given user. Right now this just encompasses a list of itineraries.
 */
public interface RemyTravelData {
	/**
	 * The list of itineraries for this user
	 * @return The list of itineraries that belongs to this user.
	 */
	public List<RemyItinerary> getItineraries();
	/**
	 * Adds the given itinerary to the users list.
	 * @param newItin The itinerary to add to the list
	 */
	public void addItinerary(RemyItinerary newItin);
	/**
	 * Converts the stored offset time to a real point in time.
	 */
	public void fixTime();
}
