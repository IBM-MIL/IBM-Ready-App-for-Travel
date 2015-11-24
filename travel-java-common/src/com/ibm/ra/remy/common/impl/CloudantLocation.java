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
import java.util.Map;

import com.google.gson.Gson;
import com.ibm.ra.remy.common.model.RemyLocation;

/**
 * Class that represents a generic Location.  Currently this object contains properties for the city and country
 * a Location belongs too as well as a more specific latitude and longitude entries.  
 */
public class CloudantLocation implements RemyLocation, Serializable {

	private static final long serialVersionUID = 1L;
	private String city;
	private String country;
	private double lat;
	private double lng;
	
	/**
	 * Default constructor. Creates an empty object with default values. Defaults are null for objects and 0 for numbers. 
	 */
	public CloudantLocation() { }
	
	/**
	 * Constructor that will create this object assuming the Map contains the keys we are looking for.
	 * 
	 *     Key            Type      Description for value
	 *     
	 *     city           String    The member in the class that represents the city.
	 *     country        String    The member in the class that represents the country.
	 *     lat            Double    The member in the class that represents the latitude.
	 *     lng            Double    The member in the class that represents the longitude.
	 *     
	 * Assuming the keys above are included the classes members are correctly given the appropriate values. 
	 * 
	 * @param data
	 */
	public CloudantLocation(Map<String, Object> data) {
		if (data != null) {
			city = (String )data.get("city");
			country = (String) data.get("country");
			Object tmp = data.get("lat");
			if (tmp != null) {
				lat = (Double) tmp;
			}
			tmp  = data.get("lng");
			if (tmp != null) {
				lng = (Double) tmp;
			}
			
		}
	}

	/**
	 * Returns the city where this location is situated.  May return null if no city is associated with this location.
	 */
	public String getCity() {
		return city;
	}

	/**
	 * Returns the country where this location is situated.  May return null if no country is associated with this location.
	 */
	public String getCountry() {
		return country;
	}
	
	/**
	 * Prints this class in JSON format
	 */
	public String toString() {
		return new Gson().toJson(this);
	}

	/**
	 * Returns the latitude where this location is situated.  May return 0 if no latitude is associated with this location.
	 */
	public double getLatitude() {
		return lat;
	}

	/**
	 * Returns the longitude where this location is situated.  May return 0 if no longitude is associated with this location.
	 */
	public double getLongitude() {
		return lng;
	}

	/**
	 * Sets the city where this location is situated.
	 */
	@Override
	public void setCity(String city) {
		this.city = city;
	}

	/**
	 * Sets the country where this location is situated.
	 */
	@Override
	public void setCountry(String country) {
		this.country = country;
	}
}
