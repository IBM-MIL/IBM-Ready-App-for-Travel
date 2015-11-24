/*
 *  Licensed Materials - Property of IBM
 *  5725-I43 (C) Copyright IBM Corp. 2011, 2013. All Rights Reserved.
 *  US Government Users Restricted Rights - Use, duplication or
 *  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

/**
 *  WL.Server.invokeHttp(parameters) accepts the following json object as an argument:
 *  
 *  {
 *  	// Mandatory 
 *  	method : 'get' , 'post', 'delete' , 'put' or 'head' 
 *  	path: value,
 *  	
 *  	// Optional 
 *  	returnedContentType: any known mime-type or one of "json", "css", "csv", "plain", "xml", "html"  
 *  	returnedContentEncoding : 'encoding', 
 *  	parameters: {name1: value1, ... }, 
 *  	headers: {name1: value1, ... }, 
 *  	cookies: {name1: value1, ... }, 
 *  	body: { 
 *  		contentType: 'text/xml; charset=utf-8' or similar value, 
 *  		content: stringValue 
 *  	}, 
 *  	transformation: { 
 *  		type: 'default', or 'xslFile', 
 *  		xslFile: fileName 
 *  	} 
 *  } 
 */

/**
 * This method processes the JSON response and sets the isSuccessful flag to
 * false if the server responded with code that is not a 200 or 300. By default, the
 * isSuccessful flag is set to false only if the HTTP host is not reachable or
 * invalid HTTP request timed out. Hence, the need for this method. For further details, see:
 * https://www.ibm.com/developerworks/community/blogs/worklight/entry/handling_backend_responses_in_adapters?lang=en
 * 
 * @param response
 */
function handleResponse(response) {
	// Is MFP assumes isSuccessful to be true but the response status code is not a 200 or 300 
	// then change the isSuccessful to be false.
	if (response !== undefined && response.isSuccessful && 
		(response.statusCode > 399 || response.statusCode < 200)) {
		response.isSuccessful = false;
	}
	return response;
}

/**
 * @returns json list of itineraries that belong to the user
 */
function getTravelData(userLocale) {	
	var input = {
	    method : 'get',
	    returnedContentType : 'json',
	    path : 'travel-web/remy/itinerary/',
	    parameters: {locale: userLocale}
	};
	WL.Logger.error("locale: " + userLocale)
	
	return handleResponse(WL.Server.invokeHttp(input));
}

