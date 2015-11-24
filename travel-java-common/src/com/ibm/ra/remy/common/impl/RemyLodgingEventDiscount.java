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

/**
 * This class represents a discount (whether loyalty or promotional) that
 * has been applied to a potential hotel booking.
 * 
 * Example: new RemyLodgingEvent("-30%: Gold Loyalty Membership", 99.99);
 */
public class RemyLodgingEventDiscount implements Serializable {

	private static final long serialVersionUID = 1L;
	private String message;
	private float previousPrice;
	private float discountedPrice;
	
	/**
	 * Default constructor. Required by the Bluemix Business Rules service.  Sets all the objects members to their default
	 * values.
	 */
	public RemyLodgingEventDiscount() {
		// constructor required for Business Rules
	}
	
	/**
	 * Constructor that sets all the members to this object.
	 * @param message The message for this discount object.
	 * @param previousPrice The original price that is being discounted.
	 * @param discountedPrice The discounted price.
	 */
	public RemyLodgingEventDiscount(String message, float previousPrice, float discountedPrice) {
		this.message = message;
		this.previousPrice = previousPrice;
		this.discountedPrice = discountedPrice;
	}
	
	/**
	 * Getter for the message property of this object. Required by the Business Rules service.
	 * @return The message associated with this discount.
	 */
	public String getMessage() {
		return this.message;
	}
	
	/**
	 * Setter for the message property. Required by the Business Rules service.
	 * @param message The message to set for this discount.
	 */
	public void setMessage(String message) {
		this.message = message;
	}
	
	/**
	 * Getter for the original price property. Required by the Business Rules service. 
	 * @return The original price for this discount.
	 */
	public float getPreviousPrice() {
		return this.previousPrice;
	}
	
	/**
	 * Setter for the original price property. Required by the Business Rules service.
	 * @param previousPrice The original price to set for this discount
	 */
	public void setPreviousPrice(float previousPrice) {
		this.previousPrice = previousPrice;
	}
	
	/**
	 * Getter for the discounted price property. Required by the Business Rules service.
	 * @return The discounted price
	 */
	public float getDiscountedPrice() {
		return this.discountedPrice;
	}
	
	/**
	 * Setter for the discounted price property. Required by the Business Rules service.
	 * 
	 * @param discountedPrice The discounted price.
	 */
	public void setDiscountedPrice(float discountedPrice) {
		this.discountedPrice = discountedPrice;
	}

}
