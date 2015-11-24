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
 * Represents a generic location object.  This does not correspond to any location object from any service that we
 * communicate with.  Its just a local application representation.
 */
public interface RemyLocation {

//  These functions removed for compatibility with Business Rules.
//
//	/**
//	 * Gets the latitude for this location. Positive numbers represent northern latitudes while negative numbers 
//	 * represent southern latitudes.
//	 * @return The latitude for this location.
//	 */
//	public double getLatitude();
//	/**
//	 * Gets the longitude for this location. Positive numbers represent eastern latitudes while negative numbers 
//	 * represent western latitudes.
//	 * @return
//	 */
//	public double getLongitude();
	/**
	 * Represents the city in which this location lies.  No city set means this location lies outside of a populated area
	 * @return The city where this location lives
	 */
	public String getCity();
	/**
	 * Represents the country in which this location lies.
	 * @return The country where this location lives
	 */
	public String getCountry();
	/**
	 * Sets the city for this location
	 * @param city The city for this location.
	 */
	public void setCity(String city);
	/**
	 * Sets the country for this location
	 * @param country The country to set for this location
	 */
	public void setCountry(String country);
}
