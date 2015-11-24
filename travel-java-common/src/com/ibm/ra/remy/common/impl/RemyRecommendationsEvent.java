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
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;
import com.google.gson.internal.LinkedTreeMap;
import com.ibm.ra.remy.common.model.RemyEvent;
import com.ibm.ra.remy.common.utils.DateUtils;

/**
 * Class used to contain a Recommendation Event that is displayed on the front end. This class contains both the
 * data needed to show the small text entry in-lined in the itinerary 
 */
@SuppressWarnings("unused")
public class RemyRecommendationsEvent extends RemyEventImpl implements RemyEvent, Serializable {
	
	private static final long serialVersionUID = 1L;
	
	// These items are specific to recommendations events.
	private String rec_type;
	private String message;
	private List<RemyEvent> recommendationList;
	private boolean alert;
	private String associatedEventId;
	// Transit recommendations events have these two items in particular.
	private String fromLocation;
	private String toLocation;
	// Hotel recommendations have this location item.
	private String lodgingLocation;
	
	/**
	 * Default constructor.  Sets all members to their default values.
	 */
	public RemyRecommendationsEvent() {
		super();
	}
	
	/**
	 * Constructor. Sets all member values to the passed in values.
	 * @param itineraryId The ID of the itinerary that owns this recommendation event.
	 * @param start_time The start time of this recommendation event. Used to place the event amongst all the other events
	 *                   in the itinerary.
	 * @param end_time The end time for this event. Not really used/helpful
	 * @param rec_type The type of recommendation. One of the following: lodging, restaurant, transit.
	 * @param message The message that will be displayed inline in the itinerary basically begging them to click on this
	 *                event so we can show them our recommendations.
	 * @param alert An alert that tells the front end there is some sort of warning about this event.
	 * @param recommendationList The list of recommendations we have based on this 
	 */
	public RemyRecommendationsEvent(String itineraryId, long start_time, long end_time, String rec_type, String message, boolean alert, List<RemyEvent> recommendationList) {
		super(null, itineraryId);
		super.setStart_time(start_time);
		super.setEnd_time(end_time);
		super.setSubType(RECOMMENDATIONS);
		this.rec_type = rec_type;
		this.message = message;
		this.alert = alert;
		this.recommendationList = recommendationList;
	}
	
	/**
	 * Constructor that will generate a RemyRecommendationsEvent object with the given data.  To fully create the object, the Map
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
	 *     subtype              String   The subtype of this event.  Usually one of the following: flight, restaurant, transit
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
	 *     rec_type				String	 The type of RemyEvent being recommended.
	 *     message				String	 The text to be displayed on the itinerary along with this recommendation event.
	 *     alert				boolean	 Whether this is an emergency recommendation or not (for weather).
	 *     fromLocation			String	 For transit events, this indicates where the transit begins.
	 *     toLocation			String	 For transit events, this indicates where the transit ends.
	 *     lodgingLocation		String	 For lodging events, this indicates where the hotels are located generally.
	 * 
	 * @param data The Map that should contain the keys described above to properly construct this object.
	 * @param itineraryId The id of the itinerary that owns this event.
	 */
	public RemyRecommendationsEvent(Map<String, Object> data, String itineraryId) {
		super(data, itineraryId);
		this.rec_type = (String) data.get("rec_type");
		this.message = (String) data.get("message");
		this.alert = (boolean) data.get("alert");
		// todo: add support for parsing message?
		this.recommendationList = new ArrayList<RemyEvent>();
		this.fromLocation = (String) data.get("fromLocation");
		this.toLocation = (String) data.get("toLocation");
		this.lodgingLocation = (String) data.get("lodgingLocation");
	}

	/**
	 * @see com.ibm.ra.remy.common.impl.RemyEventImpl#fixTime()
	 */
	@Override
	public void fixTime() {
		super.fixTime();
		Date baseline = DateUtils.generalizeTime(new Date());
		if (recommendationList != null) {
			for (RemyEvent recommendation : recommendationList) {
				if (recommendation != null) {
					recommendation.fixTime();
				}
			}
		}
	}

	/**
	 * @see com.ibm.ra.remy.common.impl.RemyEventImpl#toString()
	 */
	@Override
	public String toString() {
		return new Gson().toJson(this);
	}

	/**
	 * Gets the type of event that is being recommended in this object.
	 * @return Which type of event is being recommended.
	 */
	public String getRecType() {
		return this.rec_type;
	}

	/**
	 * Gets the message to be displayed.
	 * @return The message to be displayed.
	 */
	public String getMessage() {
		return this.message;
	}

	/**
	 * Gets the list of recommended events.
	 * @return The list of recommended events.
	 */
	public List<RemyEvent> getRecommendationList() {
		return this.recommendationList;
	}
	
	/**
	 * Sets the list of recommended events.
	 * @param recommendationList The new list of recommended events.
	 */
	public void setRecommendationList(List<RemyEvent> recommendationList) {
		this.recommendationList = recommendationList;
	}
	
	/**
	 * Adds a RemyEvent to the list of recommended events.
	 * @param event The new event to be added to the recommendationList.
	 */
	public void addEvent(RemyEvent event) {
		this.recommendationList.add(event);
	}

	/**
	 * @see com.ibm.ra.remy.common.impl.RemyEventImpl#getSubtype()
	 */
	@Override
	public String getSubtype() {
		return super.getSubtype();
	}

	/**
	 * @see com.ibm.ra.remy.common.impl.RemyEventImpl#isOutdoor()
	 */
	@Override
	public boolean isOutdoor() {
		return false;
	}
	
	/**
	 * Gets the alert status of this event.
	 * @return The alert status of this event.
	 */
	public boolean isAlert() {
		return alert;
	}
	
	/**
	 * Gets the ID of the event associated with this recommendation (deprecated).
	 * @return The ID of the associated event.
	 */
	public String getAssociatedEventId() {
		return associatedEventId;
	}
	
	/**
	 * Sets the ID of the event associated with this recommendation (deprecated).
	 * @param associatedEventId The new ID of the associated event.
	 */
	public void setAssociatedEventId(String associatedEventId) {
		this.associatedEventId = associatedEventId;
	}

}
