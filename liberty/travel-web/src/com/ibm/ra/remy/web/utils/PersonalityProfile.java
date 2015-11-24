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

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import com.ibm.watson.developer_cloud.personality_insights.v2.PersonalityInsights;
import com.ibm.watson.developer_cloud.personality_insights.v2.model.Profile;
import com.ibm.watson.developer_cloud.personality_insights.v2.model.Trait;

/**
 * This class represents the personality profile of a given string of text.
 * It also includes functions for easily comparing profiles by distance
 * (i.e. the Euclidean distance between profiles when represented as a
 * vector of personality trait features).
 *
 * Example Use:
 * 1. Instantiate a PersonalityProfile with text from a user.
 * 2. Instantiate PersonalityProfiles with text from POIs.
 * 3. Call kNearestNeighbors() to find the k POIs with personalities
 *        closest to the user.
 */

public class PersonalityProfile {

	private Profile piProfile;
	private PersonalityProfile piProfileUser; // for comparator only

	/**
	 * Construct a profile by analyzing the given text with Personality
	 * Insights.
	 *
	 * @param username The username for Personality Insights.
	 * @param password The password for Personality Insights.
	 * @param text The string to analyze.
	 */
	public PersonalityProfile(String username, String password, String text) {
		PersonalityInsights service = new PersonalityInsights();
		service.setUsernameAndPassword(username, password);
		piProfile = service.getProfile(text);
	}

	/**
	 * Return the k profiles closest to this profile, in order of nearest
	 * to farthest.
	 *
	 * @param k The number of closest profiles to return
	 * @param profiles A list of profiles to compare
	 * @return A list of the k closest profiles to this profile
	 */
	public List<PersonalityProfile> kNearestNeighbors(int k, List<PersonalityProfile> profiles) {
		// set this profile for comparison
		for (PersonalityProfile profile : profiles) {
			profile.piProfileUser = this;
		}
		
		// compare profiles according to their distance from this profile
		class DistanceComparator implements Comparator<PersonalityProfile> {
			public int compare(PersonalityProfile profile1, PersonalityProfile profile2) {
				PersonalityProfile user = profile1.piProfileUser; 
				Double profile1Distance = user.distance(profile1);
				Double profile2Distance = user.distance(profile2);
				return Double.compare(profile1Distance, profile2Distance);
			}
		}

		// sort in ascending order of distance to this profile
		Collections.sort(profiles, new DistanceComparator());

		// if there are no more than k profiles, return all of them
		if (profiles.size() <= k) {
			return profiles;
		}
		
		// if there are more than k profiles, return the closest k
		List<PersonalityProfile> kNearestNeighbors = new ArrayList<PersonalityProfile>();
		for (int i = 0; i < k; i++) {
			kNearestNeighbors.add(profiles.get(i));
		}
		return kNearestNeighbors;
	}

	/**
	 * Extract traits pertinent to POI matching: adventurousness,
	 * artistic interests, intellect, excitement seeking, and outgoingness.
	 *
	 * @return A list of trait objects.
	 */
	private List<Trait> extractFeatures() {
		List<Trait> big5 = piProfile.getTree().getChildren().get(0).getChildren().get(0).getChildren();
        Trait adventurousness = big5.get(0).getChildren().get(0);
        Trait artisticInterests = big5.get(0).getChildren().get(1);
        Trait intellect = big5.get(0).getChildren().get(4);
        Trait excitementSeeking = big5.get(2).getChildren().get(3);
        Trait outgoing = big5.get(2).getChildren().get(4);
        Trait[] traits = {adventurousness, artisticInterests, intellect, excitementSeeking, outgoing};
        return Arrays.asList(traits);
	}

	/**
	 * Calculate the Euclidean distance between this profile and the other
	 * profile, using only the features pertinent to POI matching.
	 *
	 * @param other The profile to which distance is being measure.
	 * @return The distance between this profile and the other profile.
	 */
	public double distance(PersonalityProfile other) {
		List<Trait> traits1 = this.extractFeatures();
        List<Trait> traits2 = other.extractFeatures();
        if (traits1.size() != traits2.size()) {
            return Double.POSITIVE_INFINITY;
        }
        double squaredDistance = 0.0;
        for (int i = 0; i < traits1.size(); i++) {
            double trait1 = traits1.get(i).getPercentage();
            double trait2 = traits2.get(i).getPercentage();
            squaredDistance += (trait1 - trait2) * (trait1 - trait2);
        }
        double distance = Math.sqrt(squaredDistance);
        return distance;
	}

}
