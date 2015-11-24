/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit
import ReactiveCocoa

class TripDetailViewModel: NSObject {
    
    //Make TripDetailViewModel a Singleton
    static let sharedInstance: TripDetailViewModel = {
        let instance = TripDetailViewModel()
        return instance
        }()

    //Property changes when the TraveDataManager's currentItinerary property changes. The tripDetailViewController listens to this property for any changes to know when to update it's collection view with new itinerary data
    var dateDataArray = MutableProperty<[Date]>([Date]())
    
    //Property that the tripDetailViewController sets when the user selects a cell in the collection view
    var selectedEventIndexPath : NSIndexPath!
    
    //Property of bool value representing whether a weather alert is queued up or not to prevent overlapping weather alerts to be triggered
    var weatherAlertQueuedUp = false
    
    //Used to determine what kind of EventDetailViewModel to create depending on if the isWeatherAlertSegue property is true or not - used in the getEventDetailViewModel method
    var isWeatherAlertSegue = false
    
    
    /**
    Method calls the setupObservers method upon init
    
    - returns:
    */
    override init() {
        super.init()
        setupObservers()
    }
    
    
    /**
    Method sets the viewModel to start observing when the TravelDataManager's travelData property changes. When this method changes, we grab current itinerary from the travelData and setup up the viewModel's dataDataArray
    */
    func setupObservers(){
        
        TravelDataManager.SharedInstance.currentItinerary.producer
            .start({
                
                let currentItineraryIndex : Int = $0.value!
                let currentUserIndex = 0
                
                if(currentItineraryIndex != -1){
                    
                    if let users = TravelDataManager.SharedInstance.travelData.value.users {
                        
                        if(users.count > 0){
                            if let itineraries = users[currentUserIndex].itineraries {
                                if(itineraries.count > 0){
                                    self.setUpDateDataArray(itineraries[currentItineraryIndex])
                                }
                            }
                        }
                    }
                    
                }
                
            })
    }
    
    
    
    /**
    Method is called when the travelData property of the TravelDataManger singleton changes. In this method we setup the viewModel's dataDataArray
    
    - parameter itinerary:
    */
    func setUpDateDataArray(itinerary : Itinerary){
        dateDataArray.value = []
        
        if let dates = itinerary.dates {
            for date in dates {
                dateDataArray.value.append(date)
            }
        }
    }
    
    
    /**
    Method queues up a weather alert if the current itinerary index is the weather alert itinerary index
    */
    func tryToQueueWeatherAlert() {
        let itineraryIndex = TravelDataManager.SharedInstance.getCurrentItineraryIndex()
    
        if(itineraryIndex == TravelDataManager.SharedInstance.getWeatherItineraryIndex()){
            weatherAlertQueuedUp = true
        }
        else{
            weatherAlertQueuedUp = false
        }
    }

    
    /**
    Method returns a bool value whether a weather alert is queued up or not. It also sets the weatherAlertQueuedUp property to false.
    
    - returns: Bool
    */
    func isWeatherAlertQueuedUp() -> Bool {
        let queuedUp = weatherAlertQueuedUp
        weatherAlertQueuedUp = false
        
        return queuedUp
    }
    
    /**
    Method returns a bool whether the cell at indexPath is affected by weather
    
    - parameter indexPath:
    
    - returns: Bool?
    */
    func isAffectedByWeather(indexPath : NSIndexPath) -> Bool? {
        let event = dateDataArray.value[indexPath.section].events![indexPath.row]
        return event.affectedByWeather
    }
    
    
    
    /**
    Method returns the indexPath of the cell just added. It determines this by calling the getAddedCellIndexPath method
    
    - returns: NSIndexPath?
    */
    func indexPathToScrollTo() -> NSIndexPath? {
        return getAddedCellIndexPath()
    }
    
    
    /**
    Method returns the the recently added cell indexPath by determinin what itinerary index the TravelDataManager is currently at.
    
    - returns: NSindexPath?
    */
    func getAddedCellIndexPath() -> NSIndexPath? {
        let itineraryIndex = TravelDataManager.SharedInstance.getCurrentItineraryIndex()
        
        if(itineraryIndex == TravelDataManager.SharedInstance.getAfterBookHotelItineraryIndex()){
            return NSIndexPath(forItem: 1, inSection: 0)
            
        }else if(itineraryIndex == TravelDataManager.SharedInstance.getTransportationItineraryIndex()){
            return NSIndexPath(forItem: 2, inSection: 2)
        }
        else if(itineraryIndex == TravelDataManager.SharedInstance.getAfterTransportationItinerayIndex()){
            return NSIndexPath(forItem: 1, inSection: 2)
        }
        else{
            return nil
        }
   
    }
    
    
    /**
    Method returns the text that should be displayed in the added event alert. It determines this by looking at the current itinerary index
    
    - returns: String
    */
    func getAddedEventAlertText() -> String{
        let itineraryIndex = TravelDataManager.SharedInstance.getCurrentItineraryIndex()
        
        if(itineraryIndex == TravelDataManager.SharedInstance.getAfterBookHotelItineraryIndex()){
            return NSLocalizedString("You have successfully booked a hotel and it has been added to your itinerary.", comment: "")
            
        }else if(itineraryIndex == TravelDataManager.SharedInstance.getTransportationItineraryIndex()){
            return  NSLocalizedString("You have successfully updated the meeting location for this event. We’ll notify your invitees.", comment: "")
        }
        else if(itineraryIndex == TravelDataManager.SharedInstance.getAfterTransportationItinerayIndex()){
            return NSLocalizedString("Congratulations! This event has been added to your itinerary.", comment: "")
        }
        else{
            return ""
        }
    }
    
    
    
    /**
    Method returns the current itinerary index of the TravelDataManager
    
    - returns: Int
    */
    func getCurrentItineraryIndex() -> Int {
         return TravelDataManager.SharedInstance.currentItinerary.value
    }
    
    
    /**
    Method returns the number of items in the section define by the section parameter.
    
    - parameter section: Int
    
    - returns: Int
    */
    func numberOfItemsInSection(section : Int) -> Int {
        if let events = dateDataArray.value[section].events {
            return events.count
        }
        else{
            return 0
        }
    }
    
    
    /**
    Method returns the number of sections in the collection view
    
    - returns:
    */
    func numberOfSectionsInCollectionView() -> Int {
        return dateDataArray.value.count
    }
    
    
    
    /**
    Method returns the type of cell at the indexPath parameter
    
    - parameter indexPath: NSindexPath
    
    - returns: String
    */
    func getTypeOfCellForIndexPath(indexPath : NSIndexPath) -> String {
        
        let event = dateDataArray.value[indexPath.section].events![indexPath.row]
        
        return event.subType!
    }
    
    
    
    /**
    Method returns the hotel display type at the indexPath parameter
    
    - parameter indexPath: NSIndexPath
    
    - returns: String
    */
    func getHotelDisplayType(indexPath : NSIndexPath) -> String? {
        
        let event = dateDataArray.value[indexPath.section].events![indexPath.row]
        
        return event.displayType
    }
    
    
    
    
    /**
    Method sets up the collection view cell at the indexPath parameter depending on what type of event subtype corresponds with that indexPath
    
    - parameter indexPath:      NSIndexPath
    - parameter collectionView: UICollectionView
    
    - returns: UICollectionViewCell
    */
    func setUpCollectionViewCell(indexPath : NSIndexPath, collectionView : UICollectionView) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell
        
        let event = dateDataArray.value[indexPath.section].events![indexPath.row]
        
        if(event.subType == "meeting" || event.subType == "restaurant") {
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("MeetingCollectionViewCell", forIndexPath: indexPath) as! MeetingCollectionViewCell
            
            (cell as! MeetingCollectionViewCell).setUpData(
                event.start_time,
                end_time: event.end_time,
                title: event.title,
                location: event.vicinity,
                numberOfStars: event.numberOfStars,
                expensiveLevel: event.price_level,
                subtype: event.subType,
                outdoor: event.isOutdoor,
                isAffectedByWeather: event.affectedByWeather
            )
            
        } else if(event.subType == "flight") {
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("FlightCollectionViewCell", forIndexPath: indexPath) as! FlightCollectionViewCell
            
            (cell as! FlightCollectionViewCell).setUpData(
                event.start_time,
                end_time: event.end_time,
                departureAirportCode: event.departureAirportCode,
                departingCityLocation: event.departureLocation?.city,
                arrivalAirportCode: event.arrivalAirportCode,
                arrivingCityLocation: event.arrivalLocation?.city,
                gate: event.gate,
                terminal: event.terminal,
                boardingTime: event.boardingTime
            )
            
        } else if(event.subType == "lodging") {
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("HotelCollectionViewCell", forIndexPath: indexPath) as! HotelCollectionViewCell
            
            (cell as! HotelCollectionViewCell).setUpData(
                event.start_time,
                end_time: event.end_time,
                accommodation: event.title,
                confirmation: event.confirmation,
                roomNumber: event.room,
                typeOfCheck: "checkout",
                checkIn: event.checkin,
                checkOut: event.checkout,
                displayType: event.displayType
            )
        } else if(event.subType == "transit") {
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("MixedTransitCollectionViewCell", forIndexPath: indexPath) as! MixedTransitCollectionViewCell
            
            (cell as! MixedTransitCollectionViewCell).setUpData(
                event.start_time,
                end_time: event.end_time,
                departingLocation: event.departureStreet,
                type: event.ios_transit_name
            )
            
        } else if(event.subType == "recommendations") {
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecommendationCollectionViewCell", forIndexPath: indexPath) as! RecommendationCollectionViewCell
            
            (cell as! RecommendationCollectionViewCell).setUpData(event.message)
            
        } else {
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecommendationCollectionViewCell", forIndexPath: indexPath) as! RecommendationCollectionViewCell
            
        }
        
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        
        return cell
        
    }
    
    /**
    Method sets up the section header for the indexPath parameter
    
    - parameter indexPath:      NSIndexPath
    - parameter kind:           String
    - parameter collectionView: UICollectionView
    
    - returns: TripDetailSupplementaryView
    */
    func setUpSectionHeaderViewForIndexPath(indexPath : NSIndexPath, kind: String, collectionView : UICollectionView) -> TripDetailSupplementaryView {
        
        let header : TripDetailSupplementaryView
        
        header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "TripDetailSupplementaryView", forIndexPath: indexPath) as! TripDetailSupplementaryView
        
        let date = dateDataArray.value[indexPath.section]
        
        if let dateValue = date.date {
            
            header.setUp(indexPath, date: dateValue, highTemperature: date.temperatureHigh, lowTemperature: date.temperatureLow, condition: date.condition)
            
        }

        return header
    }
    
    
    /**
    Method is called by the TripDetailViewController's didSelectItemAtIndexPath when a cell is selected
    
    - parameter indexPath: NSIndexPath
    */
    func setTheSelectedEventIndexPath(indexPath : NSIndexPath){
        selectedEventIndexPath = indexPath
    }
    
    
    /**
    Method setups and returns a RecommendationsViewModel depending on the selectedEventIndexPath property value. This method is called within the TripDetailViewController's prepareForSegue method to prepare the segue's destination viewModel with the RecommendationsViewModel created here
    
    - returns: RecommendationsViewModel
    */
    func getRecommendationsViewModel() -> RecommendationsViewModel{
        
        
        let event = dateDataArray.value[selectedEventIndexPath.section].events![selectedEventIndexPath.row]
        
        let recommendationViewModel = RecommendationsViewModel(event: event, eventToBeReplaced: nil)
        
        return recommendationViewModel
        
    }
    
    
    
    /**
    Method setups and returns a certain kind of EventDetailViewModel. depending on if the isWeatherAlertSegue property is true or not.
    
    - returns: EventDetailViewModel
    */
    func getEventDetailViewModel() -> EventDetailViewModel {
        
        if(isWeatherAlertSegue == true){
            isWeatherAlertSegue = false
            let tuple = TravelDataManager.SharedInstance.getEventAndDateForWeatherAlertEvent()
            
            let date = tuple.date
            let event = tuple.event
            
            let eventDetailViewModel = EventDetailViewModel(date: date!, event: event!)
            
            return eventDetailViewModel
            
        }
        else{
   
            let date = dateDataArray.value[selectedEventIndexPath.section]
        
            let event = dateDataArray.value[selectedEventIndexPath.section].events![selectedEventIndexPath.row]
        
            let eventDetailViewModel = EventDetailViewModel(date: date, event: event)
        
            return eventDetailViewModel
        }
        
    }
  
}