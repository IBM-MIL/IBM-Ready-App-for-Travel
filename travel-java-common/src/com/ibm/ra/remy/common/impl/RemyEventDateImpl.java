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
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import com.google.gson.Gson;
import com.ibm.ra.remy.common.model.RemyEvent;
import com.ibm.ra.remy.common.model.RemyEventDate;
import com.ibm.ra.remy.common.utils.DateUtils;

/**
 * Class used to represent a date within an Itinerary object. This class will contain some weather information (
 * namely high/low temperature and the condition) along with the events scheduled to occur on that day.
 */
public class RemyEventDateImpl implements RemyEventDate, Serializable {

	private static final long serialVersionUID = 1L;
	private long date;
	private String temperatureHigh;
	private String temperatureLow;
	private List<RemyEvent> events = new ArrayList<RemyEvent>();
	private String condition;

	/**
	 * Default constructor. Used to set the weather information and the actual date that this RemyEventDateImpl
	 * object represents
	 * 
	 * @param tempHigh The high temperature for this date
	 * @param tempLow The low temperature for this date
	 * @param date The date this object represents
	 * @param condition The weather conditions for this date. Usually something along the lines of 'rainy', 'cloudy', etc
	 */
	public RemyEventDateImpl(String tempHigh, String tempLow, long date, String condition) {
		this.date = date;
		this.temperatureHigh = tempHigh;
		this.temperatureLow = tempLow;
		this.condition = condition;
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyEventDate#getEvents()
	 */
	@Override
	public List<RemyEvent> getEvents() {
		return events;
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyEventDate#addEvent(com.ibm.ra.remy.common.model.RemyEvent)
	 */
	@Override
	public void addEvent(RemyEvent event) {
		events.add(event);
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyEventDate#removeEvent(com.ibm.ra.remy.common.model.RemyEvent)
	 */
	@Override
	public void removeEvent(RemyEvent event) {
		for (RemyEvent e : this.events) {
			if (e.getId().equals(event.getId())) {
				this.events.remove(e);
				return;
			}
		}
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyEventDate#getDate()
	 */
	@Override
	public long getDate() {
		return date;
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyEventDate#setTemperature(java.lang.String, java.lang.String)
	 */
	@Override
	public void setTemperature(String tempHigh, String tempLow) {
		this.temperatureHigh = tempHigh;
		this.temperatureLow = tempLow;
	}
	
	/**
	 * @see com.ibm.ra.remy.common.model.RemyEventDate#sortEvents()
	 */
	@Override
	public void sortEvents() {
		Collections.sort(this.events, new Comparator<RemyEvent>(){
			@Override
			public int compare(final RemyEvent lhs, final RemyEvent rhs) {
				return (int) (lhs.getTime() - rhs.getTime());
			}
		});
	}
	
	/**
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return new Gson().toJson(this);
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyEventDate#getHighTemperature()
	 */
	@Override
	public String getHighTemperature() {
		return this.temperatureHigh;
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyEventDate#getLowTemperature()
	 */
	@Override
	public String getLowTemperature() {
		return this.temperatureLow;
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyEventDate#getCondition()
	 */
	@Override
	public String getCondition() {
		return condition;
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyEventDate#setCondition(java.lang.String)
	 */
	@Override
	public void setCondition(String condition) {
		this.condition = condition;
	}

	/**
	 * @see com.ibm.ra.remy.common.model.RemyEventDate#fixTime()
	 */
	@Override
	public void fixTime() {
		Date baseline = DateUtils.generalizeTime(new Date());
		date += baseline.getTime();
		if (events != null) {
			for (RemyEvent event : events) {
				if (event != null) {
					event.fixTime();
				}
			}
		}
	}
}
