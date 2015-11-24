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

import com.ibm.ra.remy.common.impl.RemyRecommendationsEvent;

/**
 * Interface thats primarily used internally to capture all the recommendation events that pertain to a given user.
 * This makes it easier to place the recommendations in the correct place in the itinerary and also to conveniently have
 * them in one place.
 */
public interface RemyRecs {
	/**
	 * Gets the user name of the user that these recommendations belong too.
	 * @return The unique user name of the user.
	 */
	public String getUser();
	/**
	 * Returns a list of transit events that belong to this user.
	 * @return The list of transit recommendations for this user.
	 */
	public RemyRecommendationsEvent getTransitRecs();
	/**
	 * Sets a list of transit events that belong to this user.
	 * @param transitRecs The new list of transit events.
	 */
	public void setTransitRecs(RemyRecommendationsEvent transitRecs);
	/**
	 * The list of restaurant recommendations for this user.
	 * @return List of restaurant recommendations.
	 */
	public RemyRecommendationsEvent getRestaurantRecs();
	/**
	 * Sets a list of restaurant events that belong to this user.
	 * @param restaurantRecs The new list of restaurant events.
	 */
	public void setRestaurantRecs(RemyRecommendationsEvent restaurantRecs);
	/**
	 * The list of lodging recommendations for this user.
	 * @return The list of lodging recommendations.
	 */
	public RemyRecommendationsEvent getLodgingRecs();
	/**
	 * Sets a list of lodging events that belong to this user.
	 * @param lodgingRecs The new list of lodging events.
	 */
	public void setLodgingRecs(RemyRecommendationsEvent lodgingRecs);
	/**
	 * Adds a new recommendation to the correct list of recommendations.
	 * @param newRec The new recommendation to add.
	 */
	public void addRec(RemyEvent newRec);
	/**
	 * Converts the stored offset time to a real point in time.
	 */
	public void fixTime();
}
