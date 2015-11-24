/* 
 * Licensed Materials - Property of IBM © Copyright IBM Corporation 2015. All
 * Rights Reserved. This sample program is provided AS IS and may be used,
 * executed, copied and modified without royalty payment by customer (a) for its
 * own instruction and study, (b) in order to develop applications designed to
 * run with an IBM product, either for customer's own internal use or for
 * redistribution by customer, as part of such an application, in customer's own
 * products.
 */

package com.ibm.ra.remy.rest;

import java.util.logging.Logger;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.ibm.ra.remy.web.utils.ItineraryUtils;
import com.ibm.ra.remy.web.utils.MessageUtils;
import com.ibm.ra.remy.web.utils.RestUtils;


/**
 * Standard JAX-RS class that defines two end points. 
 * 
 *     /itinerary            - Main end point to retrieve itinerary data for all users.
 *     /itinerary/refresh    - Supplementary end point for forcing a refresh of the cache used in the /itinerary end point.
 *
 */
@Path("/itinerary")
public class ItineraryService {
	private Logger logger = Logger.getLogger(ItineraryService.class.getName());
	private MessageUtils mUtils = MessageUtils.getInstance();
	private RestUtils rUtils = new RestUtils();

	/**
	 * Rest end point that takes a locale and returns all the itineraries we have stored in our back end to the front
	 * end. The locale is taken to mimic that we use it when we would call external services as well as to provide
	 * our own internal messages in the correct locale (assuming we support the locale requested).  The structure 
	 * return is in essence a Map with each top level key being a string representing the users unique ID and 
	 * the value being all the itineraries belonging to that user. 
	 * 
	 * This method will generate a cache of the results if it is the first time this method has been run. On subsequent
	 * invocations, the cached data will always be returned even if there have been changes to the back end. To
	 * refresh the cache, see {@link #refreshCache(String) refreshCache} method.
	 * 
	 * @param locale  The locale for the data you want us to retrieve. This will be used to determine what locale
	 * our own messages are returned in as well as the locale we'll attempt to use when calling external services.
	 * @return A JAX-RS Response object representing the data we retrieved from our back end or some sort of error
	 * message that was encountered while processing the user request.
	 */
	@GET
	@Produces(MediaType.APPLICATION_JSON + ";charset=" + MessageUtils.ENCODING)
	public Response getAll(@QueryParam("locale") String locale) {
		if (locale == null) {
			locale = "en";
		}
		logger.finest(mUtils.getMessage("MSG0008", locale, "getAll"));
		Response r = null;
		try {
			ItineraryUtils iUtils = new ItineraryUtils();
			r = rUtils.getResponse(iUtils.getItineraries(locale), Response.Status.OK);
		} catch (Exception ex) {
			logger.severe(ex.getLocalizedMessage());
			ex.printStackTrace();
			r = rUtils.getResponse(ex.getLocalizedMessage(), Response.Status.INTERNAL_SERVER_ERROR);
		}
		return r;
	}
	
	/**
	 * See {@link #getAll(String) getAll} method.
	 * 
	 * The only difference between this method and the getAll method is that this method will ALWAYS perform a query
	 * for all the data. As the data is for the most part static, there is really no need to call this end point unless
	 * you needed to update some data on the back end and you need to refresh the cache.
	 * 
	 * 
	 * @param locale  The locale for the data you want us to retrieve. This will be used to determine what locale
	 * our own messages are returned in as well as the locale we'll attempt to use when calling external services.
	 * @return A JAX-RS Response object representing the data we retrieved from our back end or some sort of error
	 * message that was encountered while processing the user request.
	 */
	@GET
	@Path("/refresh")
	@Produces(MediaType.APPLICATION_JSON + ";charset=" + MessageUtils.ENCODING)
	public Response refreshCache(@QueryParam("locale") String locale) {
		if (locale == null) {
			locale = "en";
		}
		logger.finest(mUtils.getMessage("MSG0008", locale, "getAll"));
		Response r = null;
		try {
			ItineraryUtils iUtils = new ItineraryUtils();
			r = rUtils.getResponse(iUtils.getItineraries(locale, true), Response.Status.OK);
		} catch (Exception ex) {
			logger.severe(ex.getLocalizedMessage());
			ex.printStackTrace();
			r = rUtils.getResponse(ex.getLocalizedMessage(), Response.Status.INTERNAL_SERVER_ERROR);
		}
		return r;
	}
}
