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

import com.ibm.ra.remy.common.model.RemyEventDate;
import com.ibm.ra.remy.common.model.RemyItinerary;
import com.ibm.ra.remy.common.model.RemyLocation;
import com.ibm.ra.remy.common.utils.DateUtils;

/**
 * Simple class representing the Itinerary that will be displayed on the client side.
 */
public class RemyItineraryImpl extends CloudantObject implements RemyItinerary, Serializable {

	private static final long serialVersionUID = 1L; // required by Serializable
	private String title;
	private String user;
	private int version;
	private long itineraryStartDate;
	private long itineraryEndDate;
	private CloudantLocation initialLocation;
	private List<RemyEventDate> dates;

	/**
	 * Default constructor that will set all class members to their default values.
	 */
	public RemyItineraryImpl() { super(); }
	
	/**
	 * Class that will generate a RemyEventImpl object with the given data.  To fully create the object, the Map
	 * provided should contain the following keys:
	 *     Key                 Type     Value
	 *     
	 * Values needed by the CloudantObject parent class.
	 *     
	 *     _id                 String   Sets the objects unique ID
	 *     type                String   Sets the objects type
	 *     _rev                String   Sets the revision of the object. This corresponds to the revision in Cloudant.
	 *     
	 * Keys required for this class
	 * 
	 *     title               String   The descriptive title of this itinerary. Usually this is whatever the user named it
	 *     user                String   The username of the user that owns this itinerary
	 *     version             String   The version of this particular itinerary
	 *     itineraryStartDate  Long     The start date of this itinerary.  This is an offset stored in milliseconds that represents
	 *                                  the time elapsed since 12am today.
	 *     itineraryEndDate    Long     The end date of this itinerary.  This is an offset stored in milliseconds that represents
	 *                                  the time elapsed since 12am today.
	 *     initialLocation     CloudantLocation     Map that will be fed inta {@link com.ibm.ra.remy.common.impl.CloudantLocation#CloudantLocation(Map) Cloudant(map)}
	 *                                              constructor.  See it for the details of what is needed.
	 *                   
	 * @param data The map that contains the data which will be used to seed this object.
	 */
	@SuppressWarnings("unchecked")
	public RemyItineraryImpl(HashMap<String, Object> data) {
		super(data);
		if (data != null) {
			title = (String) data.get("title");
			user = (String) data.get("user");
			version = ((Double) data.get("version")).intValue();
			Object contents = data.get("itineraryStartDate");
			if (contents != null) {
				itineraryStartDate = ((Double)contents).longValue();
			}
			
			contents = data.get("itineraryEndDate");
			if (contents != null) {
				itineraryEndDate = ((Double)contents).longValue();
			}
			initialLocation = new CloudantLocation((Map<String, Object>) data.get("initialLocation"));
			long start = DateUtils.generalizeTime(new Date(itineraryStartDate)).getTime();
			long end = DateUtils.generalizeTime(new Date(itineraryEndDate)).getTime();
			dates = new ArrayList<RemyEventDate>();
			while (start < end) {
				dates.add(new RemyEventDateImpl("","",start,""));
				start = DateUtils.addHours(new Date(start), 24).getTime();
			}
		}
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyItinerary#getTitle()
	 */
	@Override
	public String getTitle() {
		return title;
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyItinerary#getInitialLocation()
	 */
	@Override
	public RemyLocation getInitialLocation() {
		return initialLocation;
	}
	
	/**
	 * @see com.ibm.ra.remy.common.impl.CloudantObject#getId()
	 */
	@Override
	public String getId() {
		return super.getId();
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyItinerary#getUser()
	 */
	@Override
	public String getUser() {
		return this.user;
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyItinerary#getDate(long)
	 */
	@Override
	public RemyEventDate getDate(long date) {
		for (RemyEventDate eventDate : dates) {
			if (eventDate.getDate() == date) {
				return eventDate;
			}
		}
		return null;
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyItinerary#getAllDates()
	 */
	@Override
	public List<RemyEventDate> getAllDates() {
		return dates;
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyItinerary#fixTime()
	 */
	@Override
	public void fixTime() {
		Date baseline = DateUtils.generalizeTime(new Date());
		itineraryEndDate += baseline.getTime();
		itineraryStartDate += baseline.getTime();
		if (dates != null) {
			for (RemyEventDate date : dates) {
				if (date != null) {
					date.fixTime();
				}
			}
		}
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyItinerary#addDate(com.ibm.ra.remy.common.model.RemyEventDate)
	 */
	@Override
	public void addDate(RemyEventDate date) {
		dates.add(date);
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyItinerary#getStartTime()
	 */
	public long getStartTime() {
		return this.itineraryStartDate;
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyItinerary#getEndTime()
	 */
	public long getEndTime() {
		return this.itineraryEndDate;
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyItinerary#sortAllEvents()
	 */
	@Override
	public void sortAllEvents() {
		for (RemyEventDate dateItem : this.dates) {
			if (dateItem != null) {
				dateItem.sortEvents();	
			}
		}
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyItinerary#getVersion()
	 */
	@Override
	public int getVersion() {
		return this.version;
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyItinerary#setVersion(int)
	 */
	@Override
	public void setVersion(int version) {
		this.version = version;
	}
}
