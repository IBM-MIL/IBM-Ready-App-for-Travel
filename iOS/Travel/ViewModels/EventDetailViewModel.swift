/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit
import MapKit

class EventDetailViewModel {
    
    //Property holds the current date that the event detail view controller is showing info about
    var date : Date?
    
    //Property holds the current event that the event detail view controller is showing info about
    var event : Event?
    
    //Property defines the number of sections in the transportation table view
    let kNumberOfSectionsInTransportationTableView = 1
    
    //Below are constant propertys for event subtypes
    let kLodgingSubType = "lodging"
    let kTransitSubType = "transit"
    let kMeetingSubType = "meeting"
    let kRestaurantSubType = "restaurant"
    

    /**
    Method that sets the instance's data and event properties upon init
    
    - parameter date:  Date
    - parameter event: Event
    
    - returns:
    */
    init(date : Date, event : Event){
        self.date = date
        self.event = event
    }
    
 
    /**
    Method that returns the navigation bar date string depending on what type of event subtype the event property is
    
    - returns: String
    */
    func getNavigationBarDateString() -> String{
        
        var dateString = ""
        let eventSubType = getEventSubType()
        
        if eventSubType != "" {
            if(eventSubType == kRestaurantSubType || eventSubType == kTransitSubType) {
                if let s_time = event?.start_time {
                    dateString = NSDate.convertMillisecondsSince1970ToDateStringWithDayAndMonth(s_time)
                }
            }
            else if(eventSubType == kLodgingSubType){
                if let check_in = event?.checkin {
                    if let check_out = event?.checkout {
                        let start = NSDate.convertMillisecondsSince1970ToDateStringWithDayAndMonth(check_in)
                        let end = NSDate.convertMillisecondsSince1970ToDateStringWithDayAndMonth(check_out)
                        dateString = "\(start) - \(end)"
                    }
                }
            }
        }
        return dateString
    }
    
    
    /**
    Method return the event subtype of the event property
    
    - returns: String
    */
    func getEventSubType() -> String{
        
        if let subtype = event?.subType{
            return subtype
        }
        else {
            return ""
        }
        
    }
    
    
    /**
    Method setups up the meeting detail view parameter with the event property data
    
    - parameter meetingDetailView: MettingDetailView
    */
    func setupMeetingDetailViewWithData(meetingDetailView : MeetingDetailView){
        
        meetingDetailView.setupData(event?.title,
            start_time: event?.start_time,
            end_time: event?.end_time,
            rating: event?.rating,
            price_level: event?.price_level,
            temperatureHigh : date?.temperatureHigh,
            temperatureLow : date?.temperatureLow,
            weatherCondition : date?.condition,
            locationName: event?.name,
            locationAddress : event?.location
        )
    }
    
    
    /**
    Method setups the the hotel detail view paremter with the event property data
    
    - parameter hotelDetailView: HotelDetailView
    */
    func setupHotelDetailViewWithData(hotelDetailView : HotelDetailView){

        hotelDetailView.setupData(event?.name,
            checkIn: event?.checkin,
            checkOut: event?.checkout,
            confirmationCode : event?.confirmation,
            rating: event?.rating,
            price_level: nil,
            temperatureHigh: date?.temperatureHigh,
            temperatureLow: date?.temperatureLow,
            weatherCondition: date?.condition,
            locationName: nil,
            locationAddress: event?.location,
            loyaltyProgramName: event?.loyaltyProgramName,
            loyaltyPoints: event?.loyaltyPoints
        )
        
    }
    
    
    /**
    Method returns whether the event property is affect by weather or not
    
    - returns: Bool
    */
    func isEventAffectedByBadWeather()-> Bool{
        if let affected = event?.affectedByWeather{
            return affected
        }
        else {
            return false
        }
        
    }
    
    
    /**
    Method returns a CLLocationCoordinate2D based on the event properties lat and long
    
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
    Method returns a RecommendationsViewModel from data from the event property's recommendedReplacements property
    
    - returns: RecommendationsViewModel
    */
    func getInclimentWeatherRecommendations() -> RecommendationsViewModel{
        let recommendationsViewModel = RecommendationsViewModel(event: event!.recommendedReplacements!, eventToBeReplaced: event)
        
        return recommendationsViewModel
    }
}


//Transportation Related Methods

extension EventDetailViewModel {
    

    /**
    Method sets up the recommended transportation detail view with the event property's data
    
    - parameter recommendedTransportationDetailView: RecommendedTransportationDetailView
    */
    func setUpRecommendedTransportationDetailView(recommendedTransportationDetailView : RecommendedTransportationDetailView){
        recommendedTransportationDetailView.setUpData(event?.start_time,
            end_time: event?.end_time,
            ios_transit_name: event?.ios_transit_name
        )
        
    }
    
    
    /**
    Method returns the number of rows in the section parameter
    
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
    Method returns the number of sections
    
    - returns: Int
    */
    func numberOfSectionsInTableView() -> Int {
        return kNumberOfSectionsInTransportationTableView
    }
    
    
    
    /**
    Method returns the transit step of the event property's transit_steps property at the indexPath parameter
    
    - parameter indexPath: NSIndexPath
    
    - returns: TransitStep
    */
    func getTransitStepAtIndexPath(indexPath : NSIndexPath) -> TransitStep{
        return event!.transit_steps![indexPath.row]
    }
    
    
    
    /**
    Method setups up the tableViewCell at the indexPath parameter using the transitStep at indexPath data
    
    - parameter indexPath: NSIndexPath
    - parameter tableView: UITableView
    
    - returns: UITableViewCell
    */
    func setUpTableViewCell(indexPath : NSIndexPath, tableView: UITableView) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("transportationDetail", forIndexPath: indexPath) as! RecommendedTransportationDetailTableViewCell
        
        let transitStep = getTransitStepAtIndexPath(indexPath)
        
        cell.setUpData(transitStep.start_time,
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
    
 
}