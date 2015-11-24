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

import java.util.logging.Logger;

import com.google.gson.Gson;

public class Utilities {

	private static MessageUtils mUtils = MessageUtils.getInstance();
	private static final Logger logger = Logger.getLogger(Utilities.class
			.getSimpleName());
	private final PropertiesReader constants = PropertiesReader.getInstance();
	private final Gson parser = new Gson();
	public static final String DEFAULT_LOCALE = "en";
	
	public static long convertTime(long difference) {
		return (System.currentTimeMillis() + difference);
	}
	
	/**
	 * Get time difference from start to end. For performance testing.
	 * 
	 */
	public static String getTimeDifference(long start, long end) {
		long diff = end - start;
		int millis = (int) diff % 1000;
		int sec = (int) diff / 1000 % 60;
		int min = (int) diff / 1000 / 60 % 60;
		return mUtils.getMessage("GET_TIME_STRING", new Object[]{min, sec, millis});
	}
	
	/**
	 * Convenience method for calling {@link #isSanitary(String, String) isSanitary(boolean)} without a locale parameter.
	 * 
	 * @param argument The argument to check
	 * @return  True if the client argument is sanitary, or false if it contains bad strings.
	 */
	public boolean isSanitary(String argument) {
		return isSanitary(argument, constants.getStringProperty(DEFAULT_LOCALE));
	}

	/**
	 * Ensures that some sanity checking is done against the arguments passed in from the client to the back end. This
	 * method returns false if one of the "bad" strings is found, basically checking for sql injections, etc.
	 * 
	 * @param argument The parameter passed in from the client
	 * @param locale The locale of the client user
	 * @return True if the client argument is sanitary, or false if it contains bad strings.
	 */
	public boolean isSanitary(String argument, String locale) {
		boolean sanitary = true;
		if (argument == null) {
			sanitary = false;
		} else if ("".equals(argument)) {
			sanitary = false;
		} else if (argument.length() == 0) {
			sanitary = false;
		} else if (argument.contains(" ")) {
			sanitary = false;
		}

		return sanitary;
	}

	
	/**
	 * Attempts to parse the given object type from the Json string. If no object was parsable (or some other
	 * exception occurred, the method will return null.
	 * 
	 * @param json The json string to parse
	 * @param newClass The class to convert the json into.
	 * @return The object of the given class type found in the string, or null if the method was unable to parse the
	 * string correctly.
	 */
	public <T> T parseObject(String json, Class<T> newClass) {
		T newObj  = null; 
		try {
			
			newObj = parser.fromJson(json, newClass);
		} catch(Exception ex) {
			logger.info(ex.getLocalizedMessage());
			ex.printStackTrace();
		}
		return newObj;
	}
}
