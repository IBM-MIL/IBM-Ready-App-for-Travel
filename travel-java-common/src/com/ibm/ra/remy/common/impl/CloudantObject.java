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
import java.util.Map;

import com.google.gson.Gson;

/**
 * Pojo that will be the base for each type we are storing as Cloudant documents.
 */
public class CloudantObject implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private String _id;
	private String type;
	private String _rev;
	/**
	 * constructor for the CloudantObject
	 * Sets the instance variables
	 * @param toClone
	 */
	public CloudantObject(CloudantObject toClone) {
		super();
		if (toClone != null) {
			this._id = toClone._id;
			this.type = toClone.type;
			this._rev = toClone._rev;
		}
	}
	
	/**
	 * Creates a CloudantObject from the associated Map object.  The following keys are required to exist in the Map
	 * in order to correctly setup the object.
	 * 
	 *     Key     Type     Value
	 *     
	 *     _id     String   Sets the objects unique ID
	 *     type    String   Sets the objects type
	 *     _rev    String   Sets the revision of the object. This corresponds to the revision in Cloudant.
	 * 
	 * @param data The Map used to seed the object.
	 */
	public CloudantObject(Map<String, Object> data) {
		super();
		if (data != null) {
			this._id = (String) data.get("_id");
			this.type = (String) data.get("type");
			this._rev = (String) data.get("_rev");
		}
	}
	
	/**
	 * default constructor
	 */
	public CloudantObject() {
		super();
	}
	/**
	 * Gets the _id field.
	 * @return _id
	 */
	public String getId() {
		return _id;
	}
	/**
	 * Sets the _id field.
	 * @param _id
	 */
	public void setId(String _id) {
		this._id = _id;
	}
	/**
	 * Sets the type for the document.
	 * @param type
	 */
	public void setType(String type) {
		this.type = type;
	}
	/**
	 * Gets the type for the document.
	 * @return
	 */
	public String getType() {
		return type;
	}
	/**
	 * Gets the revision number.
	 * @return
	 */
	public String get_rev() {
		return _rev;
	}
	/**
	 * Sets the revision number.
	 * @param _rev
	 */
	public void set_rev(String _rev) {
		this._rev = _rev;
	}
	/**
	 * Converts the data object into a JSON object.
	 * @return The JSON representation of this object, as a string.
	 */
	public String toString() {
		return new Gson().toJson(this);
	}

}
