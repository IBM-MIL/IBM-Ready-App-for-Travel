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

import org.apache.http.HttpEntity;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.EntityUtils;

/**
* This class communicates with Business Rules to send itineraries and process
* recommendation results.
*/
public class BusinessRulesUtils {
	
	private static final String USERNAME_KEY="BR_USERNAME";
	private static final String PASSWORD_KEY="BR_PASSWORD";
	private static final String EXECUTION_REST_URL_KEY="BR_EXECUTION_REST_URL";
	private static final String RULE_APP_PATH_KEY="BR_RULE_APP_PATH";
	
	/**
	 * Invoke Business Rules with JSON content
	 *
	 * @param content The payload of itineraries to send to Business Rules.
	 * @return A JSON string representing the output of Business Rules.
	 */
	public static String invokeRulesService(String json) throws Exception {
		PropertiesReader constants = PropertiesReader.getInstance();
		String username = constants.getStringProperty(USERNAME_KEY);
		String password = constants.getStringProperty(PASSWORD_KEY);
		String endpoint = constants.getStringProperty(EXECUTION_REST_URL_KEY) +
				          constants.getStringProperty(RULE_APP_PATH_KEY);

		CredentialsProvider credentialsProvider = new BasicCredentialsProvider();
		credentialsProvider.setCredentials(AuthScope.ANY, 
		    new UsernamePasswordCredentials(username, password));
		CloseableHttpClient httpClient =
				HttpClientBuilder.create().setDefaultCredentialsProvider(credentialsProvider).build();
		
		String responseString = "";
		
        try {
            HttpPost httpPost = new HttpPost(endpoint);
            httpPost.setHeader(HTTP.CONTENT_TYPE , ContentType.APPLICATION_JSON.toString());
            StringEntity jsonEntity = new StringEntity(json, MessageUtils.ENCODING);
            httpPost.setEntity(jsonEntity);
            CloseableHttpResponse response = httpClient.execute(httpPost);

            try {
                HttpEntity entity = response.getEntity();
                responseString = EntityUtils.toString(entity, MessageUtils.ENCODING);
                EntityUtils.consume(entity);
            } finally {
                response.close();
            }
        } finally {
            httpClient.close();
        }
		return responseString;
	}
}
