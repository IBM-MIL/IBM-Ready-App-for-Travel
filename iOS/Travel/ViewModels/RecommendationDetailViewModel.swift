/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit
import CoreLocation

class RecommendationDetailViewModel {
    
    //Property holds the current event the recommendation detail view controller is showing info about
    var event : Event?
    
    //Constant property for lodging subtype and its respective navigation bar and bottom button titles
    let kLodgingSubType = "lodging"
    let kLodgingNavigationBarTitle = NSLocalizedString("Hotel Detail", comment: "")
    let kLodgingBottomButtonTitle = NSLocalizedString("B O O K   H O T E L", comment: "")
    
    //Constant property for the restaurant subtype and its respective navigation bar and bottom button titles
    let kRestaurantSubType = "restaurant"
    let kRestaurantNavigationBarTitle = NSLocalizedString("Restaurant Detail", comment: "")
    let kRestaurantBottomButtonTitle = NSLocalizedString("U P D A T E   E V E N T", comment: "")
    
    //Constant property for the transit subtype and its respective navigation bar and bottom button titles
    let kTransitSubType = "transit"
    let kTransitNavigationBarTitle = NSLocalizedString("Transportation Detail", comment: "")
    let kTransitBottomButtonTitle = NSLocalizedString("U P D A T E   I T I N E R A R Y", comment: "")
    let kNumberOfSectionsInTransportationTableView = 1
    
    /**
    Method sets the event property upon init
    
    - parameter event: Event
    
    - returns: Event
    */
    init(event : Event){
        self.event = event
    }
    
    
    /**
    Method returns the event (recommendation) subtype
    
    - returns: String
    */
    func getRecommendedSubType() -> String {
        return (event?.subType)!
    }
    
    
    /**
    Method that sets up the recommendedHotelDetailView pararemeter with the event property's data
    
    - parameter recommendedHotelDetailView: RecommendedHotelDetailView
    */
    func setUpRecommendedHotelDetailView(recommendedHotelDetailView : RecommendedHotelDetailView){
        
        var previousPrice : Double?
        var discountPrice: Double?
        if let isLoyaltyMember = event!.isLoyaltyMember {
            if (isLoyaltyMember == true){
                previousPrice = event!.loyaltyDiscount?.previousPrice
                discountPrice = event!.loyaltyDiscount?.discountedPrice
            }
        }
        
        if let hasPromoDiscount = event!.hasPromotionalDiscount {
            if (hasPromoDiscount == true){
                previousPrice = event!.promotionalDiscount?.previousPrice
                discountPrice = event!.promotionalDiscount?.discountedPrice
            }
        }
        
        if let isLoyaltyMember = event!.isLoyaltyMember, let hasPromoDiscount = event!.hasPromotionalDiscount {
            if(isLoyaltyMember == false && hasPromoDiscount == false){
                discountPrice = event!.price
            }
        }
        
        recommendedHotelDetailView.setUpData(
            event?.title,
            hotelSubtitle: event?.description,
            isPartner: event?.isTrustedPartner,
            rationale: event?.rationale,
            locationAddress: event?.location,
            numberOfStars: event?.rating,
            price: discountPrice,
            originalPrice: previousPrice,
            reviewHighlight: event?.reviewHighlight,
            reviewer: event?.reviewer,
            reviewerTime: event?.reviewTime
        )
    }
    
    
    /**
    Method that sets up the recommendedRestaurantDetailView with the event property's data
    
    - parameter recommendedRestaurantDetailView: RecommmendedRestaurantDetailView
    */
    func setUpRecommendedRestaurantDetailView(recommendedRestaurantDetailView : RecommendedRestaurantDetailView){
        
         recommendedRestaurantDetailView.setupData(
            event?.isTrustedPartner,
            typeOfRestaurant: event?.cuisine,
            locationName: event?.name,
            locationAddress: event?.location,
            city: event?.geometry?.city,
            priceLevel: event?.price_level,
            rating: event?.rating,
            reviewHighlight: event?.reviewHighlight,
            reviewer: event?.reviewer,
            reviewerTime: event?.reviewTime
        )
        
    }
    
    /**
    Method that sets up the recommendedTransportationDetailView with the event property's data
    
    - parameter recommendedTransportationDetailView: RecommendedTransportationDetailView
    */
    func setUpRecommendedTransportationDetailView(recommendedTransportationDetailView : RecommendedTransportationDetailView){
        recommendedTransportationDetailView.setUpData(
            event?.start_time,
            end_time: event?.end_time,
            ios_transit_name: event?.ios_transit_name
        )

    }
    
    /**
    Method that returns the navigation bar title depending on what type of recType the event property is
    
    - returns: String
    */
    func getNavigationBarTitle() -> String {
        if let rec_type = event?.subType {
            if(rec_type == kLodgingSubType){
                return kLodgingNavigationBarTitle
            }
            else if(rec_type == kRestaurantSubType){
                return kRestaurantNavigationBarTitle
            }
            else{
                return ""
            }
        }
        else {
            return ""
        }
    }
    
    
    
    /**
    Method that returns the bottomButtonTitle depending on what type of recType the event property is
    
    - returns: String
    */
    func getBottomButtonTitle() -> String {
        if let rec_type = event?.subType {
            if(rec_type == kLodgingSubType){
                return kLodgingBottomButtonTitle
            }
            else if(rec_type == kRestaurantSubType){
                return kRestaurantBottomButtonTitle
            }
            else{
                return ""
            }
        }
        else {
            return ""
        }
    }
    
    
    
    /**
    Method that returns a CLLocationCoordinate2D created from the event property's lat and long
    
    - returns: CLLocationCoordinate2D
    */
    func getMapViewCLLocationCoordinate2D() -> CLLocationCoordinate2D? {
        if let geometry = event?.geometry, let location = geometry.location, let lat = location.lat, let long = location.lng {
           return CLLocationCoordinate2DMake(lat, long)
        }
        else {
            return nil
        }
    }
    
    
    /**
    Method that returns the number of rows in the section defined by the section parameter. This is determined by the number of transit steps the event property has
    
    - parameter section: Int
    
    - returns: Int
    */
    func numberOfRowsInSection(section : Int) -> Int {
        if let steps = event?.transit_steps {
            return steps.count
        }
        else{
            return 0
        }
    }
    
    
    /**
    Method that returns the number of sections in the tableView, which is a constant of 1
    
    - returns: Int
    */
    func numberOfSectionsInTableView() -> Int {
        return kNumberOfSectionsInTransportationTableView
    }
    
    
    /**
    Method that returns the TransitStep at indexPath
    
    - parameter indexPath: NSIndexPath
    
    - returns: TransitStep
    */
    func getTransitStepAtIndexPath(indexPath : NSIndexPath) -> TransitStep{
         return event!.transit_steps![indexPath.row]
    }
    
    
    /**
    Method that sets up the tableViewCell at the indexPath parameter with the transitStep that corresponds with that indexPath
    
    - parameter indexPath: NSIndexPath
    - parameter tableView: UITableView
    
    - returns: UITableViewCell
    */
    func setUpTableViewCell(indexPath : NSIndexPath, tableView: UITableView) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("transportationDetail", forIndexPath: indexPath) as! RecommendedTransportationDetailTableViewCell
    
        let transitStep = getTransitStepAtIndexPath(indexPath)

        cell.setUpData(
            transitStep.start_time,
            end_time: transitStep.end_time,
            details: transitStep.details,
            type: transitStep.type,
            walkTime: transitStep.walkTime,
            transitLine: transitStep.transitLine,
            departureArea: transitStep.departureArea,
            arrivalArea: transitStep.arrivalArea,
            numberOfStops: transitStep.stops
        )
        
        return cell
    }

    

    /**
    Method that switches the TravelDataManager's currentItinerary property based on what type of recType the event property is
    */
    func switchItineraryOnBottomButtonAction(){
        if let rec_type = event?.subType {
            if(rec_type == kLodgingSubType){
                let itineraryIndex = TravelDataManager.SharedInstance.getAfterBookHotelItineraryIndex()
                TravelDataManager.SharedInstance.setItinerary(itineraryIndex)
            }
            else if(rec_type == kRestaurantSubType){
                let itineraryIndex = TravelDataManager.SharedInstance.getTransportationItineraryIndex()
                TravelDataManager.SharedInstance.setItinerary(itineraryIndex)
            }
            else if(rec_type == kTransitSubType){
                let itineraryIndex = TravelDataManager.SharedInstance.getAfterTransportationItinerayIndex()
                TravelDataManager.SharedInstance.setItinerary(itineraryIndex)
            }
        }
    }
    
}