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

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Logger;

/**
 * Singleton used to load application level properties from a file versus hard coding these into Java code.
 */
public final class PropertiesReader {
	private MessageUtils mUtils = MessageUtils.getInstance();
	public static final Object CREATE_LOCK = new Object();
	// Logger
	private final static Logger LOGGER = Logger
			.getLogger(PropertiesReader.class.getName());

	// Singleton instance
	private static PropertiesReader singleton;

	// Instance variables
	private Properties properties;
	private static final String fileName = "resources/app.properties";

	/*
	 * Private constructor. This is where we load the app.properties file that contains all our app's properties.
	 */
	private PropertiesReader() {
		try {
			properties = new Properties();
			InputStream inStream = getClass().getClassLoader()
					.getResourceAsStream(fileName);
			properties.load(inStream);
		} catch (IOException e) {
			LOGGER.severe(mUtils.getMessage("MSG0010", new Object[]{fileName}));
			LOGGER.severe(e.getMessage());
		}
	}

	/**
	 * Method to retrieve the single instance to this class. 
	 * 
	 * @return The single instance of this class.
	 */
	public static PropertiesReader getInstance() {
		synchronized(CREATE_LOCK) {
			if (singleton == null) {
				singleton = new PropertiesReader();
			}
		}
		
		return singleton;
	}

	/**
	 * Retrieves a property from the properties file. By default all properties are read in as Strings from the
	 * properties file.
	 * 
	 * @param property The name of the property to retrieve from the file
	 * @return The string value of the key. Will return null if the property is not found or if the properties
	 * value is null.
	 */
	public String getStringProperty(String property) {
		return properties.getProperty(property);
	}

	/**
	 * Convenience method for taking a property from the file and attempting to convert the properties default String
	 * value into an integer value.  Note that this may throw a runtime exception if the property does not actually
	 * contain an integer.
	 * 
	 * @param property The name of the property to get
	 * @return The integer value for the given property
	 */
	public int getIntProperty(String property) {
		return Integer.parseInt(properties.getProperty(property));
	}
}
