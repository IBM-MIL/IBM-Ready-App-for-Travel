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
import java.util.HashMap;
import java.util.Map;

import com.ibm.ra.remy.common.model.RemyLocation;
import com.ibm.ra.remy.common.model.RemyWeather;
import com.ibm.ra.remy.common.utils.DateUtils;

/**
 * Simple class that 
 */
public class RemyWeatherImpl extends CloudantObject implements RemyWeather, Serializable {

	private static final long serialVersionUID = 1L;

	/**
	 * Private class used to store the temperature from the Weather Underground json dump.
	 */
	private class EnglishMetricObject {
		private String english;
		private String metric;
		
		/**
		 * Default constructor that sets the members to their default values.
		 */
		@SuppressWarnings("unused")
		public EnglishMetricObject() {
			super();
		}
		
		/**
		 * Constructor that sets the metric object with both the English and Metric values of the temperature.
		 * @param english The Engligh value (Fahrenheit) of the temperature.
		 * @param metric The metric value (Celcius) of the temperature.
		 */
		@SuppressWarnings("unused")
		public EnglishMetricObject(String english, String metric) {
			super();
			this.english = english;
			this.metric = metric;
		}
		
		/**
		 * Constructor that seeds the member values from its key/value pairs. The Map must include the following keys
		 * 
		 * Key        Type       Description
		 * 
		 * english    String     The Fahrenheit temperature for this day
		 * metric     String     The Celcius temperature for this day.
		 * 
		 * @param data The map that will seed the object.
		 */
		public EnglishMetricObject(Map<String, String> data) {
			if (data != null) {
				english = data.get("english");
				metric = data.get("metric");
			}
		}
		
		/**
		 * Gets the Fahrenheit temperature for this day.
		 * @return The temperature in Fahrenheit.
		 */
		public String getEnglish() {
			return english;
		}
		
		/**
		 * Gets the Celcius temperature for this day.
		 * @return The temperature in Celcius.
		 */
		public String getMetric() {
			return metric;
		}
	}
	
	private long date;
	private EnglishMetricObject temp;
	private String condition;
	private RemyLocation location;
	
	/**
	 * Default constructor. Sets all members to their default values.
	 */
	public RemyWeatherImpl() {
		super();
	}
	
	/**
	 * Constructor that seeds this objects members from a Map.  The Map must contain the the following keys in order to
	 * seed the object correctly.
	 * 
	 * Key           Type                   Description
	 * 
	 * date          Long                   The date this weather is for, in milliseconds.
	 * condition     String                 The dates weather conditions, a string like "cloudy", "rainy", etc
	 * temp          EnglighMetricObject    The temperature for the day, both Celcius and Fahrenheit. See {@link com.ibm.ra.remy.common.impl.RemyWeatherImpl.EnglishMetricObject EnglishMetricObject}
	 * 
	 * @param data The Map that should contain the keys described above to properly construct this object.
	 */
	@SuppressWarnings("unchecked")
	public RemyWeatherImpl(HashMap<String, Object> data) {
		super(data);
		if (data != null) {
			date = Long.parseLong((String) data.get("date"));
			condition = (String) data.get("condition");
			temp = new EnglishMetricObject((Map<String, String>) data.get("temp"));
		}
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyWeather#getDate()
	 */
	@Override
	public long getDate() {
		return date;
	}
	
	/**
	 * Sets the date associated with this weather object.
	 * @param date The date for this weather object, in milliseconds
	 */
	public void setDate(long date) { 
		this.date = date;
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyWeather#getTemperature(boolean)
	 */
	@Override
	public String getTemperature(boolean metric) {
		if (metric) {
			return temp.getMetric();
		} else {
			return temp.getEnglish();
		}
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyWeather#getCondition()
	 */
	@Override
	public String getCondition() {
		return condition;
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyWeather#fixTime()
	 */
	@Override
	public void fixTime() {
		Date baseline = DateUtils.generalizeTime(new Date());
		date += baseline.getTime();
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyWeather#getLocation()
	 */
	@Override
	public RemyLocation getLocation() {
		return location;
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyWeather#setLocation(com.ibm.ra.remy.common.model.RemyLocation)
	 */
	@Override
	public void setLocation(RemyLocation location) {
		this.location = location;
	}

}
