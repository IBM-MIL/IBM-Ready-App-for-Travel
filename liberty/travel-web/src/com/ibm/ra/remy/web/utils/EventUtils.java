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

import java.util.HashMap;
import java.util.logging.Logger;

import com.ibm.ra.remy.common.impl.RemyFlightEvent;
import com.ibm.ra.remy.common.impl.RemyLodgingEvent;
import com.ibm.ra.remy.common.impl.RemyMeetingEvent;
import com.ibm.ra.remy.common.impl.RemyRecommendationsEvent;
import com.ibm.ra.remy.common.impl.RemyRestaurantEvent;
import com.ibm.ra.remy.common.impl.RemyTransitEvent;
import com.ibm.ra.remy.common.model.RemyEvent;

/**
 * This class is used to keep as much RemyEvent logic needed on the back end side together. This will at the
 * very least keep the itinerary classes smaller with this code in here. 
 * 
 */
public class EventUtils {
	private static Logger logger = Logger.getLogger(EventUtils.class.getName());
	private static MessageUtils mUtils = MessageUtils.getInstance();
	
	/**
	 * Logic needed to figure out what type of RemyEvent we are processing so we can instantiate the correct implementing
	 * class.
	 * 
	 * @param eventMap A map containing a RemyEvent object. 
	 * @param itineraryId The unique id of the itinerary that this event belongs to.
	 * @return An instantiated RemyEvent based on the correct implementing type.
	 */
	public RemyEvent createEventFromHashmap(HashMap<String, Object> eventMap, String itineraryId) {
		RemyEvent retEvent = null;
		
		if (RemyEvent.LODGING.equals(eventMap.get(RemyEvent.SUBTYPE_KEY))) {
			retEvent = new RemyLodgingEvent(eventMap, itineraryId);
		} else if (RemyEvent.FLIGHT.equals(eventMap.get(RemyEvent.SUBTYPE_KEY))) {
			retEvent = new RemyFlightEvent(eventMap, itineraryId);
		} else if (RemyEvent.TRANSIT.equals(eventMap.get(RemyEvent.SUBTYPE_KEY))) {
			retEvent = new RemyTransitEvent(eventMap, itineraryId);
		} else if (RemyEvent.MEETING.equals(eventMap.get(RemyEvent.SUBTYPE_KEY))) {
			retEvent = new RemyMeetingEvent(eventMap, itineraryId);
		} else if (RemyEvent.RESTAURANT.equals(eventMap.get(RemyEvent.SUBTYPE_KEY))) {
			retEvent = new RemyRestaurantEvent(eventMap, itineraryId);
		} else if (RemyEvent.RECOMMENDATIONS.equals(eventMap.get(RemyEvent.SUBTYPE_KEY))) {
			retEvent = new RemyRecommendationsEvent(eventMap, itineraryId);
		} else {
			logger.warning(mUtils.getMessage("MSG0013", eventMap));
		}
		
		return retEvent;
	}
}
