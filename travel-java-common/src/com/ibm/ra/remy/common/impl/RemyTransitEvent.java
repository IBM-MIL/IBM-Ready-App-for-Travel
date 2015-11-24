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
 * Simple class that represents a transit event, which is either a rail, walk, tram commute.  
 */
@SuppressWarnings("unused")
public class RemyTransitEvent extends RemyEventImpl implements RemyEvent, Serializable {
	
	private static final long serialVersionUID = 1L;

	// These items are specific to transit events.
	private String ios_transit_name;
	private String cost;
	private Double costDouble;
	private String departureStreet;
	private Double walkingDistance;
	private boolean isPreferred;
	private List<RemyTransitStep> transit_steps;
	
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
	 *     cost                 String   The cost of this transit option.
	 *     costDouble			Double	 The same cost, in a double format for use by Business Rules.
	 *     ios_transit_name     String   Name used only on the client side so that they can associate the correct image
	 *                                   to this transit step.
	 *     departureStreet		String	 The street from which this transit option departs.
	 *     walkingDistance		Double	 The distance the user needs to walk to get to this transit option.
	 *     isPreferred			boolean	 Whether or not this is a preferred option (for iOS display).
	 *     transit_steps        RemyTransitStep Details on how to get from one location to another.
	 *     
	 * @param data The Map that should contain the keys described above to properly construct this object.
	 * @param itineraryId The id of the itinerary that owns this lodging event.
	 */
	public RemyTransitEvent(Map<String, Object> data, String itineraryId) {
		super(data, itineraryId);
		this.cost = (String) data.get("cost");
		this.costDouble = (Double) data.get("costDouble");
		this.departureStreet = (String) data.get("departureStreet");
		this.ios_transit_name = (String) data.get("ios_transit_name");
		this.isPreferred = (boolean) data.get("isPreferred");
		this.walkingDistance = (Double) data.get("walkingDistance");
		// Process the transit events.
		this.transit_steps = new ArrayList<RemyTransitStep>();
		@SuppressWarnings("unchecked")
		List<LinkedTreeMap<String, Object>> transitEvents = (List<LinkedTreeMap<String, Object>>) data.get("transit_steps");
		for (LinkedTreeMap<String, Object> e : transitEvents) {
			transit_steps.add(new RemyTransitStep(e));
		}
	}

	/**
	 * @see com.ibm.ra.remy.common.impl.RemyEventImpl#fixTime()
	 */
	@Override
	public void fixTime() {
		super.fixTime();
		Date baseline = DateUtils.generalizeTime(new Date());
		if (transit_steps != null) {
			for (RemyTransitStep t : transit_steps) {
				if (t != null) {
					t.fixTime();
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
	 * @see com.ibm.ra.remy.common.impl.RemyEventImpl#getSubtype()
	 */
	@Override
	public String getSubtype() {
		return TRANSIT;
	}

	/**
	 * @see com.ibm.ra.remy.common.impl.RemyEventImpl#isOutdoor()
	 */
	@Override
	public boolean isOutdoor() {
		// TODO Auto-generated method stub
		return false;
	}
	
	/**
	 * Returns the name assigned to this transit event that links it to an iOS image,
	 * for display.
	 * @return ios_transit_name The name assigned to this transit event.
	 */
	public String getIos_transit_name() {
		return this.ios_transit_name;
	}
	
	/**
	 * Returns the RemyTransitStep details on how to get from one location to another.
	 * @return A list of RemyTransitSteps.
	 */
	public List<RemyTransitStep> getTransitSteps() {
		return this.transit_steps;
	}

	/**
	 * Returns the total price of this transit event
	 * @return The total price of this transit event.
	 */
	public double getCostDouble() {
		return this.costDouble;
	}

	/**
	 * Returns the total waiting time between transit steps.
	 * @return The total waiting time between transit steps.
	 */
	public long getWaitingTime() {
		long totalWaitingTime = 0;
		for (int i = 0; i < transit_steps.size()-1; i++) {
			RemyTransitStep transitStep1 = transit_steps.get(i);
			RemyTransitStep transitStep2 = transit_steps.get(i+1);
			long waitingTimeStart = transitStep1.getEndTime();
			long waitingTimeEnd = transitStep2.getStartTime();
			long waitingTime = waitingTimeEnd - waitingTimeStart;
			totalWaitingTime += waitingTime;
		}
		return totalWaitingTime;
	}

	/**
	 * Returns the number of transfers.
	 * @return The number of transfers.
	 */
	public int getNumTransfers() {
		int numTransfers = 0;
		if (transit_steps.size() > 0) {
			numTransfers = transit_steps.size() - 1;
		}
		return numTransfers;
	}

	/**
	 * Returns the total duration of this transit event.
	 * @return The total duration of this transit event.
	 */
	public long getTotalDuration() {
		int numSteps = transit_steps.size();
		if (numSteps > 0) {
			long startTime = transit_steps.get(0).getStartTime();
			long endTime = transit_steps.get(numSteps-1).getEndTime();
			return endTime - startTime;
		}
		return 0;
	}

	/**
	 * Returns the total walking distance of this transit event.
	 * @return The total walking distance of this transit event.
	 */
	public double getWalkingDistance() {
		return this.walkingDistance;
	}
}
