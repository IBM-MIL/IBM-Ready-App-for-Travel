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
import java.util.List;

import com.ibm.ra.remy.common.impl.RemyLodgingEvent;
import com.ibm.ra.remy.common.impl.RemyRecommendationsEvent;
import com.ibm.ra.remy.common.impl.RemyRecsImpl;
import com.ibm.ra.remy.common.impl.RemyRestaurantEvent;
import com.ibm.ra.remy.common.impl.RemyTransitEvent;
import com.ibm.ra.remy.common.model.RemyEvent;
import com.ibm.ra.remy.common.model.RemyRecs;

public class RecommendationUtils {	
	
	/**
	 * This function takes raw reommendation data from Cloudant and formats it into a series
	 * of RemyRecs objects, one for each user. Each RemyRecs object contains a list of 
	 * transit recommendations, lodging recommendations, and restaurant recommendations. The
	 * key in the returned HashMap is a String representing a username.
	 * 
	 * This function assumes that the actual recommended events come after the three events
	 * that collect the recommendations together.
	 * 
	 * @param recDataMap The raw recommendation data from Cloudant.
	 * @return The formatted RemyRecs objects for each user.
	 */
	@SuppressWarnings("unchecked")
	public static HashMap<String, RemyRecs> formatRecs(@SuppressWarnings("rawtypes") List<HashMap> recDataMap) {
		HashMap<String, RemyRecs> returnRecs = new HashMap<String, RemyRecs>();
		
		RemyRecs currentRecs = null;
		for (HashMap<String, Object> d : recDataMap) {
			// Is this a recs object?
			if (RemyEvent.RECOMMENDATIONS.equals(d.get(RemyEvent.SUBTYPE_KEY))) {
				RemyRecommendationsEvent newRecEvent = new RemyRecommendationsEvent(d, "0");
				// Is this a different user from before?
				String user = (String) d.get("user");
				if (currentRecs == null || !user.equals(currentRecs.getUser())) {
					// Do we need to retrieve a user from the map or create a new object?
					RemyRecs userRec = returnRecs.get(user);
					if (userRec == null) {
						// Create a new object and put it in our map.
						userRec = new RemyRecsImpl(user);
						returnRecs.put(user, userRec);
					}
					currentRecs = userRec;
				}
				// Insert the recommendations event into the RemyRecs object.
				if (RemyEvent.LODGING.equals(newRecEvent.getRecType())) {
					currentRecs.setLodgingRecs(newRecEvent);
				} else if (RemyEvent.TRANSIT.equals(newRecEvent.getRecType())) {
					currentRecs.setTransitRecs(newRecEvent);
				} else if (RemyEvent.RESTAURANT.equals(newRecEvent.getRecType())) {
					currentRecs.setRestaurantRecs(newRecEvent);
				}
			}
			// Is this an event?
			else {
				RemyEvent newRec = null;
				if (RemyEvent.LODGING.equals(d.get(RemyEvent.SUBTYPE_KEY))) {
					newRec = new RemyLodgingEvent(d, "0");
				} else if (RemyEvent.TRANSIT.equals(d.get(RemyEvent.SUBTYPE_KEY))) {
					newRec = new RemyTransitEvent(d, "0");
				} else if (RemyEvent.RESTAURANT.equals(d.get(RemyEvent.SUBTYPE_KEY))) {
					newRec = new RemyRestaurantEvent(d, "0");
				}
				currentRecs.addRec(newRec);
			}
		}
		
		return returnRecs;
	}
}
