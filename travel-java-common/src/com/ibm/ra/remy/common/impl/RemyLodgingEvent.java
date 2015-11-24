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
 * Simple class to contain the data for a Lodging event. Basically this contains data you would want to see
 * when your looking at details of a place where you are staying or a place that you might want to stay (in the
 * case that you are looking for a room for the night).
 */
public class RemyLodgingEvent extends RemyEventImpl implements RemyEvent, Serializable {
	
	private static final long serialVersionUID = 1L;
	
	// These items are specific to lodging events.
	// The meetingName is displayed on the itinerary page.
	private String meetingName;
	// The name is displayed on the recommendations pages.
	private String name;
	private String room;
	private GooglePlacesLocation geometry;
	private String confirmation;
	private long checkin;
	private long checkout;
	private float price;
	private float original_price;
	private boolean isPreferred;
	private boolean hasPromotionalDiscount;
	private RemyLodgingEventDiscount promotionalDiscount;
	private boolean isLoyaltyMember;
	private RemyLodgingEventDiscount loyaltyDiscount;
	private String rationale;
	private long rating;
	private String description;
	// This is the longer form of the location, for the detail view.
	private String location;
	private String reviewHighlight;
	private String reviewer;
	private String reviewTime;
	// This is the shorter form of the location, for the card.
	private String vicinity;
	// Some loyalty program information.
	private String loyaltyProgramName;
	private long loyaltyPoints;
	// This indicates what should be displayed.
	private String displayType;
	private String imageUrl;
	
	/**
	 * Default constructor.  Used to instantiate all objects to their default values.
	 */
	public RemyLodgingEvent() {
		super();
		// constructor required for Business Rules
		this.promotionalDiscount = new RemyLodgingEventDiscount();
		this.loyaltyDiscount = new RemyLodgingEventDiscount();
	}
	
	/**
	 * Constructor that only sets the itineraryId and leaves everything else with its default value.
	 * @param itineraryId The itinerary that owns this lodging event object.
	 */
	public RemyLodgingEvent(String itineraryId) {
		super(null, itineraryId);
	}
	
	/**
	 * Constructor that will generate a RemyLodgingEvent object with the given data.  To fully create the object, the Map
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
	 * 	   meetingName			String	 The name of this hotel to be displayed on the itinerary.
	 *     name                 String   The name of this hotel to be displayed in other parts of the app.
	 *     room                 String   The room number that has been reserved.
	 *     confirmation         String   The confirmation number for this room.
	 *     checkin              Long     The checkin time and date, stored in milliseconds. This is actually a time in the future and
	 *                                   is stored as an offset from today at midnight so that the checkin time always shows up as
	 *                                   tomorrow at noon. In the end when this value makes it to the client, it will be in milliseconds
	 *                                   from the Epoch.
	 *     checkout             Long     The checkout date stored in milliseconds. See the checkin for a lengthy explanation of how
	 *                                   this time should be stored.
	 *     price                Double   Regular price for a room at this hotel (to be discounted by Business Rules).
	 *     originalPrice		Double	 Original price for a room at this hotel (will not be discounted).
	 *     hasPromotionalDiscount Boolean  If the hotel is currently offering discounts
	 *     isLoyaltyMember      Boolean  True if this hotel is a loyalty member hotel, false otherwise.
	 *     isPreferred          Boolean  True if this hotel is a trusted partner hotel, false otherwise.
	 *     rationale            String   String describing rationale to use for describing why this hotel is better.
	 *     rating               Double   Google Places API rating for this hotel.
	 *     description          String   The description of this hotel
	 *     location             String   The street address of this lodging event.
	 *     reviewHighlight      String   The descriptive text of the review.
	 *     reviewer             String   The name of the reviewer to generated this review.
	 *     reviewTime           String   The relative time (stored as a string description) of when this review was done.
	 *     vicinity             String   Not currently used for anything
	 *     loyaltyProgramName	String	 The name of the loyalty program that this hotel has.
	 *     loyaltyPoints		long	 The number of reward points to be gained from staying at this hotel
	 *     geometry             GooglePlacesLocation   This is a Map that should be used to create a {@link com.ibm.ra.remy.common.impl.GooglePlacesLocation GooglePlacesLocation}
	 *                                                 object.  See it for more information about what's needed.
	 *     displayType          String   A string value, always one of the following: checkin, stay, or checkout. The client uses
	 *                                   this to determine how it should display the lodging event based on this type.
	 *     imageUrl             String   A string pointing to a url that depicts an image of the lodging event location.
	 * 
	 * @param data The Map that should contain the keys described above to properly construct this object.
	 * @param itineraryId The id of the itinerary that owns this lodging event.
	 */
	@SuppressWarnings("unchecked")
	public RemyLodgingEvent(Map<String, Object> data, String itineraryId) {
		super(data, itineraryId);
		this.meetingName = (String) data.get("meetingName");
		this.name = (String) data.get("name");
		this.room = (String) data.get("room");
		this.confirmation = (String) data.get("confirmation");
		this.checkin = ((Double)data.get("checkin")).longValue();
		this.checkout = ((Double)data.get("checkout")).longValue();
		this.price = ((Double)data.get("price")).floatValue();
		this.original_price = this.price;
		this.hasPromotionalDiscount = (boolean) data.get("hasPromotionalDiscount");
		this.isLoyaltyMember = (boolean) data.get("isLoyaltyMember");
		this.isPreferred = (boolean) data.get("isPreferred");
		this.rationale = (String) data.get("rationale");
		this.rating = ((Double)data.get("rating")).longValue();
		this.description = (String) data.get("description");
		this.location = (String) data.get("location");
		this.reviewHighlight = (String) data.get("reviewHighlight");
		this.reviewer = (String) data.get("reviewer");
		this.reviewTime = (String) data.get("reviewTime");
		this.vicinity = (String) data.get("vicinity");
		this.loyaltyProgramName = (String) data.get("loyaltyProgramName");
		this.loyaltyPoints = ((Double)data.get("loyaltyPoints")).longValue();
		this.geometry = new GooglePlacesLocation((LinkedTreeMap<String, Object>) data.get("geometry"));
		this.displayType = (String) data.get("displayType");
		this.imageUrl = (String) data.get("imageUrl");
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyEvent#fixTime()
	 */
	@Override
	public void fixTime() {
		super.fixTime();
		Date baseline = DateUtils.generalizeTime(new Date());
		checkin += baseline.getTime();
		checkout += baseline.getTime();
	}
	
	/**
	 * @see com.ibm.ra.remy.common.impl.CloudantObject#toString()
	 */
	@Override
	public String toString() {
		return new Gson().toJson(this);
	}

	/**
	 * gets the _id field. Required by the Bluemix Business Rules service.
	 * @param _id The ID to set for this lodging event.
	 */
	public String get_id() {
		return getId();
	}
	
	/**
	 * sets the _id field. Required by the Bluemix Business Rules service.
	 * @param _id The id for the lodging event.
	 */
	public void set_id(String _id) {
		setId(_id);
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyEvent#getItineraryId()
	 */
	@Override
	public String getItineraryId() {
		return super.getItineraryId();
	}
	
	/**
	 * @see com.ibm.ra.remy.common.impl.RemyEventImpl#setItineraryId(java.lang.String)
	 */
	@Override
	public void setItineraryId(String itineraryId) {
		super.setItineraryId(itineraryId);
	}
	
	/**
	 * Getter.  Required by Business rules.  Gets the subtype for this object.
	 * @return The lodging events subtype.
	 */
	public String getSubType() {
		return super.getSubtype();
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyEvent#getSubtype()
	 */
	@Override
	public String getSubtype() {
		return super.getSubtype();
	}
	
	/**
	 * @see com.ibm.ra.remy.common.impl.RemyEventImpl#setSubType(java.lang.String)
	 */
	@Override
	public void setSubType(String subType) {
		super.setSubType(subType);
	}
	
	/**
	 * Getter. Gets the lodging event start time. Required by the Bluemix Business Rules service.
	 * @return The lodging event start time.
	 */
	public long getStart_time() {
		return super.getTime();
	}

	/**
	 * @see com.ibm.ra.remy.common.impl.RemyEventImpl#setStart_time(long)
	 */
	@Override
	public void setStart_time(long start_time) {
		super.setStart_time(start_time);
	}

	/**
	 * @see com.ibm.ra.remy.common.impl.RemyEventImpl#getEnd_time()
	 */
	@Override
	public long getEnd_time() {
		return super.getEnd_time();
	}

	/**
	 * @see com.ibm.ra.remy.common.impl.RemyEventImpl#setEnd_time(long)
	 */
	@Override
	public void setEnd_time(long end_time) {
		super.setEnd_time(end_time);
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyEvent#getTime()
	 */
	@Override
	public long getTime() {
		return super.getTime();
	}
	
	/**
	 * Getter. Gets the lodging events meetingName. Required by the Bluemix Business Rules service.
	 * @return The meetingName for this lodging event.
	 */
	public String getMeetingName() {
		return this.meetingName;
	}
	
	/**
	 * Setter. Sets the meetingName for this lodging event. Required by the Bluemix Business Rules service.
	 * @param meetingName The new meetingName for this lodging event.
	 */
	public void setMeetingName(String meetingName) {
		this.meetingName = meetingName;
	}
	
	/**
	 * Getter. Gets the lodging events name. Required by the Bluemix Business Rules service.
	 * @return The name of this lodging event.
	 */
	public String getName() {
		return this.name;
	}
	
	/**
	 * Setter. Sets the name for this lodging event. Required by the Bluemix Business Rules service.
	 * @param name The new name for this lodging event.
	 */
	public void setName(String name) {
		this.name = name;
	}
	
	/**
	 * Getter. Gets the lodging events room. Required by the Bluemix Business Rules service.
	 * @return The room for this lodging event.
	 */
	public String getRoom() {
		return this.room;
	}

	/**
	 * Setter. Sets the room for this lodging event. Required by the Bluemix Business Rules service.
	 * @param room The new room for this lodging event.
	 */
	public void setRoom(String room) {
		this.room = room;
	}

	/**
	 * Getter. Gets the lodging events location. Required by the Bluemix Business Rules service.
	 * @return The location for this lodging event.
	 */
	public GooglePlacesLocation getGeometry() {
		return this.geometry;
	}

	/**
	 * Setter. Sets the location for this lodging event. Required by the Bluemix Business Rules service.
	 * @param geometry The new location for this lodging event.
	 */
	public void setGeometry(GooglePlacesLocation geometry) {
		this.geometry = geometry;
	}

	/**
	 * Getter. Gets the lodging events confirmation number. Required by the Bluemix Business Rules service.
	 * @return The confirmation number for this lodging event.
	 */
	public String getConfirmation() {
		return this.confirmation;
	}

	/**
	 * Setter. Sets the confirmation number for this lodging event. Required by the Bluemix Business Rules service.
	 * @param confirmation The new confirmation number for this lodging event.
	 */
	public void setConfirmation(String confirmation) {
		this.confirmation = confirmation;
	}

	/**
	 * Getter. Gets the lodging events check in time. Required by the Bluemix Business Rules service.
	 * @return The check in time for this lodging event.
	 */
	public long getCheckin() {
		return this.checkin;
	}

	/**
	 * Setter. Sets the check in  for this lodging event. Required by the Bluemix Business Rules service.
	 * @param checkin The new check in time for this lodging event.
	 */
	public void setCheckin(long checkin) {
		this.checkin = checkin;
	}

	/**
	 * Getter. Gets the lodging events check out time. Required by the Bluemix Business Rules service.
	 * @return The checkout time for this lodging event.
	 */
	public long getCheckout() {
		return this.checkout;
	}

	/**
	 * Setter. Sets the checkout time for this lodging event. Required by the Bluemix Business Rules service.
	 * @param checkout The new checkout time for this lodging event.
	 */
	public void setCheckout(long checkout) {
		this.checkout = checkout;
	}

	/**
	 * Getter. Gets the lodging events price. Required by the Bluemix Business Rules service.
	 * @return The price for this lodging event.
	 */
	public float getPrice() {
		return this.price;
	}

	/**
	 * Setter. Sets the price for this lodging event. Required by the Bluemix Business Rules service.
	 * @param price The new price for this lodging event.
	 */
	public void setPrice(float price) {
		this.price = price;
	}

	/**
	 * Getter. Gets the lodging events original price. Required by the Bluemix Business Rules service.
	 * @return The original price for this lodging event.
	 */
	public float getOriginal_price() {
		return this.original_price;
	}

	/**
	 * Setter. Sets the original price for this lodging event. Required by the Bluemix Business Rules service.
	 * @param original_price The new original price for this lodging event.
	 */
	public void setOriginal_price(float original_price) {
		this.original_price = original_price;
	}

	/**
	 * Getter. Gets the lodging events trusted flag. Required by the Bluemix Business Rules service.
	 * @return The trusted flag for this lodging event.
	 */
	public boolean getIsPreferred() {
		return this.isPreferred;
	}

	/**
	 * Setter. Sets the trusted flag for this lodging event. Required by the Bluemix Business Rules service.
	 * @param isTrustedPartner The new trusted flag for this lodging event.
	 */
	public void setIsPreferred(boolean isPreferred) {
		this.isPreferred = isPreferred;
	}

	/**
	 * Getter. Gets the lodging events promotional discount flag. Required by the Bluemix Business Rules service.
	 * @return The promotional discount flag for this lodging event.
	 */
	public boolean getHasPromotionalDiscount() {
		return this.hasPromotionalDiscount;
	}

	/**
	 * Setter. Sets the promotional discount flag for this lodging event. Required by the Bluemix Business Rules service.
	 * @param hasPromotionalDiscount The new promotional discount flag for this lodging event.
	 */
	public void setHasPromotionalDiscount(boolean hasPromotionalDiscount) {
		this.hasPromotionalDiscount = hasPromotionalDiscount;
	}

	/**
	 * Getter. Gets the lodging events promotional discount. Required by the Bluemix Business Rules service.
	 * @return The promotional discount for this lodging event.
	 */
	public RemyLodgingEventDiscount getPromotionalDiscount() {
		return this.promotionalDiscount;
	}

	/**
	 * Setter. Sets the promotional discount for this lodging event. Required by the Bluemix Business Rules service.
	 * @param promotionalDiscount The new promotional discount for this lodging event.
	 */
	public void setPromotionalDiscount(RemyLodgingEventDiscount promotionalDiscount) {
		this.promotionalDiscount = promotionalDiscount;
	}

	/**
	 * Getter. Gets the lodging events loyalty member flag. Required by the Bluemix Business Rules service.
	 * @return The loyalty member flag for this lodging event.
	 */
	public boolean getIsLoyaltyMember() {
		return this.isLoyaltyMember;
	}

	/**
	 * Setter. Sets the loyalty member flag for this lodging event. Required by the Bluemix Business Rules service.
	 * @param isLoyaltyMember The new loyalty member flag for this lodging event.
	 */
	public void setIsLoyaltyMember(boolean isLoyaltyMember) {
		this.isLoyaltyMember = isLoyaltyMember;
	}

	/**
	 * Getter. Gets the lodging events loyalty member discount. Required by the Bluemix Business Rules service.
	 * @return The loyalty member discount for this lodging event.
	 */
	public RemyLodgingEventDiscount getLoyaltyDiscount() {
		return this.loyaltyDiscount;
	}

	/**
	 * Setter. Sets the loyalty member discount for this lodging event. Required by the Bluemix Business Rules service.
	 * @param loyaltyDiscount The new loyalty member discount for this lodging event.
	 */
	public void setLoyaltyDiscount(RemyLodgingEventDiscount loyaltyDiscount) {
		this.loyaltyDiscount = loyaltyDiscount;
	}

	/**
	 * Getter. Gets the lodging events rationale. Required by the Bluemix Business Rules service.
	 * @return The rationale for this lodging event.
	 */
	public String getRationale() {
		return this.rationale;
	}

	/**
	 * Setter. Sets the rationale for this lodging event. Required by the Bluemix Business Rules service.
	 * @param rationale The new rationale for this lodging event.
	 */
	public void setRationale(String rationale) {
		this.rationale = rationale;
	}

	/**
	 * Getter. Gets the lodging events rating. Required by the Bluemix Business Rules service.
	 * @return The rating for this lodging event.
	 */
	public long getRating() {
		return this.rating;
	}

	/**
	 * Setter. Sets the rating for this lodging event. Required by the Bluemix Business Rules service.
	 * @param rating The new rating for this lodging event.
	 */
	public void setRating(long rating) {
		this.rating = rating;
	}

	/**
	 * Getter. Gets the lodging events description. Required by the Bluemix Business Rules service.
	 * @return The description for this lodging event.
	 */
	public String getDescription() {
		return this.description;
	}

	/**
	 * Setter. Sets the description for this lodging event. Required by the Bluemix Business Rules service.
	 * @param description The new description for this lodging event.
	 */
	public void setDescription(String description) {
		this.description = description;
	}

	/**
	 * Getter. Gets the lodging events location. Required by the Bluemix Business Rules service.
	 * @return The location for this lodging event.
	 */
	public String getLocation() {
		return this.location;
	}

	/**
	 * Setter. Sets the location for this lodging event. Required by the Bluemix Business Rules service.
	 * @param description The new location for this lodging event.
	 */
	public void setLocation(String location) {
		this.location = location;
	}

	/**
	 * Getter. Gets the lodging events review text. Required by the Bluemix Business Rules service.
	 * @return The review text for this lodging event.
	 */
	public String getReviewHighlight() {
		return this.reviewHighlight;
	}

	/**
	 * Setter. Sets the review text for this lodging event. Required by the Bluemix Business Rules service.
	 * @param reviewHighlight The new review text for this lodging event.
	 */
	public void setReviewHighlight(String reviewHighlight) {
		this.reviewHighlight = reviewHighlight;
	}

	/**
	 * Getter. Gets the lodging events reviewer. Required by the Bluemix Business Rules service.
	 * @return The reviewer for this lodging event.
	 */
	public String getReviewer() {
		return this.reviewer;
	}

	/**
	 * Setter. Sets the reviewer for this lodging event. Required by the Bluemix Business Rules service.
	 * @param reviewer The new reviewer for this lodging event.
	 */
	public void setReviewer(String reviewer) {
		this.reviewer = reviewer;
	}

	/**
	 * Getter. Gets the lodging events review creation time. Required by the Bluemix Business Rules service.
	 * @return The review creation time for this lodging event.
	 */
	public String getReviewTime() {
		return this.reviewTime;
	}

	/**
	 * Setter. Sets the review creation time for this lodging event. Required by the Bluemix Business Rules service.
	 * @param reviewTime The new review creation time for this lodging event.
	 */
	public void setReviewTime(String reviewTime) {
		this.reviewTime = reviewTime;
	}

	/**
	 * Getter. Gets the lodging events vicinity. Required by the Bluemix Business Rules service.
	 * @return The vicinity for this lodging event.
	 */
	public String getVicinity() {
		return this.vicinity;
	}

	/**
	 * Setter. Sets the vicinity for this lodging event. Required by the Bluemix Business Rules service.
	 * @param vicinity The new vicinity for this lodging event.
	 */
	public void setVicinity(String vicinity) {
		this.vicinity = vicinity;
	}
	
	/**
	 * Getter. Gets the name of the loyalty program. Required by the Bluemix Business Rules service.
	 * @return The name of the loyalty program.
	 */
	public String getLoyaltyProgramName() {
		return this.loyaltyProgramName;
	}
	
	/**
	 * Setter. Sets the name of the loyalty program. Required by the Bluemix Business Rules service.
	 * @param loyaltyProgramName The new name of the loyalty program.
	 */
	public void setLoyaltyProgramName(String loyaltyProgramName) {
		this.loyaltyProgramName = loyaltyProgramName;
	}
	
	/**
	 * Getter. Gets the number of reward points. Required by the Bluemix Business Rules service.
	 * @return The number of reward points.
	 */
	public long getLoyaltyPoints() {
		return this.loyaltyPoints;
	}
	
	/**
	 * Setter. Sets the number of reward points. Required by the Bluemix Business Rules service.
	 * @param loyaltyPoints The new number of loyalty points.
	 */
	public void setLoyaltyPoints(long loyaltyPoints) {
		this.loyaltyPoints = loyaltyPoints;
	}

	/**
	 * Getter. Gets the lodging events display type. Required by the Bluemix Business Rules service.
	 * @return The display type for this lodging event.
	 */
	public String getDisplayType() {
		return this.displayType;
	}

	/**
	 * Setter. Sets the display type for this lodging event. Required by the Bluemix Business Rules service.
	 * @param displayType The new display type for this lodging event.
	 */
	public void setDisplayType(String displayType) {
		this.displayType = displayType;
	}

	/**
	 * Getter. Gets the lodging events image URL string. Required by the Bluemix Business Rules service.
	 * @return The  image URL string for this lodging event.
	 */
	public String getImageUrl() {
		return this.imageUrl;
	}

	/**
	 * Setter. Sets the  image URL string for this lodging event. Required by the Bluemix Business Rules service.
	 * @param imageUrl The new  image URL string for this lodging event.
	 */
	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyEvent#isOutdoor()
	 */
	@Override
	public boolean isOutdoor() {
		return false;
	}

}
