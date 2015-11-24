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
import com.ibm.ra.remy.common.model.RemyEvent;
import com.ibm.ra.remy.common.model.RemyLocation;
import com.ibm.ra.remy.common.utils.DateUtils;

/**
 * Class representing Flight events. This is usually like a flight reservation you would see in an email notification
 * from an airlines.
 */
@SuppressWarnings("unused")
public class RemyFlightEvent extends RemyEventImpl implements RemyEvent, Serializable {
	
	private static final long serialVersionUID = 1L;
	
	// These three items are common to everything implementing RemyEvent.
	private Long boardingTime;
	private Long departureTime;
	private Long arrivalTime;
	private String departureAirportCode;
	private RemyLocation arrivalLocation;
	private RemyLocation departureLocation;
	private String arrivalAirportCode;
	private String gate;
	private String terminal;
	
	/**
	 * Default constructor which creates a Flight object from a map of data. The Map needs to contain the following
	 * keys in order to fully create the object.
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
	 *     boardingTime         Long     The boarding time for this flight.
	 *     departureTime        Long     The departure time for this flight.
	 *     arrivalTime          Long     The arrival time for this flight.
	 *     departureAirportCode String   The airport code for the departure flight.
	 *     arrivalLocation      CloudantLocation The location of where the flight is heading too.
	 *     departureLocation    CloudantLocation The location of the place the flight is leaving.
	 *     arrivalAirportCode   String   The airport code of the arrival airport.
	 *     gate                 String   The gate for the departing flight.
	 *     terminal             String   The terminal for the departing flight.
	 *     
	 * @param data The Map that should contain the keys described above to properly construct this object.
	 * @param itineraryId The id of the itinerary that owns this lodging event.
	 */
	@SuppressWarnings("unchecked")
	public RemyFlightEvent(Map<String, Object> data, String itineraryId) {
		super(data, itineraryId);
		this.boardingTime = ((Double)data.get("boardingTime")).longValue();
		this.departureTime = ((Double)data.get("departureTime")).longValue();
		this.arrivalTime = ((Double)data.get("arrivalTime")).longValue();
		this.departureAirportCode = (String)data.get("departureAirportCode");
		this.arrivalLocation = new CloudantLocation((Map<String, Object>)data.get("arrivalLocation"));
		this.departureLocation = new CloudantLocation((Map<String, Object>)data.get("departureLocation"));
		this.arrivalAirportCode = (String)data.get("arrivalAirportCode");
		this.gate = (String)data.get("gate");
		this.terminal = (String)data.get("terminal");
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyEvent#fixTime()
	 */
	@Override
	public void fixTime() {
		super.fixTime();
		Date baseline = DateUtils.generalizeTime(new Date());
		boardingTime += baseline.getTime();
		departureTime += baseline.getTime();
		arrivalTime += baseline.getTime();
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
	 * @see com.ibm.ra.remy.common.model.RemyEvent#isOutdoor()
	 */
	@Override
	public boolean isOutdoor() {
		return false;
	}

}
