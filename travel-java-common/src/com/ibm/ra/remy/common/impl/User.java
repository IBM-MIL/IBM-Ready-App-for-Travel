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
 * Pojo to represent a User
 */
public class User extends CloudantObject implements Serializable {

	private static final long serialVersionUID = 1L;
	private String username;
	private String password;
	private String firstName;
	private String lastName;
	private String company;
	private String locale;
	/**
	 * Gets the username.
	 * @return username
	 */
	public String getUsername() {
		return username;
	}
	/**
	 * Sets the username.
	 * @param username
	 */
	public void setUsername(String username) {
		this.username = username;
	}
	/**
	 * Gets the password.
	 * @return password
	 */
	public String getPassword() {
		return password;
	}
	/**
	 * Sets the password.
	 * @param password
	 */
	public void setPassword(String password) {
		this.password = password;
	}
	/**
	 * Gets the first name.
	 * @return firstName
	 */
	public String getFirstName() {
		return firstName;
	}
	/**
	 * Sets the first name.
	 * @param firstName
	 */
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	/**
	 * Gets the last name.
	 * @return lastName
	 */
	public String getLastName() {
		return lastName;
	}
	/**
	 * Sets the last name.
	 * @param lastName
	 */
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	/**
	 * Gets the company.
	 * @return company
	 */
	public String getCompany() {
		return company;
	}
	/**
	 * Sets the company.
	 * @param company
	 */
	public void setCompany(String company) {
		this.company = company;
	}
	/**
	 * Gets the locale.
	 * @return locale
	 */
	public String getLocale() {
		return locale;
	}
	/**
	 * Sets the locale.
	 * @param locale
	 */
	public void setLocale(String locale) {
		this.locale = locale;
	}
}
