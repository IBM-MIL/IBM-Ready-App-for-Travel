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

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import com.ibm.ra.remy.common.impl.RemyLodgingEvent;
import com.ibm.ra.remy.common.impl.RemyRecommendationsEvent;
import com.ibm.ra.remy.common.impl.RemyRestaurantEvent;
import com.ibm.ra.remy.common.impl.RemyTransitEvent;
import com.ibm.ra.remy.common.model.RemyEvent;
import com.ibm.ra.remy.common.model.RemyEventDate;
import com.ibm.ra.remy.common.model.RemyItinerary;
import com.ibm.ra.remy.common.model.RemyLocation;
import com.ibm.ra.remy.common.model.RemyTravelData;
import com.ibm.ra.remy.common.utils.DateUtils;
import com.ibm.ra.remy.web.utils.ItineraryUtils;

public class TestLaraItineraryData {
	private static RemyTravelData data;
	private static List<RemyItinerary> lauraItineraries;
	private static RemyItinerary itinWithHotelRecs;
	private static RemyItinerary itinWithWeatherRecs;
	private static RemyItinerary itinWithTransitRecs;
	private static final String LARA_KEY = "user1";
	
	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
		ItineraryUtils iUtils = new ItineraryUtils();
		Map<String, RemyTravelData> all = iUtils.getItineraries("en");
		data = all.get(LARA_KEY);
		Assert.assertNotNull(data);
		
		lauraItineraries = data.getItineraries();
		Assert.assertNotNull(lauraItineraries);
		
		itinWithHotelRecs = lauraItineraries.get(0);
		Assert.assertNotNull(itinWithHotelRecs);
		
		itinWithWeatherRecs = lauraItineraries.get(2);
		Assert.assertNotNull(itinWithWeatherRecs);
		
		itinWithTransitRecs = lauraItineraries.get(3);
		Assert.assertNotNull(itinWithTransitRecs);
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
	}

	/**
	 * Tests the basic data we get back for Lara. Makes sure we get the 5 itineraries we know should be there for
	 * her story and that the start time for her trip is in the next 24 hours. Also makes sure we put weather
	 * data in for all the itineraries and also that none of the dates are empty for any of the itineraries.
	 */
	@Test
	public void testLarasData() {
		
		
		Assert.assertNotNull(lauraItineraries);
		Assert.assertNotEquals(0, lauraItineraries.size());
		Assert.assertEquals(5, lauraItineraries.size());
		/*
		 * Itineraries contains a list of itinerary versions for Lara. Each one has one change, say a weather event
		 * that causes it to be different than the other itineraries in the list.  Each one should also start 
		 * "tomorrow".
		 */
		int itinNumber = 1;
		for (RemyItinerary itinerary : lauraItineraries) {
			long tomorrow = DateUtils.addHours(DateUtils.generalizeTime(new Date()), 24).getTime();
			long twoDaysOut = DateUtils.addHours(new Date(tomorrow), 24).getTime();
			long itinStartDate = itinerary.getStartTime();
			//Check the itineraries are returned in sorted order by version
			Assert.assertEquals(itinNumber++, itinerary.getVersion());
			//Be sure that the trip starts tomorrow instead of some other time.
			Assert.assertTrue((tomorrow < itinStartDate) && (itinStartDate < twoDaysOut));
			//Lara's trip is from Stuttgart -> Berlin, lets check thats her destination.
			RemyLocation loc = itinerary.getInitialLocation();
			Assert.assertEquals("Berlin", loc.getCity());
			Assert.assertEquals("Germany", loc.getCountry());
			
			for (RemyEventDate date : itinerary.getAllDates()) {
				//Lets check for valid temperatures.
				Assert.assertNotEquals(1000, date.getLowTemperature());
				Assert.assertNotEquals(-1000, date.getHighTemperature());
				//And that each day has at least one event.
				Assert.assertFalse(date.getEvents().isEmpty());
			}
		}
	}

	/**
	 * Ensures that the recommendations for the hotel are in the correct date in the itinerary and that they are sorted
	 * in the correct order (basically the partner hotel should be first..this should be done by Business Rules).
	 */
	@Test
	public void testLaraHotelRecommendations() {
		List<RemyEventDate> dates = itinWithHotelRecs.getAllDates();
		Assert.assertNotNull(dates);
	
		RemyEventDate date = dates.get(0);
		List<RemyEvent> events = date.getEvents();
		Assert.assertNotNull(events);
		
		RemyEvent hotelRec = events.get(1);
		Assert.assertEquals(RemyRecommendationsEvent.class, hotelRec.getClass());
		
		RemyRecommendationsEvent recEvent = (RemyRecommendationsEvent) hotelRec;
		List<RemyEvent> recommendations = recEvent.getRecommendationList();
		System.out.println("class: " + hotelRec.getClass());
		RemyLodgingEvent hotel = (RemyLodgingEvent) recommendations.get(0);
		//The trusted partner should show up first.
		Assert.assertNotNull(hotel);
		Assert.assertEquals("Hotel Gartenbrand", hotel.getName());
		Assert.assertTrue(hotel.getIsPreferred());
		
		//Then the non-trusted partners.
		for (int i = 1 ; i < recommendations.size() ; ++ i) {
			hotel = (RemyLodgingEvent) recommendations.get(i);
			//should not be sending back null events.
			Assert.assertNotNull(hotel);
			Assert.assertFalse(hotel.getIsPreferred());
		}
	}

	/**
	 * Checks that the hotels are coming back in the correct order from Watson.  Also checking that the
	 * recommendations do not include hotels that are outside as thats what we're trying to move away from to being 
	 * with.
	 */
	@Test
	public void testLaraWeatherRecommendations() {
		List<RemyEventDate> dates = itinWithWeatherRecs.getAllDates();
		Assert.assertNotNull(dates);

		RemyEventDate date = dates.get(2);
		List<RemyEvent> events = date.getEvents();
		Assert.assertNotNull(events);
		
		RemyEvent weatherRec = events.get(1);
		System.out.println("class: " + weatherRec.getClass());
		Assert.assertEquals(RemyRestaurantEvent.class, weatherRec.getClass());

		RemyRestaurantEvent restEvent = (RemyRestaurantEvent) weatherRec;
		RemyRecommendationsEvent recEvent  = restEvent.getRecommendedReplacements();
		List<RemyEvent> recommendations = recEvent.getRecommendationList();
		System.out.println("class2: " + recommendations.get(0).getClass());
		//Now we gotta make sure that the events are not at outdoor venues, which was the initial problem.
		String[] restaurantNamesInSortedOrder = new String[]{"Ristorante La Tettoia", "Big Bascha", "El Reda",
				"Cafe Mauerwerk","Restaurant Winterfeld"};
		Assert.assertEquals(restaurantNamesInSortedOrder.length, recommendations.size());
		for (int i = 0 ; i < recommendations.size() ; ++i) {
			RemyRestaurantEvent rre = (RemyRestaurantEvent) recommendations.get(i);
			Assert.assertFalse(rre.isOutdoor());
			Assert.assertFalse(rre.getAffectedByWeather());
			Assert.assertEquals(restaurantNamesInSortedOrder[i], rre.getName());
		}
	}

	/**
	 * Test the transit recommendations for Lara to make sure they come back in the right order. 
	 */
	@Test
	public void testLaraTransitRecommendations() {
		List<RemyEventDate> dates = itinWithTransitRecs.getAllDates();
		Assert.assertNotNull(dates);

		RemyEventDate date = dates.get(2);
		List<RemyEvent> events = date.getEvents();
		Assert.assertNotNull(events);
		
		RemyEvent transitRecs = events.get(1);
		System.out.println("class: " + transitRecs.getClass());
		Assert.assertEquals(RemyRecommendationsEvent.class, transitRecs.getClass());

		RemyRecommendationsEvent recEvent = (RemyRecommendationsEvent) transitRecs;
		List<RemyEvent> recommendations = recEvent.getRecommendationList();
		System.out.println("class3: " + recommendations.get(0).getClass());
		String[] transitRailSorted = new String[]{"walk_rail_rail_walk","walk_bus_walk",
				"blablacar","walk_rail_bus_walk","walk_car"};
		Assert.assertEquals(transitRailSorted.length, recommendations.size());
		for (int i = 0 ; i < recommendations.size() ; ++i){
			RemyTransitEvent rte = (RemyTransitEvent) recommendations.get(i);
			Assert.assertEquals(transitRailSorted[i], rte.getIos_transit_name());
		}
	}
}
