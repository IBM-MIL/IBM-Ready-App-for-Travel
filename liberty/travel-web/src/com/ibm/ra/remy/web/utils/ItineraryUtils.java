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
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.logging.Logger;

import com.ibm.ra.remy.common.impl.RemyEventDateImpl;
import com.ibm.ra.remy.common.impl.RemyItineraryImpl;
import com.ibm.ra.remy.common.impl.RemyTravelDataImpl;
import com.ibm.ra.remy.common.model.RemyEvent;
import com.ibm.ra.remy.common.model.RemyEventDate;
import com.ibm.ra.remy.common.model.RemyItinerary;
import com.ibm.ra.remy.common.model.RemyRecs;
import com.ibm.ra.remy.common.model.RemyTravelData;
import com.ibm.ra.remy.common.model.RemyWeather;
import com.ibm.ra.remy.common.utils.DateUtils;

/**
 * Used to contain most of the business logic of getting the itinerary data from our back end and formatting it
 * into a data structure that will be consumed by the front end clients.
 * 
 */
public class ItineraryUtils {
	private static Map<String, RemyTravelData> cache = null;
	private static final Object lock = new Object();
	
	private Logger logger = Logger.getLogger(ItineraryUtils.class.getName());
	private MessageUtils mUtils = MessageUtils.getInstance();
	public static final String DEFAULT_LOCALE = "en";
	
	/**
	 * Supplementary method.  This will always retrieve the cached version of the itinerary data.
	 * See {@link #getItineraries(String, boolean) getItineraries} for more information.
	 * 
	 * @param locale The locale should use to retrieve all the data.
	 * @return A Map of itinerary data where the keys are the users who own the data.
	 * @throws Exception Any RuntimeException that can occur while gathering/formating the itinerary data.
	 */
	public Map<String, RemyTravelData> getItineraries(String locale) throws Exception {
		return this.getItineraries(locale, false);
	}
	
	/**
	 * This method is the brains of the whole operation.  It retrieves the data from Cloudant and calls the 
	 * Business Rules service as well as Watson Tradeoff Analytics in order to generate recommendations for the user
	 * based on gaps/actions we found in the itinerary. They are:
	 * 
	 * 1) We notice the user doesn't have a hotel booked, so we recommend a few hotels with member hotels listed first.
	 * 2) We notice a weather event (rain) occurs around the same time as an outdoor event and recommend changes to
	 * that event so it takes place at an indoor location now vs outdoor.
	 * 3) We notice that since you just changed locations for an event you probably don't have a way to get to the new
	 * location so we recommend some transit options the user can use to get to the new location.
	 * 
	 * We use Cloudant as our primary data store. We actually used services like Google Places API and the Weather
	 * Underground API to generate most of the data we have in Cloudant.  We just "cached" the results in Cloudant
	 * to ensure a consistent response for our sales team. The data structures for weather and places actually mimics
	 * what you would get back from either of the services (Google Places and Weather Underground) so you should be
	 * able to change out the Cloudant call and replace it with a call the real API and we should still work.
	 * 
	 * @param locale The locale should use to retrieve all the data.
	 * @param refresh If true it will force a refresh of the cache data. False will just return the cached data.
	 * @return A Map of itinerary data where the keys are the users who own the data.
	 * @throws Exception Any RuntimeException that can occur while gathering/formating the itinerary data.
	 */
	@SuppressWarnings("unchecked")
	public Map<String, RemyTravelData> getItineraries(String locale, boolean refresh) throws Exception {
		if (refresh) {
			synchronized(lock) {
				cache = null;	
			}
		}
		if (cache == null) {
			Exception exception = null;
			synchronized(lock) {
				try {
					if (cache == null) {
						locale = locale == null ? DEFAULT_LOCALE : locale;
						long startAll = new Date().getTime();
						long start = new Date().getTime();
						CloudantUtils cUtils = CloudantUtils.getInstance();
						logger.info("Instantiate cloudantutils: " + Utilities.getTimeDifference(start, new Date().getTime()));
						start = new Date().getTime();
						WeatherUtils wUtils = new WeatherUtils();
						logger.info("Instantiate weatherutils: " + Utilities.getTimeDifference(start, new Date().getTime()));

						start = new Date().getTime();
						@SuppressWarnings("rawtypes")
						List<HashMap> itineraries = cUtils.getDataWithComplexKey("remy_design/itineraryJsonView",
								new Object[] { 0, 0, locale, 0 }, new Object[] { Long.MAX_VALUE, Integer.MAX_VALUE, locale, 1 }, HashMap.class, true);
						logger.info("getItin data from cloudant: " + Utilities.getTimeDifference(start, new Date().getTime()));
						if (itineraries != null && !itineraries.isEmpty()) {
							start = new Date().getTime();
							List<RemyItinerary> sortedItins = formatJoinedItineraryForClient(itineraries);
							logger.info("call formatJoinedItinsforclient: " + Utilities.getTimeDifference(start, new Date().getTime()));
							
							// Now we need to inject weather data.
							start = new Date().getTime();
							String city = sortedItins.get(0).getInitialLocation().getCity();
							String country = sortedItins.get(0).getInitialLocation().getCountry();
							@SuppressWarnings("rawtypes")
							List<HashMap> weatherData = cUtils.getData("remy_design/weatherViewFiltered", 
									new Object[]{city, country, locale}, HashMap.class, true);
							logger.info("get weather data from cloudant: " + Utilities.getTimeDifference(start, new Date().getTime()));

							start = new Date().getTime();
							List<RemyWeather> weatherList = wUtils.formatWeatherForItinerary(weatherData);
							logger.info("format weather for itins: " + Utilities.getTimeDifference(start, new Date().getTime()));

							start = new Date().getTime();
							insertWeatherIntoItineraries(sortedItins, weatherList, true);

							logger.info("inject weather into itins: " + Utilities.getTimeDifference(start, new Date().getTime()));
							
							// Next, we need to acquire all the recommendations.
							start = new Date().getTime();
							@SuppressWarnings("rawtypes")
							List<HashMap> recommendations = cUtils.getDataWithComplexKey("remy_design/updatedRecsView", 
									new Object[]{locale,0}, new Object[]{locale,1}, HashMap.class, true);
							logger.info("get recommendations from cloudant: " + Utilities.getTimeDifference(start, new Date().getTime()));
							
							start = new Date().getTime();
							HashMap<String, RemyRecs> sortedRecs = RecommendationUtils.formatRecs(recommendations);
							logger.info("format recommendations: " + Utilities.getTimeDifference(start, new Date().getTime()));

							// Generate itinerary version 1: hotel recommendations
							start = new Date().getTime();
							RemyItinerary defaultItinerary = sortedItins.get(0);
							String defaultItineraryUser = defaultItinerary.getUser();
							RemyRecs defaultItineraryRecs = sortedRecs.get(defaultItineraryUser);

							RemyItinerary itin1 = RecEngineHotels.recommendHotels(defaultItinerary, defaultItineraryRecs, locale);
							itin1.setVersion(1);
							logger.info("call business rules for hotel recommendations: " + Utilities.getTimeDifference(start, new Date().getTime()));

							// Generate itinerary version 2: choose hotel
							start = new Date().getTime();
							RemyItinerary itin2 = RecEngineHotels.chooseHotel(itin1, locale);
							itin2.setVersion(2);
							logger.info("choose hotel recommendation: " + Utilities.getTimeDifference(start, new Date().getTime()));

							// Generate itinerary version 3: bad weather with recommended alternatives
							start = new Date().getTime();
							RemyItinerary itin3 = RecEngineWeather.injectBadWeather(itin2);
							itin3 = RecEngineWeather.recommendWeatherAlternatives(itin3, defaultItineraryRecs, locale);
							itin3.setVersion(3);
							logger.info("call personality insights for weather recommendations: " + Utilities.getTimeDifference(start, new Date().getTime()));

							// Generate itinerary version 4: alternative selected, transportation recommended
							start = new Date().getTime();
							RemyItinerary itin4 = RecEngineWeather.chooseWeatherAlternative(itin3);
							itin4 = RecEngineTransportation.recommendTransportation(itin4, defaultItineraryRecs, locale);
							itin4.setVersion(4);
							logger.info("call tradeoff analytics for transportation recommendations: " + Utilities.getTimeDifference(start, new Date().getTime()));

							// Generate itinerary version 5: transportation selected
							start = new Date().getTime();
							RemyItinerary itin5 = RecEngineTransportation.chooseTransportation(itin4);
							itin5.setVersion(5);
							logger.info("choose transportation recommendation: " + Utilities.getTimeDifference(start, new Date().getTime()));
							
							// Combine itineraries into JSON payload
							start = new Date().getTime();
							List<RemyItinerary> generatedItins = new ArrayList<RemyItinerary>();
							generatedItins.add(itin1);
							generatedItins.add(itin2);
							generatedItins.add(itin3);
							generatedItins.add(itin4);
							generatedItins.add(itin5);
							logger.info("combine generated itineraries: " + Utilities.getTimeDifference(start, new Date().getTime()));

							// Lastly, return the data.
							cache = getUserDeliverable(generatedItins);
							logger.info("Total time to generate itinerary data: " + Utilities.getTimeDifference(startAll, new Date().getTime()));
						}
					}	
				} catch(Exception ex) {
					exception = ex;
					//Basically we have this catch block to ensure that we never exit out of this method without releasing the lock on the lock object.
					logger.severe(ex.getMessage());
					ex.printStackTrace();
				}
			}
			//Now that we've let go of the lock, lets actually throw the exception
			if (exception != null) {
				throw exception;
			}
		} else {
			logger.info(mUtils.getMessage("MSG0011", locale));
		}

		long start = new Date().getTime();
		Map<String, RemyTravelData> copy = null;
		synchronized (lock) {
			copy = (Map<String, RemyTravelData>) DeepCopy.copy(cache);
		}
		
		logger.info("deep copy cached data: " + Utilities.getTimeDifference(start, new Date().getTime()));
		start = new Date().getTime();
		if (copy != null) {
			for (String key : copy.keySet()) {
				RemyTravelData data = copy.get(key);
				if (data != null) {
					data.fixTime();
				}
			}
		}
		logger.info("update timestamps from copy of cached data: " + Utilities.getTimeDifference(start, new Date().getTime()));
		return copy;
	}
	
	/**
	 * This method takes the Itinerary data and Event data stored in Cloudant and mashes it together to create the
	 * initial itinerary that we will return to the client.  This itinerary will contain all the users events for their
	 * trip, but still needs to be updates to include recommendations. 
	 * 
	 * @param data The data we pull from Cloudant. Mainly a list of Itineraries and their associated events.
	 * @return A list of RemyItinery objects representing all the itineraries available in the data.
	 */
	@SuppressWarnings("unchecked")
	private List<RemyItinerary> formatJoinedItineraryForClient(@SuppressWarnings("rawtypes") List<HashMap> data) {
		logger.finest(mUtils.getMessage("MSG0008", "getAll"));
		EventUtils eUtils = new EventUtils();
		Map<String, RemyItinerary> itins = new HashMap<String, RemyItinerary>();
		
		// This code also assumes that Cloudant returns itineraries first, and by design it should.
		String currentItinId = "";
		for (HashMap<String, Object> itinItem: data) {
			if (RemyEvent.ITINERARY.equals(itinItem.get(RemyEvent.TYPE_KEY))) {
				RemyItinerary itin = new RemyItineraryImpl(itinItem);
				currentItinId = itin.getId();
				itins.put(itin.getId(), itin);
			} else {
				RemyEvent event = eUtils.createEventFromHashmap(itinItem, currentItinId);
				RemyItinerary itin = itins.get(event.getItineraryId());
				long normalizedDate = DateUtils.generalizeTime(new Date(event.getTime())).getTime();
				RemyEventDate red = itin.getDate(normalizedDate);
				if (red == null) {
					red = new RemyEventDateImpl("","", normalizedDate, "");
					red.addEvent(event);
					itin.addDate(red);
				} else {
					red.addEvent(event);
				}
			}
		}
		
		// Now we need to sort the events in each date, because they're not guaranteed to come in any
		// specific order. The dates in an itinerary are pre-sorted because we use a TreeMap.
		for (RemyItinerary itinItem : itins.values()) {
			itinItem.sortAllEvents();
		}
		// Lastly, sort itineraries.
		List<RemyItinerary> completedItins = new ArrayList<RemyItinerary>(itins.values());
		Collections.sort(completedItins, new ItineraryComparer());
		
		return completedItins;
	}

	/**
	 * Takes weather data and injects the pieces we are interested in (daily high and low temperature and current
	 * conditions...i.e. cloudy, rainy, etc) and inject that into the data for each date of the trip. 
	 * 
	 * @param itineraries The list of itineraries we need to inject weather data into.
	 * @param weatherData The weather data we need to parse and then inject into the itinerary.
	 * @param metric True to insert metric measurements into the itineraries, or false to inject English measurements.
	 */
	private void insertWeatherIntoItineraries(List<RemyItinerary> itineraries, List<RemyWeather> weatherData, boolean metric) {
		final long millisInDay = 86400000;
		for (RemyItinerary i : itineraries) {
			// Get all dates, determine the max/min temperatures for that day, and inject.
			for (RemyEventDate e : i.getAllDates()) {
				if (e != null) {
					long startTime = e.getDate();
					long endTime = startTime + millisInDay;
					long minTemp = 1000;
					long maxTemp = -1000;
					Map<String, Integer> totals = new HashMap<String, Integer>(24);
					for (RemyWeather w : weatherData) {
						if (w.getDate() >= startTime && w.getDate() < endTime) {
							long temp = Long.parseLong(w.getTemperature(metric), 10);
							if (temp < minTemp) {
								minTemp = temp;
							}
							if (temp > maxTemp) {
								maxTemp = temp;
							}
							if (totals.containsKey(w.getCondition())) {
								totals.put(w.getCondition(), totals.get(w.getCondition()) + 1);
							} else {
								totals.put(w.getCondition(),1);
							}
						}
					}
					e.setTemperature(Long.toString(maxTemp), Long.toString(minTemp));
					TreeMap<Integer, String> sorted = new TreeMap<Integer, String>();
					for (String key : totals.keySet()) {
						sorted.put(totals.get(key), key);
					}
					e.setCondition(sorted.get(sorted.lastKey()));
				}
			}
		}
	}
	
	/**
	 * Creates the object that will be returned to the client.  Basically a Map of user id to itinerary mappings.
	 * 
	 * @param allItins The itineraries to put into the Map we will return
	 * @return The Map of data we will return to the user.
	 */
	private Map<String, RemyTravelData> getUserDeliverable(List<RemyItinerary> allItins) {
		HashMap<String, RemyTravelData> returnMap = new HashMap<String, RemyTravelData>();
		
		for (RemyItinerary itin : allItins) {
			String userName = itin.getUser();
			RemyTravelData userData = returnMap.get(userName);
			if (userData == null) {
				userData = new RemyTravelDataImpl();
				returnMap.put(userName, userData);
			}
			userData.addItinerary(itin);
		}
		
		return returnMap;
	}
}
