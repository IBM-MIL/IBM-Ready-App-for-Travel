/* 
 * Licensed Materials - Property of IBM © Copyright IBM Corporation 2015. All
 * Rights Reserved. This sample program is provided AS IS and may be used,
 * executed, copied and modified without royalty payment by customer (a) for its
 * own instruction and study, (b) in order to develop applications designed to
 * run with an IBM product, either for customer's own internal use or for
 * redistribution by customer, as part of such an application, in customer's own
 * products.
 */

package com.ibm.ra.remy.common.impl;

import java.io.Serializable;

import com.google.gson.Gson;

/**
 * Simple class to contain the latitude and longitude retrieved from Google Places API 
 */
public class LatLong implements Serializable {

	private static final long serialVersionUID = 1L;
	private double lat;
	private double lng;
	
	/**
	 * Default constructor
	 */
	public LatLong () { super(); }
	
	/**
	 * Constructor which takes two parameters representing latitude and longitude and sets these fields appropriately.
	 * Negative latitude numbers are for southern latitudes while negative longitude numbers are for western latitudes
	 * 
	 * @param lat The latitude value to set
	 * @param lng The longitude value to set
	 */
	public LatLong(double lat, double lng) {
		super();
		this.lat = lat;
		this.lng = lng;
	}
	
	/**
	 * The latitude value for this LatLong object
	 * @return The latitude value.
	 */
	public double getLat() {
		return lat;
	}
	
	/**
	 * Set the latitude value for this LatLong object.
	 * @param lat The latitude value.
	 */
	public void setLat(double lat) {
		this.lat = lat;
	}
	
	/**
	 * Gets the longitude value from this LatLong object.
	 * @return The longitude value
	 */
	public double getLng() {
		return lng;
	}
	
	/**
	 * Set the longitude value for this LatLong object.
	 * @param lng The longitude value.
	 */
	public void setLng(double lng) {
		this.lng = lng;
	}
	
	/**
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return new Gson().toJson(this);
	}

	/**
	 * Return distance between this location and that location in meters.
	 * Source: http://introcs.cs.princeton.edu/java/44st/Location.java.html
	 * @param that The location to which distance should be measured.
	 * @return A double representing the distance, in meters, between this
	 * location and that location.
	 */
	public double distanceTo(LatLong that) {
        double STATUTE_MILES_PER_NAUTICAL_MILE = 1.15077945;
        double METERS_PER_STATUTE_MILES = 1609.34;
        double lat1 = Math.toRadians(this.getLat());
        double lon1 = Math.toRadians(this.getLng());
        double lat2 = Math.toRadians(that.getLat());
        double lon2 = Math.toRadians(that.getLng());

        // great circle distance in radians, using law of cosines formula
        double angle = Math.acos(Math.sin(lat1) * Math.sin(lat2)
                               + Math.cos(lat1) * Math.cos(lat2) * Math.cos(lon1 - lon2));

        // each degree on a great circle of Earth is 60 nautical miles
        double nauticalMiles = 60 * Math.toDegrees(angle);
        double statuteMiles = STATUTE_MILES_PER_NAUTICAL_MILE * nauticalMiles;
        double meters = METERS_PER_STATUTE_MILES * statuteMiles;
        return meters;
    }
}
