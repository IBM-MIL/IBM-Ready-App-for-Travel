/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

class RecommendationsViewModel {
    
    //Property holds the current recommendation event the recommendation detail view controller holds
    var event : Event?
    
    //Property holds the current event that will be replaced by a recommended event
    var eventToBeReplaced : Event?
    
    //The recommend detail VC sets this when the user selects a cell in the table view
    var selectedRecommendationIndexPath : NSIndexPath!
    
    //Constant property for lodging subtype and its respective navigation bar title
    let kLodgingRecType = "lodging"
    let kLodgingNavigationBarTitle = NSLocalizedString("Hotels", comment: "")
    
    //Constant property for restaurant subtype and its respective navigation bar title
    let kRestaurantRecType = "restaurant"
    let kRestaurantNavigationBarTitle = NSLocalizedString("Restaurants", comment: "")
    
    //Constant property for the transportation subtype and its respective navigation bar title
    let kTransportationRecType = "transit"
    let kTransportationNavigationBarTitle = NSLocalizedString("Transportation", comment: "")
    
    //Constant property for the number of section the table view
    let kNumberOfSectionsInTableView = 1
    
    
    /**
    Method that sets the event and eventToBeReplaced properties upon init
    
    - parameter event:             Event
    - parameter eventToBeReplaced: Event
    
    - returns:
    */
    init(event : Event, eventToBeReplaced : Event?){
        self.event = event
        self.eventToBeReplaced = eventToBeReplaced
    }
    
    
    /**
    Method that returns the navigation bar title based on the type of recommendation type the event property is
    
    - returns: String
    */
    func getNavigationBarTitle() -> String {
        var navigationBarTitleString = ""
        
        let recType = getRecommendationsType()
        
        if let r_Type = recType {
            if(r_Type == kLodgingRecType) {
                navigationBarTitleString = kLodgingNavigationBarTitle
            }
            else if(r_Type == kRestaurantRecType){
                navigationBarTitleString = kRestaurantNavigationBarTitle
            }
            else if(r_Type == kTransportationRecType){
                navigationBarTitleString = kTransportationNavigationBarTitle
            }
        }
        
        return navigationBarTitleString
    }
    
    
    /**
    Method that returns the recommendation type of the event property
    
    - returns: String?
    */
    func getRecommendationsType() -> String? {
        return event?.rec_type
    }
    
    
    /**
    Method that sets up a HorizontalOnePartStackView with the eventToBeReplaced property's data
    
    - parameter onePartStackView: HorizontalOnePartStackView
    */
    func setupOnePartStackView(onePartStackView : HorizontalOnePartStackView){
        var cityCountry = ""
        
        if let geo = eventToBeReplaced?.geometry, let city = geo.city, let country = geo.country{
            cityCountry = "\(city), \(country)"
        }
        
        onePartStackView.setUpData(eventToBeReplaced?.name, replacementRestaurantCityCountry: cityCountry)
    }
    
    
    
    /**
    Method that sets up a HorizontalTwoPartStackView with the event property's data
    
    - parameter recType:          String
    - parameter twoPartStackView: HorizontalTwoPartStackView
    */
    func setupTwoPartStackView(recType : String, twoPartStackView : HorizontalTwoPartStackView){
        
        var startTime: Double?
        var endTime: Double?
    
        if let recList = event?.recommendationList{
            let firstRec = recList[0]
            
            startTime = firstRec.start_time!
            endTime = firstRec.end_time
        }
        
        twoPartStackView.setUpData(recType, lodgingLocation: event?.lodgingLocation, fromLocation: event?.fromLocation, toLocation: event?.toLocation, start_time: startTime, end_time: endTime)
        
    }
    
    
    
    /**
    Method that returns the number of rows in the section defined by the section parameter. This is based on the event property's recommendationList count
    
    - parameter section: Int
    
    - returns: Int
    */
    func numberOfRowsInSection(section : Int) -> Int {
        if let recList = event?.recommendationList {
            return recList.count
        }
        else{
            return 0
        }
    }
    
    
    /**
    Method that returns the number of sections in the table view, which is a constant of 1
    
    - returns: Int
    */
    func numberOfSectionsInTableView() -> Int {
        return kNumberOfSectionsInTableView
    }
    
    
    /**
    Method that returns the Event (Recommendation) at indexPath
    
    - parameter indexPath: NSIndexPath
    
    - returns: Event
    */
    func getRecommendationAtIndexPath(indexPath : NSIndexPath) -> Event {
        
       return event!.recommendationList![indexPath.row]
        
    }
    
    /**
    Method that sets the selectedRecommendationIndexPath property to the indexPath parameter
    
    - parameter indexPath: NSIndexPath
    */
    func selectedRecommendationIndexPath(indexPath : NSIndexPath){
        selectedRecommendationIndexPath = indexPath
    }
    
    
    
    /**
    Method that sets up the tableViewCell at the indexPath parameter depending on the type of recommendation type the recommendation is at indexPath
    
    - parameter indexPath: NSIndexPath
    - parameter tableView: UITableView
    
    - returns: UITableViewCell
    */
    func setUpTableViewCell(indexPath : NSIndexPath, tableView: UITableView) -> UITableViewCell{
        
        var cell : UITableViewCell = UITableViewCell()
        let recommendationsType = getRecommendationsType()
        
        let recommendation = getRecommendationAtIndexPath(indexPath)
        
        if let recType = recommendationsType {
            
            if(recType == kLodgingRecType){
                cell = setupLodgingRecommendationTableViewCell(indexPath, tableView: tableView, recommendation: recommendation)
            }
            else if(recType == kRestaurantRecType){
                cell = setupRestaurantRecommendationTableViewCell(indexPath, tableView: tableView, recommendation: recommendation)
            }
            else if(recType == kTransportationRecType){
               cell = setupTransportationRecommendationTableViewCell(indexPath, tableView: tableView, recommendation: recommendation)
            }
        }else{
            
        }
        
        return cell
    }
    
    
    
    /**
    Method sets up the tableViewCell at indexPath parameter as a RecommendedHotelTableViewCell
    
    - parameter indexPath:      NSIndexPath
    - parameter tableView:      UITableView
    - parameter recommendation: Event
    
    - returns: UITableViewCell
    */
    private func setupLodgingRecommendationTableViewCell(indexPath : NSIndexPath, tableView : UITableView, recommendation : Event) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("hotel", forIndexPath: indexPath) as! RecommendedHotelTableViewCell
        
        var previousPrice : Double?
        var discountPrice: Double?
        if let isLoyaltyMember = recommendation.isLoyaltyMember {
            if (isLoyaltyMember == true){
                previousPrice = recommendation.loyaltyDiscount?.previousPrice
                discountPrice = recommendation.loyaltyDiscount?.discountedPrice
            }
        }
        
        if let hasPromoDiscount = recommendation.hasPromotionalDiscount {
            if (hasPromoDiscount == true){
                previousPrice = recommendation.promotionalDiscount?.previousPrice
                discountPrice = recommendation.promotionalDiscount?.discountedPrice
            }
        }
        
        if let isLoyaltyMember = recommendation.isLoyaltyMember, let hasPromoDiscount = recommendation.hasPromotionalDiscount {
            if(isLoyaltyMember == false && hasPromoDiscount == false){
                discountPrice = recommendation.price
            }
        }
        
        cell.setUpData(
            recommendation.title,
            numberOfStars : recommendation.rating,
            rationale: recommendation.rationale,
            isTrustedPartner: recommendation.isTrustedPartner,
            discountPrice: discountPrice,
            previousPrice: previousPrice,
            imageURLString: recommendation.imageUrl
        )
        
        return cell
    }
    
    
    /**
    Method sets up the tableViewCell at indexPath as a RecommendedRestaurantTableViewCell
    
    - parameter indexPath:      NSIndexPath
    - parameter tableView:      UITableView
    - parameter recommendation: Event
    
    - returns: UITableViewCell
    */
    private func setupRestaurantRecommendationTableViewCell(indexPath : NSIndexPath, tableView : UITableView, recommendation : Event) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("restaurant", forIndexPath: indexPath) as! RecommendedRestaurantTableViewCell
        
        cell.setUpData(
            recommendation.name,
            typeOfRestaurant: recommendation.cuisine,
            distance: recommendation.distance,
            rating: recommendation.rating,
            expensiveness: recommendation.price_level,
            imageURL: recommendation.imageUrl,
            isPreferred : recommendation.isTrustedPartner
        )
        
        return cell
    }
    
    
    
    /**
    Method sets up the tableViewCell at indexPath as a RecommendedTransportationTableViewCell or a RecommendedBlaBlaCarTableViewCell
    
    - parameter indexPath:      NSIndexPath
    - parameter tableView:      UITableView
    - parameter recommendation: Event
    
    - returns: UITableViewCell
    */
    private func setupTransportationRecommendationTableViewCell(indexPath : NSIndexPath, tableView : UITableView, recommendation : Event) -> UITableViewCell {
        
        var cell : UITableViewCell = UITableViewCell()
        
        if let transitName = recommendation.ios_transit_name {
            
            var departureArea = ""
            if let transitSteps = recommendation.transit_steps {
                let stepOne = transitSteps[0]
                departureArea = stepOne.departureArea ?? ""
            }
            
            if(transitName != "blablacar"){
                
                cell = tableView.dequeueReusableCellWithIdentifier("transportation", forIndexPath: indexPath) as! RecommendedTransportationTableViewCell
                
                (cell as! RecommendedTransportationTableViewCell).setUpData(departureArea, start_time: recommendation.start_time, end_time: recommendation.end_time, cost: recommendation.cost, isPreferred: recommendation.isTrustedPartner, ios_transit_name: recommendation.ios_transit_name)
            }
            else{
                cell = tableView.dequeueReusableCellWithIdentifier("blablacar", forIndexPath: indexPath) as! RecommendedBlaBlaCarTableViewCell
                
                (cell as! RecommendedBlaBlaCarTableViewCell).setUpData(departureArea, start_time: recommendation.start_time, end_time: recommendation.end_time, cost: recommendation.cost, numberOfSeatsLeft: 3)
            }
            
        }

        return cell
    }


    
    /**
    Method that retusn an instance of RecommendationDetailView Model that is set up depending on which recommendation was selected defined by the selectedRecommendationIndexPath property
    
    - returns: RecommendationDetailViewModel
    */
    func getRecommendationDetailViewModel() -> RecommendationDetailViewModel{
        
        let e = getRecommendationAtIndexPath(selectedRecommendationIndexPath)
        
        let recommendationDetailViewModel = RecommendationDetailViewModel(event: e)
        
        return recommendationDetailViewModel
        
    }
    
    
    
}
