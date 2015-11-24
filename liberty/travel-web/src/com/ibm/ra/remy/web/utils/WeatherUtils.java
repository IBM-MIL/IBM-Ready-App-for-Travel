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

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

import com.ibm.ra.remy.common.impl.RemyWeatherImpl;
import com.ibm.ra.remy.common.model.RemyWeather;

/**
 * Contains a function for formatting weather items after they arrive from Cloudant.
 *
 */
public class WeatherUtils {
	/**
	 * This function takes in raw weather data from Cloudant and formats it into a sorted list
	 * of RemyWeather objects.
	 * @param weatherData The unformatted Cloudant data.
	 * @return A formatted, sorted list of RemyWeather objects.
	 */
	@SuppressWarnings("unchecked")
	public List<RemyWeather> formatWeatherForItinerary(@SuppressWarnings("rawtypes") List<HashMap> weatherData) {
		List<RemyWeather> weatherList = new ArrayList<RemyWeather>();
		for (HashMap<String, Object> weatherItem : weatherData) {
			RemyWeather newWeather = new RemyWeatherImpl(weatherItem);
			weatherList.add(newWeather);
		}
		Collections.sort(weatherList, new WeatherComparator());
		return weatherList;
	}
}
