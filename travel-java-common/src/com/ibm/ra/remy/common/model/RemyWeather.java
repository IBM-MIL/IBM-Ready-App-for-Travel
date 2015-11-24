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
 * Generic data structure to hold data that we want to keep when we make a Weather Underground API call. This is all 
 * we really need for our data model. The time component here is actually stored as an offset from midnight today. This
 * makes it easy to associate this weather event with a timeframe in the future.
 */
public interface RemyWeather {
	/**
	 * Gets the date and time for which this weather event belongs.
	 * @return Milliseconds representing the date and time this weather event belongs too.
	 */
	public long getDate();
	/**
	 * The temperature associated with this weather event.
	 * @param metric boolean specifying that we should keep the metric (if true) or American standard units 
	 * @return The Temperature in the desired units.
	 */
	public String getTemperature(boolean metric);
	/**
	 * Gets the weather conditions for this time period. Weather conditions are strings like "rainy", "cloudy", etc.
	 * @return The weather conditions for this time period.
	 */
	public String getCondition();
	/**
	 * The location where this weather is predicted
	 * @return The location where this weather is predicted.
	 */
	public RemyLocation getLocation();
	/**
	 * Sets the location for where this weather is being predicted. 
	 * @param location The location to associate with this weather.
	 */
	public void setLocation(RemyLocation location);
	/**
	 * Converts the stored offset time to a real point in time.
	 */
	public void fixTime();
}
