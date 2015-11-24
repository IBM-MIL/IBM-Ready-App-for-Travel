/* 
 * Licensed Materials - Property of IBM © Copyright IBM Corporation 2015. All
 * Rights Reserved. This sample program is provided AS IS and may be used,
 * executed, copied and modified without royalty payment by customer (a) for its
 * own instruction and study, (b) in order to develop applications designed to
 * run with an IBM product, either for customer's own internal use or for
 * redistribution by customer, as part of such an application, in customer's own
 * products.
 */

package com.ibm.ra.remy.web.utils;

import java.util.Comparator;

import com.ibm.ra.remy.common.model.RemyItinerary;

/**
 * Custom comparator class for sorting RemyItinerary objects.
 */
public class ItineraryComparer implements Comparator<RemyItinerary> {

	/**
	 * Custom override for sorting itineraries.  First compares their start times.  If the start times are equal then
	 * the code falls back to comparing version numbers.
	 */
	@Override
	public int compare(RemyItinerary i1, RemyItinerary i2) {
		Long l1 = new Long(i1.getStartTime());
		Long l2 = new Long(i2.getStartTime());
		if (l1.equals(l2)) {
			return ((Integer)i1.getVersion()).compareTo(i2.getVersion());
		} else {
			return l1.compareTo(l2);
		}
	}

}
