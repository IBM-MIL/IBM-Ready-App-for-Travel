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

import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;

import org.apache.commons.codec.binary.Base64;

import com.google.gson.Gson;

/**
 * Utilities class used to keep the methods related to processing REST requests.
 */
public class RestUtils {
	
	/**
	 * Method to determine that the user sent us an actual value for the user name.
	 * @param username The user name to test
	 * @return True if there is a valid value, false otherwise
	 */
	public boolean isValidUser(String username) {
		return username != null && !"".equals(username);
	}
	
	/**
	 * Method to Base64 encode a string.
	 * 
	 * @param data The string to encode
	 * @return The Base 64 encoded String
	 */
	public String base64Encode(String data) {
		return Base64.encodeBase64String(data.getBytes());
	}
	
	/**
	 * Method to Base 64 decode a string.
	 * 
	 * @param data The string to decode.
	 * @return The decoded string.
	 */
	public String base64Decode(String data) {
		return new String(Base64.decodeBase64(data));
	}
	
	/**
	 * Convenience method for creating a Response object from some content an a response type.
	 * 
	 * @param content The content to embed in the Response object.
	 * @param responseType The type of Response to generate
	 * @return The generated Response object.
	 */
	public Response getResponse(Object content, Response.Status responseType) {
		ResponseBuilder rb =  Response.status(responseType);
		rb.entity(new Gson().toJson(content));
		
		return rb.build();
	}
}
