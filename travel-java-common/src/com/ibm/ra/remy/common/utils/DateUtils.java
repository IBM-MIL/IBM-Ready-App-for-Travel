/* 
 * Licensed Materials - Property of IBM © Copyright IBM Corporation 2015. All
 * Rights Reserved. This sample program is provided AS IS and may be used,
 * executed, copied and modified without royalty payment by customer (a) for its
 * own instruction and study, (b) in order to develop applications designed to
 * run with an IBM product, either for customer's own internal use or for
 * redistribution by customer, as part of such an application, in customer's own
 * products.
 */

package com.ibm.ra.remy.common.utils;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

/**
 * Class that implements some date math in order to make using date calculations easier
 */
public class DateUtils {

	/**
	 * Returns a {@link java.util.Date Date} object which has had its time component reset to 12 am midnight for that day
	 * 
	 * @param date The Date object whose time component we want to adjust.
	 * @return
	 */
	public static Date generalizeTime(Date date) {
		Calendar temp = new GregorianCalendar();
		temp.setTime(date);
		temp.set(Calendar.HOUR_OF_DAY, 0);
		temp.set(Calendar.MINUTE, 0);
		temp.set(Calendar.SECOND, 0);
		temp.set(Calendar.MILLISECOND, 0);
		return temp.getTime();
	}

	/**
	 * Adds the number of hours to the specified {@link java.util.Date Date} object.
	 * 
	 * @param date The Date object that we want to add time to
	 * @param hours The number of hours to be added to the given Date object
	 * @return The new adjusted Date object
	 */
	public static Date addHours(Date date, int hours) {
		Calendar temp = new GregorianCalendar();
		temp.setTime(date);
		temp.set(Calendar.HOUR_OF_DAY, hours);
		return temp.getTime();
	}
}
