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
import java.util.Date;
import java.util.Map;

import com.google.gson.Gson;
import com.google.gson.internal.LinkedTreeMap;
import com.ibm.ra.remy.common.model.RemyEvent;
import com.ibm.ra.remy.common.utils.DateUtils;

/**
 * Class to represent an event meeting in our data model. 
 */
@SuppressWarnings("unused")
public class RemyMeetingEvent extends RemyEventImpl implements RemyEvent, Serializable {
	
	private static final long serialVersionUID = 1L;
	
	// These items are specific to meeting events.
	private String meetingName;
	private GooglePlacesLocation geometry;
	private String vicinity;
	private boolean isOutdoor;
	private Long time;
	private String imageUrl;
	
	/**
	 * Constructor that will generate a RemyMeetingEvent object with the given data.  To fully create the object, the Map
	 * provided should contain the following keys:
	 * 
	 *     Key                  Type     Value
	 *     
	 * Values needed by the CloudantObject parent class.
	 *     
	 *     _id                  String   Sets the objects unique ID
	 *     type                 String   Sets the objects type
	 *     _rev                 String   Sets the revision of the object. This corresponds to the revision in Cloudant.
	 *     
	 * Values needed by the parent RemyEventImpl class.
	 *     
	 *     subtype              String   The sub-type of this event.  Usually one of the following: flight, restaurant, transit
	 *     start_time           Long     The start time for this event. Before being returned to the client this will represent the 
	 *                                   number of milliseconds from the Epoch.  At class creation time will actually be an offset
	 *                                   representing some time in the future.  This value will be added to midnight of todays date
	 *                                   to represent the full time from the Epoch. So setting this value to 86400000l (24 hours in
	 *                                   milliseconds) will end up showing up as midnight tomorrow on the client that gets this event.
	 *     end_time             Long     The end time for this event.  Like the start_time described above this is actually an offset
	 *                                   representing a time in the future.
	 *                   
	 * Keys required for this class
	 * 
	 *     meeting              String   The name of this meeting to be displayed on the itinerary.
	 *     vicinity             String   The street address for this event.
	 *     isOutdoor            Boolean  States whether this event venue is outdoors or not.
	 *     time                 Long     The start time of this meeting.  Stored in milliseconds. This should be a time in the future
	 *                                   stored as an offset from midnight today.
	 *     geometry             GooglePlacesLocation This is a Map that should be used to create a {@link com.ibm.ra.remy.common.impl.GooglePlacesLocation GooglePlacesLocation}
	 *                                               object.  See it for more information about what's needed.
	 *     imageUrl             String   A string pointing to a url that depicts an image of the event location.
	 * 
	 * @param data The Map that should contain the keys described above to properly construct this object.
	 * @param itineraryId The id of the itinerary that owns this event.
	 */
	@SuppressWarnings("unchecked")
	public RemyMeetingEvent(Map<String, Object> data, String itineraryId) {
		super(data, itineraryId);
		this.meetingName = (String) data.get("meetingName");
		this.vicinity = (String) data.get("vicinity");
		this.isOutdoor = (boolean) data.get("isOutdoor");
		this.time = ((Double)data.get("time")).longValue();
		this.geometry = new GooglePlacesLocation((LinkedTreeMap<String, Object>) data.get("geometry"));
		this.imageUrl = (String) data.get("imageUrl");
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyEvent#fixTime()
	 */
	@Override
	public void fixTime() {
		super.fixTime();
		Date baseline = DateUtils.generalizeTime(new Date());
		time += baseline.getTime();
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
		return super.getItineraryId();
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyEvent#getTime()
	 */
	@Override
	public long getTime() {
		return super.getTime();
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyEvent#getSubtype()
	 */
	@Override
	public String getSubtype() {
		return super.getSubtype();
	}
	
	/**
	 * Return the geometry of this meeting event.
	 * @return The event's geometry.
	 */
	public GooglePlacesLocation getGeometry() {
		return this.geometry;
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyEvent#isOutdoor()
	 */
	@Override
	public boolean isOutdoor() {
		return isOutdoor;
	}

}
