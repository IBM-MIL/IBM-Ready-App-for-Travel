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
 * Simple class used to represent a Restaurant card/event in the front end application. This contains all the data
 * needed when viewing the details of a restaurant.
 */
@SuppressWarnings("unused")
public class RemyRestaurantEvent extends RemyEventImpl implements RemyEvent, Serializable {
	
	private static final long serialVersionUID = 1L;
	
	// These items are specific to restaurant events.
	private String meetingName;
	private String name;
	private GooglePlacesLocation geometry ;
	private Double price_level;
	private Double rating;
	private String cuisine;
	private String distance;
	// This is the longer form of the location, for the detail view.
	private String location;
	private String reviewHighlight;
	private String reviewer;
	private String reviewTime;
	private boolean isPreferred;
	// This is the shorter form of the location, for the card.
	private String vicinity;
	private boolean isOutdoor;
	private Long time;
	private String imageUrl;
	// This is an embedded recommendations event, for the scenario where Cafe Pfau is rained out.
	private RemyRecommendationsEvent recommendedReplacements;
	
	/**
	 * Constructor that will generate a RemyRestaurantEvent object with the given data.  To fully create the object, the Map
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
	 *     meetingName			String   The name of this restaurant to be displayed on the itinerary.
	 *     name                 String   The name of this restaurant to be displayed in other parts of the app.
	 *     price_level          Double   The price range of the food served at this restaurant.
	 *     rating               Double   The average rating for this restaurant. 
	 *     cuisine              String   The type of cuisine served at this restaurant.
	 *     distance             String   The distance to this restaurant from the previous meeting.
	 *     location             String   The street address of this restaurant.
	 *     reviewHighlight      String   The review text.
	 *     reviewer             String   The name of the reviewer.
	 *     reviewTime           String   The time the review was created.
	 *     isPreferred			boolean	 Whether or not this is a preferred option (for iOS display).
	 *     vicinity             String   The street address for this event.
	 *     isOutdoor            Boolean  States whether this event venue is outdoors or not.
	 *     time                 Long     The start time of this meeting.  Stored in milliseconds. This should be a time in the future
	 *                                   stored as an offset from midnight today.
	 *     geometry             GooglePlacesLocation This is a Map that should be used to create a {@link com.ibm.ra.remy.common.impl.GooglePlacesLocation GooglePlacesLocation}
	 *                                               object.  See it for more information about what's needed.
	 *     imageUrl             String   A URL that depicts an image of the event location.
	 * 
	 * @param data The Map that should contain the keys described above to properly construct this object.
	 * @param itineraryId The id of the itinerary that owns this event.
	 */
	@SuppressWarnings("unchecked")
	public RemyRestaurantEvent(Map<String, Object> data, String itineraryId) {
		super(data, itineraryId);
		this.meetingName = (String) data.get("meetingName");
		this.name = (String) data.get("name");
		this.price_level = (Double) data.get("price_level");
		this.rating = (Double) data.get("rating");
		this.cuisine = (String) data.get("cuisine");
		this.distance = (String) data.get("distance");
		this.location = (String) data.get("location");
		this.reviewHighlight = (String) data.get("reviewHighlight");
		this.reviewer = (String) data.get("reviewer");
		this.reviewTime = (String) data.get("reviewTime");
		this.isPreferred = (boolean) data.get("isPreferred");
		this.vicinity = (String) data.get("vicinity");
		this.isOutdoor = (boolean) data.get("isOutdoor");
		this.time = ((Double)data.get("time")).longValue();
		this.geometry = new GooglePlacesLocation((LinkedTreeMap<String, Object>) data.get("geometry"));
		this.imageUrl = (String) data.get("imageUrl");
	}

	/**
	 * @see com.ibm.ra.remy.common.impl.RemyEventImpl#fixTime()
	 */
	@Override
	public void fixTime() {
		super.fixTime();
		Date baseline = DateUtils.generalizeTime(new Date());
		time += baseline.getTime();
	}

	/**
	 * @see com.ibm.ra.remy.common.impl.RemyEventImpl#toString()
	 */
	@Override
	public String toString() {
		return new Gson().toJson(this);
	}

	/**
	 * @see com.ibm.ra.remy.common.impl.RemyEventImpl#getItineraryId()
	 */
	@Override
	public String getItineraryId() {
		return super.getItineraryId();
	}

	/**
	 * @see com.ibm.ra.remy.common.impl.RemyEventImpl#getTime()
	 */
	@Override
	public long getTime() {
		return super.getTime();
	}

	/**
	 * @see com.ibm.ra.remy.common.impl.RemyEventImpl#getSubtype()
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
	 * @see com.ibm.ra.remy.common.impl.RemyEventImpl#isOutdoor()
	 */
	@Override
	public boolean isOutdoor() {
		return isOutdoor;
	}
	
	/**
	 * Obtains a RemyRecommendationsEvent associated with this restaurant event, containing
	 * a list of other restaurant events that can act as a replacement for this one in the
	 * itinerary.
	 * @return recommendedReplacements The event containing the list of replacements.
	 */
	public RemyRecommendationsEvent getRecommendedReplacements() {
		return this.recommendedReplacements;
	}
	
	/**
	 * Returns a RemyRecommendationsEvent associated with this restaurant event, containing
	 * a list of other restaurant events that can act as a replacement for this one in the
	 * itinerary.
	 * @param recommendedReplacements The event containing the list of replacements.
	 */
	public void setRecommendedReplacements(RemyRecommendationsEvent recommendedReplacements) {
		this.recommendedReplacements = recommendedReplacements;
	}

	/**
	 * Gets the name of the restaurant where this event will take place.
	 * @return The name of the restaurant.
	 */
	public String getName() {
		return name;
	}
}
