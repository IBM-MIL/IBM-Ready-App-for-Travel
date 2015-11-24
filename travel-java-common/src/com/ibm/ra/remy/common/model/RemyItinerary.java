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

public interface RemyItinerary {
	/**
	 * Finds the RemyEventDate in this itinerary that corresponds to the given date being passed in. The date should be in
	 * milliseconds from the Epoch.
	 * @param date The date of the object we are looking for.
	 * @return The RemyEevntDate object that represents the given date.
	 */
	public RemyEventDate getDate(long date);
	/**
	 * Retrieves all the dates from this itinerary.
	 * @return The list of dates for this itinerary.
	 */
	public List<RemyEventDate> getAllDates();
	/**
	 * Adds a new date to the itinerary
	 * @param date The new date to add to the itinerary.
	 */
	public void addDate(RemyEventDate date);
	/**
	 * Gets the Cloudant ID for this itinerary
	 * @return The unique ID for this itinerary
	 */
	public String getId();
	/**
	 * Gets the user who owns this itinerary
	 * @return The user this itinerary belongs to
	 */
	public String getUser();
	/**
	 * Gets the start date for this itinerary, stored as milliseconds from the Epoch
	 * @return The start date for this itinerary.
	 */
	public long getStartTime();
	/**
	 * Gets the end date for this itinerary, stored as milliseconds from the Epoch.
	 * @return The end date for this itinerary
	 */
	public long getEndTime();
	/**
	 * Sorts all the events stored in this itinerary
	 */
	public void sortAllEvents();
	/**
	 * The version of this itinerary
	 * @return The itinerary version
	 */
	public int getVersion();
	/**
	 * Sets the version of this itinerary
	 * @param version The itinerary version to set
	 */
	public void setVersion(int version);
	/**
	 * Gets the departure location for this itinerary
	 * @return The departure location
	 */
	public RemyLocation getInitialLocation();
	/**
	 * Gets the title for this itinerary.
	 * @return The title of the itinerary
	 */
	public String getTitle();
	/**
	 * Converts the stored offset time to a real point in time.
	 */
	public void fixTime();
}
