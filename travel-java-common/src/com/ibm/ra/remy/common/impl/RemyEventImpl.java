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
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;
import com.google.gson.internal.LinkedTreeMap;
import com.ibm.ra.remy.common.model.RemyEvent;
import com.ibm.ra.remy.common.utils.DateUtils;

/**
 * Class to represent the most generic event type we can support in the app.  This really doesn't contain anything other
 * than the itinerary we should belong to and the type of the event along with the start and end time for the event.
 * This class is mainly used to contain common data and should never really be used as events tend to have more
 * information than can be stored here.  Please see any of the other Events that extend this class.
 */
@SuppressWarnings("unused")
public class RemyEventImpl extends CloudantObject implements RemyEvent, Serializable {

	private static final long serialVersionUID = 1L;
	private String itineraryId;
	private String subType;
	private Long start_time;
	private Long end_time;
	private boolean affectedByWeather;
	
	/**
	 * Default constructor that sets each of the classes fields to their default values.
	 */
	public RemyEventImpl() {
		super();
	}

	/**
	 * Constructor that will generate a RemyEventImpl object with the given data.  To fully create the object, the Map
	 * provided should contain the following keys:
	 *
	 *     Key         Type     Value
	 *     
	 * Values needed by the CloudantObject parent class.
	 *     
	 *     _id         String   Sets the objects unique ID
	 *     type        String   Sets the objects type
	 *     _rev        String   Sets the revision of the object. This corresponds to the revision in Cloudant.
	 *     
	 * Keys required by this class.
	 *     
	 *     subtype     String   The subtype of this event.  Usually one of the following: flight, restaurant, transit
	 *     start_time  Long     The start time for this event. Before being returned to the client this will represent the 
	 *                          number of milliseconds from the Epoch.  At class creation time will actually be an offset
	 *                          representing some time in the future.  This value will be added to midnight of todays date
	 *                          to represent the full time from the Epoch. So setting this value to 86400000l (24 hours in
	 *                          milliseconds) will end up showing up as midnight tomorrow on the client that gets this event.
	 *     end_time    Long     The end time for this event.  Like the start_time described above this is actually an offset
	 *                          representing a time in the future.
	 * 
	 * @param data The Map of data to use when seeding this object.
	 * @param itineraryId The id of the itinerary where this event belongs.
	 */
	public RemyEventImpl(Map<String, Object> data, String itineraryId) {
		super(data);
		if (data != null) {
			this.itineraryId = itineraryId;
			this.subType = (String) data.get("subtype");
			this.start_time = ((Double)data.get("start_time")).longValue();
			this.end_time = ((Double)data.get("end_time")).longValue();
		}
	}
	
	/**
	 * A constructor that creates a RemyEventImpl object by directly supplying the needed values as parameters.
	 * @param itineraryId The ID of the itinerary this event is associated with.
	 * @param subType The type of event.
	 * @param start_time The start time of the event.
	 * @param end_time The end time of the event.
	 */
	public RemyEventImpl(String itineraryId, String subType, long start_time, long end_time) {
		this.itineraryId = itineraryId;
		this.subType = subType;
		this.start_time = start_time;
		this.end_time = end_time;
		this.setType("event");
		this.set_rev("");
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyEvent#fixTime()
	 */
	@Override
	public void fixTime() {
		Date baseline = DateUtils.generalizeTime(new Date());
		start_time += baseline.getTime();
		end_time += baseline.getTime();
	}
	
	/**
	 * @see com.ibm.ra.remy.common.impl.CloudantObject#toString()
	 */
	@Override
	public String toString() {
		return new Gson().toJson(this);
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyEvent#getItineraryId()
	 */
	@Override
	public String getItineraryId() {
		return this.itineraryId;
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyEvent#getTime()
	 */
	@Override
	public long getTime() {
		return this.start_time;
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyEvent#getSubtype()
	 */
	@Override
	public String getSubtype() {
		return this.subType;
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyEvent#isOutdoor()
	 */
	@Override
	public boolean isOutdoor() {
		return false;
	}
	
	/**
	 * Setter method needed by the Bluemix Business Rules service.
	 * @param itineraryId The id of the parent itinerary.
	 */
	protected void setItineraryId(String itineraryId) {
		this.itineraryId = itineraryId;
	}
	
	/**
	 * Setter method needed by the Bluemix Business Rules service.
	 * @param start_time The start time of this event.
	 */
	protected void setStart_time(long start_time) {
		this.start_time = start_time;
	}
	
	/**
	 * Setter method needed by the Bluemix Business Rules service.
	 * @param end_time The end time of this event.
	 */
	protected void setEnd_time(long end_time) {
		this.end_time = end_time;
	}
	
	/**
	 * Getter method needed by the Bluemix Business Rules service.
	 * @return The end time of this event.
	 */
	protected long getEnd_time() {
		return this.end_time;
	}
	
	/**
	 * Setter method needed by the Bluemix Business Rules service.
	 * @param subType The subtype for this event.
	 */
	protected void setSubType(String subType) {
		this.subType = subType;
	}
	
	/**
	 * Returns whether the given event is affected by weather.
	 * @return If the event is affected by weather, then true. Otherwise, false.
	 */
	public boolean getAffectedByWeather() {
		return this.affectedByWeather;
	}
	
	/**
	 * Sets whether the given event is affected by weather.
	 * @param affectedByWeather A boolean representing whether the event
	 * is affected by weather.
	 */
	public void setAffectedByWeather(boolean affectedByWeather) {
		this.affectedByWeather = affectedByWeather;
	}
}
