/* 
 * Licensed Materials - Property of IBM © Copyright IBM Corporation 2015. All
 * Rights Reserved. This sample program is provided AS IS and may be used,
 * executed, copied and modified without royalty payment by customer (a) for its
 * own instruction and study, (b) in order to develop applications designed to
 * run with an IBM product, either for customer's own internal use or for
 * redistribution by customer, as part of such an application, in customer's own
 * products.
 */

package com.ibm.ra.remy.test;

import java.util.List;
import java.util.Map;

import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import com.ibm.ra.remy.common.model.RemyEventDate;
import com.ibm.ra.remy.common.model.RemyItinerary;
import com.ibm.ra.remy.common.model.RemyTravelData;
import com.ibm.ra.remy.web.utils.ItineraryUtils;

public class TestDefect9402 {
	private static RemyTravelData data;
	private static final String LARA_KEY = "user1";
	
	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
		ItineraryUtils iUtils = new ItineraryUtils();
		Map<String, RemyTravelData> all = iUtils.getItineraries("en");
		data = all.get(LARA_KEY);
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
	}
	
	/**
	 * Test to ensure that we don't get too many days in the itinerary.  This was happening when we had too
	 * much weather data and it was inserting items where they didn't need to be. Basically a regression test for
	 * defect 9402
	 */
	@Test
	public void test9402NotTooManyItineraryDays() {
		Assert.assertNotNull(data);
		
		List<RemyItinerary> itineraries = data.getItineraries();
		Assert.assertNotNull(itineraries);
		Assert.assertNotEquals(0, itineraries.size());
		/*
		 * Lara's trip is only 5 days, so we should not have any days past that.
		 */
		for (RemyItinerary itinerary : itineraries) {
			List<RemyEventDate> dates = itinerary.getAllDates();
			Assert.assertEquals(5, dates.size());
		}
	}
}
