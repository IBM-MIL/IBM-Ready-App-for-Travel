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
import java.util.List;

import com.ibm.ra.remy.common.model.RemyItinerary;
import com.ibm.ra.remy.common.model.RemyTravelData;

/**
 * Simple object that represents the data structure we will be returning to the client.
 */
public class RemyTravelDataImpl extends CloudantObject implements RemyTravelData, Serializable {

	private static final long serialVersionUID = 1L;
	private List<RemyItinerary> itineraries;
	
	/**
	 * Default constructor.
	 */
	public RemyTravelDataImpl() {
		super();
		this.itineraries = new ArrayList<RemyItinerary>();
	}
	
	/**
	 * Constructor that sets the itineraries for our user.
	 * @param itineraries The itineraries to set for this user.
	 */
	public RemyTravelDataImpl(List<RemyItinerary> itineraries) {
		this.itineraries = itineraries;
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyTravelData#getItineraries()
	 */
	@Override
	public List<RemyItinerary> getItineraries() {
		return itineraries;
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyTravelData#addItinerary(com.ibm.ra.remy.common.model.RemyItinerary)
	 */
	@Override
	public void addItinerary(RemyItinerary newItin) {
		itineraries.add(newItin);
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyTravelData#fixTime()
	 */
	@Override
	public void fixTime() {
		if (itineraries != null) {
			for (RemyItinerary itin : itineraries) {
				if (itin != null) {
					itin.fixTime();
				}
			}
		}
	}
}
