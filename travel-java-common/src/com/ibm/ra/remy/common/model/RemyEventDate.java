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

/**
 * Class that represents a single day in the Itinerary of a user. This class mainly consists of the events that belong
 * to a given day, some data pertinent to that day like the weather, and the actual date this object repesents.
 */
public interface RemyEventDate {
	/**
	 * Gets the date this object represents, in milliseconds from the Epoch.
	 * @return The milliseconds from the epoch
	 */
	public long getDate();
	/**
	 * Gets all the events for this date
	 * @return A list of all the events associated with this date.
	 */
	public List<RemyEvent> getEvents();
	/**
	 * Adds the given event to this date
	 * @param event The event to add
	 */
	public void addEvent(RemyEvent event);
	/**
	 * Removes an event from this date
	 * @param event The event to remove
	 */
	public void removeEvent(RemyEvent event);
	/**
	 * Sets the temperatures for this date
	 * @param tempHigh The high temperature to set
	 * @param tempLow The low temperature to set
	 */
	public void setTemperature(String tempHigh, String tempLow);
	/**
	 * Sorts the events by some custom method
	 */
	public void sortEvents();
	/**
	 * Gets the current high temperature for this date
	 * @return The current high temperature
	 */
	public String getHighTemperature();
	/**
	 * Gets the current low temperature for this date
	 * @return The current low temperature
	 */
	public String getLowTemperature();
	/**
	 * Gets the current weather conditions for this date.
	 * @return The current weather conditions
	 */
	public String getCondition();
	/**
	 * Sets the current weather conditions for this date.  An example of a weather condition is rainy, sunny, etc.
	 * @param condition The weather condition for this day.
	 */
	public void setCondition(String condition);
	/**
	 * Converts the stored offset time to a real point in time.
	 */
	public void fixTime();
}
