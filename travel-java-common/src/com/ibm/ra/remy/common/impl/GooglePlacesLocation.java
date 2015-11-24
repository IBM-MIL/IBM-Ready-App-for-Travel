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
 * Class that mimics the location that is returned from a Google Places API query.
 */
public class GooglePlacesLocation implements RemyLocation, Serializable {

	private static final long serialVersionUID = 1L;
	private LatLong location;
	/**
	 * These two members are mainly here for completion but don't actually come from Google Places API
	 */
	private String city;
	private String country;
	
	/**
	 * Default constructor.  Sets all the member values to their types default values. 
	 */
	public GooglePlacesLocation() {
		super();
	}
	
	/**
	 * Creates a GooglePlacesLocation object from the associated Map object.  The following keys are required to exist in the Map
	 * in order to correctly setup the object.
	 * 
	 *     Key       Type                  Value
	 *     
	 *     location  Map<String, Object>   This is itself a map containing the keys needed to create this object.
	 *     
	 * Keys used for getting data from the internal location object.
	 * 
	 *     lat		 Double				   The latitude of this location.
	 *     lng		 Double				   The longitude of this location.
	 *     city		 String				   The city of this location.
	 *     country	 String				   The country of this location.
	 * 
	 * @param data The Map used to seed the object.
	 */
	public GooglePlacesLocation(Map<String, Object> data) {
		super();
		@SuppressWarnings("unchecked")
		Map<String, Object> location = (Map<String, Object>) data.get("location");
		if (location != null) {
			this.location = new LatLong((Double)location.get("lat"), (Double)location.get("lng"));
			if (location.containsKey("city")) {
				this.city = (String)location.get("city");
			}
			if (location.containsKey("country")) {
				this.country = (String)location.get("country");
			}
		}
	}

//  These functions removed for compatibility with Business Rules.
//
//	/**
//	 * @see com.ibm.ra.remy.common.model.RemyLocation#getLatitude()
//	 */
//	@Override
//	public double getLatitude() {
//		return location.getLat();
//	}
	
//	/**
//	 *
//	 * @see com.ibm.ra.remy.common.model.RemyLocation#getLongitude()
//	 */
//	@Override
//	public double getLongitude() {
//		return location.getLng();
//	}
	
	/**
	 * Get the location.
	 * @return The location.
	 */
	public LatLong getLocation() {
		return this.location;
	}
	
	/** 
	 * Set the location.
	 * @param location The new location.
	 */
	public void setLocation(LatLong location) {
		this.location = location;
	}
	
	/**
	 * 
	 * @see java.lang.Object#toString()
	 */
	public String toString() {
		return new Gson().toJson(this);
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyLocation#getCity()
	 */
	@Override
	public String getCity() {
		return this.city;
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyLocation#getCountry()
	 */
	@Override
	public String getCountry() {
		return this.country;
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyLocation#setCity(java.lang.String)
	 */
	@Override
	public void setCity(String city) {
		this.city = city;
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyLocation#setCountry(java.lang.String)
	 */
	@Override
	public void setCountry(String country) {
		this.country = country;
	}
}
