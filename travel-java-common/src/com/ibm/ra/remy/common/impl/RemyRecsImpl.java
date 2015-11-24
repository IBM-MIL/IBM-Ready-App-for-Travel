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
import java.util.HashMap;
import java.util.List;

import com.ibm.ra.remy.common.model.RemyEvent;
import com.ibm.ra.remy.common.model.RemyRecs;

public class RemyRecsImpl implements RemyRecs, Serializable {

	private static final long serialVersionUID = 1L;
	private String user;
	private RemyRecommendationsEvent transitRecs;
	private RemyRecommendationsEvent restaurantRecs;
	private RemyRecommendationsEvent lodgingRecs;
	
	/**
	 * Default constructor. Sets all the properties to their default values.
	 */
	public RemyRecsImpl() {
		super();
		transitRecs = new RemyRecommendationsEvent();
		restaurantRecs = new RemyRecommendationsEvent();
		lodgingRecs = new RemyRecommendationsEvent();
	}
	
	/**
	 * Constructor that sets the user (owner) of these recommendations.
	 * @param user The user these recommendations are intended for.
	 */
	public RemyRecsImpl(String user) {
		this.user = user;
		transitRecs = new RemyRecommendationsEvent();
		restaurantRecs = new RemyRecommendationsEvent();
		lodgingRecs = new RemyRecommendationsEvent();
	}
	
	/**
	 * Constructor that will generate a RemyEventImpl object with the given data.  The Map should contain a list of
	 * {@link com.ibm.ra.remy.common.impl.RemyEventImpl RemyEventImpl} data or its subclasses. See those classes
	 * for the type of information that is needed.
	 * @param dataMap The list of Event objects in Map form.
	 */
	public RemyRecsImpl(List<HashMap<String, Object>> dataMap) {
		transitRecs = new RemyRecommendationsEvent();
		restaurantRecs = new RemyRecommendationsEvent();
		lodgingRecs = new RemyRecommendationsEvent();
		
		for (HashMap<String, Object> e : dataMap) {
			if (RemyEvent.TRANSIT.equals(e.get(RemyEvent.SUBTYPE_KEY))) {
				RemyTransitEvent event = new RemyTransitEvent(e, "0");
				transitRecs.addEvent(event);
			} else if (RemyEvent.RESTAURANT.equals(e.get(RemyEvent.SUBTYPE_KEY))) {
				RemyRestaurantEvent event = new RemyRestaurantEvent(e, "0");
				restaurantRecs.addEvent(event);
			} else if (RemyEvent.LODGING.equals(e.get(RemyEvent.SUBTYPE_KEY))) {
				RemyLodgingEvent event = new RemyLodgingEvent(e, "0");
				lodgingRecs.addEvent(event);
			}
		}
	}
	
	/**
	 * Another constructor that sets the different lists available for this object one by one.
	 * 
	 * @param transitRecs List of RemyTransitEvent objects
	 * @param restaurantRecs List of RemyRestaurantEvent objects to store
	 * @param lodgingRecs List of RemyLodgingEvent objects to store.
	 */
	public RemyRecsImpl(RemyRecommendationsEvent transitRecs, RemyRecommendationsEvent restaurantRecs, RemyRecommendationsEvent lodgingRecs) {
		this.transitRecs = transitRecs;
		this.restaurantRecs = restaurantRecs;
		this.lodgingRecs = lodgingRecs;
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyRecs#getUser()
	 */
	@Override
	public String getUser() {
		return this.user;
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyRecs#getTransitRecs()
	 */
	@Override
	public RemyRecommendationsEvent getTransitRecs() {
		return transitRecs;
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyRecs#setTransitRecs(RemyRecommendationsEvent)
	 * @param transitRecs
	 */
	@Override
	public void setTransitRecs(RemyRecommendationsEvent transitRecs) {
		this.transitRecs = transitRecs;
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyRecs#getRestaurantRecs()
	 */
	@Override
	public RemyRecommendationsEvent getRestaurantRecs() {
		return restaurantRecs;
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyRecs#setRestaurantRecs(RemyRecommendationsEvent)
	 * @param restaurantRecs
	 */
	@Override
	public void setRestaurantRecs(RemyRecommendationsEvent restaurantRecs) {
		this.restaurantRecs = restaurantRecs;
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyRecs#getLodgingRecs()
	 */
	@Override
	public RemyRecommendationsEvent getLodgingRecs() {
		return lodgingRecs;
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyRecs#setLodgingRecs(RemyRecommendationsEvent)
	 * @param lodgingRecs
	 */
	@Override
	public void setLodgingRecs(RemyRecommendationsEvent lodgingRecs) {
		this.lodgingRecs = lodgingRecs;
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyRecs#addRec(com.ibm.ra.remy.common.model.RemyEvent)
	 */
	@Override
	public void addRec(RemyEvent newRec) {
		if (RemyEvent.TRANSIT.equals(newRec.getSubtype())) {
			transitRecs.addEvent((RemyTransitEvent) newRec);
		} else if (RemyEvent.RESTAURANT.equals(newRec.getSubtype())) {
			restaurantRecs.addEvent((RemyRestaurantEvent) newRec);
		} else if (RemyEvent.LODGING.equals(newRec.getSubtype())) {
			lodgingRecs.addEvent((RemyLodgingEvent) newRec);
		}
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyRecs#fixTime()
	 */
	@Override
	public void fixTime() {
		if (transitRecs != null) {
			for (RemyEvent transit : transitRecs.getRecommendationList()) {
				if (transit != null) {
					transit.fixTime();
				}
			}
		}
		if (restaurantRecs != null) {
			for (RemyEvent restaurant : restaurantRecs.getRecommendationList()) {
				if (restaurant != null) {
					restaurant.fixTime();
				}
			}
		}
		if (lodgingRecs != null) {
			for (RemyEvent lodging : lodgingRecs.getRecommendationList()) {
				if (lodging != null) {
					lodging.fixTime();
				}
			}
		}
	}
}