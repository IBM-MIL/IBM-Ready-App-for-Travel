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

import com.ibm.ra.remy.common.model.RemyWeather;

/**
 * A quick comparator class to sort RemyWeather objects by date.
 *
 */
public class WeatherComparator implements Comparator<RemyWeather>{

	/**
	 * This compare function sorts RemyWeather objects by date, ascending.
	 */
	@Override
	public int compare(RemyWeather o1, RemyWeather o2) {
		return (int) (o1.getDate() - o2.getDate());
	}
	
}
