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

import java.text.MessageFormat;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.logging.Logger;

/**
 * This class keeps track of all the error messages and codes
 * issued to the client.
 */
public final class MessageUtils {
	public static final Object CREATE_LOCK = new Object();
	public static final String ENCODING = "UTF-8";
	private static final String MESSAGES_PREFIX = "resources.messages";
	private static final String DEFAULT_LOCALE = "en_US";
	private static MessageUtils instance;
	Map<String, ResourceBundle> bundles;
	private static final Logger logger = 
			Logger.getLogger(MessageUtils.class.getName());
	
	/**
	 * Private constructor that loads the messages file for the default locale.
	 */
	private MessageUtils()  {
		bundles = new HashMap<String, ResourceBundle>();
		bundles.put(DEFAULT_LOCALE, ResourceBundle.getBundle(MESSAGES_PREFIX, new Locale(DEFAULT_LOCALE)));
	}
	
	/**
	 * Gets the singleton instance for this service.
	 * 
	 * @return The singleton instance for this class.
	 */
	public static MessageUtils getInstance() {
		synchronized(CREATE_LOCK) {
			if (instance == null) {
				instance = new MessageUtils();
			}
		}
		
		return instance;
	}
	
	/**
	 * Gets a message with the given key from the default locale message file (en_US).
	 * 
	 * @param key The key to look for in the message file.
	 * @return Either the message associated with the given key, or the key itself if the key is not found in the
	 * messages file.
	 */
	public String MSG0001(String key) {
		return getMessageFromBundle(key, DEFAULT_LOCALE, (Object) null);
	}

	/**
	 * Gets a message with the given key from the given locale message file.  If the locale specified is not supported
	 * then the default locale is used (en_US).
	 * 
	 * @param key The key to look for in the message file.
	 * @param locale The locale the client is using.
	 * @return Either the message associated with the given key, or the key itself if the key is not found in the
	 * messages file.
	 */
	public String getMessage(String key, String locale) {
		return getMessageFromBundle(key, locale, (Object) null);
	}
	
	/**
	 * Gets a message with the given key from the default locale message file (en_US).  The arguments are substituted
	 * into the string retrieved from the messages file to form the full message.  For instance, if the following
	 * arguments are passed in 
	 * 
	 * {Hello,World,1}
	 * 
	 * And the following message is retrieved from the messages file:
	 * 
	 * "The {1} enjoys it when I say {0}. {2} is the first non-zero positive integer"
	 * 
	 * then the following message would be returned:
	 * 
	 * "The World enjoys it when I say Hello.  1 is the first non-zero positive integer"
	 * 
	 * @param key The key to look for in the message file.
	 * @param args The arguments that we want to substitute into the message variables.
	 * @return Either the message associated with the given key, or the key itself if the key is not found in the
	 * messages file.
	 */
	public String getMessage(String key, Object... args) {
		return getMessageFromBundle(key, DEFAULT_LOCALE, args);
	}
	
	/**
	 * Gets a message with the given key from the given locale message file.  The arguments are substituted
	 * into the string retrieved from the messages file to form the full message.  For instance, if the following
	 * arguments are passed in 
	 * 
	 * {Hello,World,1}
	 * 
	 * And the following message is retrieved from the messages file:
	 * 
	 * "The {1} enjoys it when I say {0}. {2} is the first non-zero positive integer"
	 * 
	 * then the following message would be returned:
	 * 
	 * "The World enjoys it when I say Hello.  1 is the first non-zero positive integer"
	 * 
	 * If the locale provided is not supported then we default locale (en_US) message file is searched instead.
	 * 
	 * @param key The key to look for in the message file.
	 * @param locale The locale for which we want to retrieve the message
	 * @param args The arguments that we want to substitute into the message variables.
	 * @return Either the message associated with the given key, or the key itself if the key is not found in the
	 * messages file.
	 */
	public String getMessage(String key, String locale, Object... args) {
		return getMessageFromBundle(key, locale, args);
	}
	
	/**
	 * Attempts to retrieve the message for the given key from the ResourceBundle that has loaded the messages file
	 * for the requested locale.
	 * 
	 * @param key The key to look for.
	 * @param locale The locale of the message file we want to search.
	 * @param args Optional arguments for substituting variables in strings loaded from the resource bundle
	 * @return The message requested, or the key if the message was not found in the message bundle.
	 */
	private String getMessageFromBundle(String key, String locale, Object... args) {
		ResourceBundle bndl = getBundle(locale);
		String message = key;
		try {
			message = bndl.getString(key);
			if (args != null) {
				message = MessageFormat.format(message, args);
			}
		} catch(Exception ex) {
			logger.finest(ex.getMessage());
		}
		return message;
	}
	
	/**
	 * Method to attempt to load the message file from disk for the given locale.  If the locale is not supported then
	 * we should revert back to english.
	 * 
	 * @param locale The locale requested.
	 * @return A resource bundle to supported the given requested locale. Either the locale requested or the default 
	 * locale (en_US).
	 */
	private ResourceBundle getBundle(String locale) {
		ResourceBundle bndl = bundles.get(DEFAULT_LOCALE);
		if (!bundles.containsKey(locale)) {
			try {
				bndl = ResourceBundle.getBundle(MESSAGES_PREFIX, new Locale(locale));
				bundles.put(locale, bndl);
			} catch (Exception ex) {
				logger.severe(getMessage("MSG0009", new Object[]{locale, DEFAULT_LOCALE}));
			}
		}
		return bndl;
	}
}
