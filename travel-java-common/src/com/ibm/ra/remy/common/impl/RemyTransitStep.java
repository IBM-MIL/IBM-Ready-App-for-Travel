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
import com.ibm.ra.remy.common.utils.DateUtils;

/**
 * Simple class that represents the "steps" that get you from one location to another and what changes you have to make
 * like going from a bus to a train, etc.
 */
@SuppressWarnings("unused")
public class RemyTransitStep implements Serializable {

	private static final long serialVersionUID = 1L;
	private static final String RAIL = "rail";
	private static final String BUS = "bus";
	private static final String WALK = "walk";
	private static final String CAR = "car";
	private static final String PARTNER = "partner";

	// Basic data (non-detail screen)
	private String type;
	private Long start_time;
	private Long end_time;
	private String walkTime;
	private String transitLine;
	private String title;
	
	// Detail screen data
	private String departureArea;
	private String arrivalArea;
	private String details;
	private Long stops;
	private String partnerName;
	private String partnerPickupTime;
	private String fareNotice;
	private Long seatsRemaining;
	
	/**
	 * Default constructor. Sets all members to their default values.
	 */
	public RemyTransitStep() {
		super();
	}
	
	/**
	 * Default constructor which creates a Flight object from a map of data. The Map needs to contain the following
	 * keys in order to fully create the object.
	 * 
	 *     Key                  Type     Value
	 *     
	 *     type                 String   Sets the object's type.
	 *     start_time           Long     The start time for this event. Before being returned to the client this will represent the 
	 *                                   number of milliseconds from the Epoch.  At class creation time will actually be an offset
	 *                                   representing some time in the future.  This value will be added to midnight of todays date
	 *                                   to represent the full time from the Epoch. So setting this value to 86400000l (24 hours in
	 *                                   milliseconds) will end up showing up as midnight tomorrow on the client that gets this event.
	 *     end_time             Long     The end time for this event.  Like the start_time described above this is actually an offset
	 *                                   representing a time in the future.
	 *     details              String   Some detailed information about this step.
	 *     departureArea        String   The location from which this step starts.
	 *     arrivalArea          String   The location where this step ends.
	 *     transitLine          String   For Rail and Bus type steps only, the line which you need to catch.
	 *     stops                Double   For Rail and Bus type steps only,  the number of stops on this step.
	 *     walkTime             String   The amount of time it takes to walk to the arrivalArea.
	 *     title                String   For Car type steps only, the name of the car service to use.
	 *     partnerName			String	 For Partner type steps only, the name of the partner service.
	 *     partnerPickupTime	String	 For Partner type steps only, the time until the user can be picked up.
	 *     fareNotice			String	 For Partner type steps only, an info string about how fares may vary.
	 *     seatsRemaining		String	 For Partner type steps only, the number of seats that are still available.
	 *     
	 * @param data The Map that should contain the keys described above to properly construct this object.
	 */
	public RemyTransitStep(Map<String, Object> data) {
		this.type = (String) data.get("type");
		this.start_time = ((Double)data.get("start_time")).longValue();
		this.end_time = ((Double)data.get("end_time")).longValue();
		this.details = (String) data.get("details");
		this.departureArea = (String) data.get("departureArea");
		this.arrivalArea = (String) data.get("arrivalArea");
		if (RAIL.equals(type) || BUS.equals(type)) {
			this.transitLine = (String) data.get("transit_line");
			this.stops = ((Double)data.get("stops")).longValue();
		} else if (WALK.equals(type)) {
			this.walkTime = (String) data.get("walk_time");
		} else if (CAR.equals(type)) {
			this.title = (String) data.get("title");
		} else if (PARTNER.equals(type)) {
			this.partnerName = (String) data.get("partnerName");
			this.partnerPickupTime = (String) data.get("partnerPickupTime");
			this.fareNotice = (String) data.get("fareNotice");
			this.seatsRemaining = ((Double)data.get("seatsRemaining")).longValue();
		}
	}
	
	/**
	 * Setter, the new start time of this step
	 * @param newTime The start time in milliseconds
	 */
	public void setStartTime(Long newTime) {
		this.start_time = newTime;
	}
	
	/**
	 * Getter. The start time of the step
	 * @return The start time in milliseconds
	 */
	public Long getStartTime() {
		return this.start_time;
	}
	
	/**
	 * Setter.  The new end time of this step.
	 * @param newTime The new end time in milliseconds.
	 */
	public void setEndTime(Long newTime) {
		this.end_time = newTime;
	}
	
	/**
	 * Getter. The end time of this step.
	 * @return The end time of this step in milliseconds.
	 */
	public Long getEndTime() {
		return this.end_time;
	}
	
	/**
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return new Gson().toJson(this);
	}
	
	/**
	 * Converts the stored offset time to a real point in time.
	 */
	public void fixTime() {
		Date baseline = DateUtils.generalizeTime(new Date());
		this.start_time += baseline.getTime();
		this.end_time += baseline.getTime();
	}
}
