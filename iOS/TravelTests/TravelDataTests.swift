/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/


import XCTest
import ReactiveCocoa

/**

# TravelDataTests

### Tests

* MFP-pulled data JSON

* **JSONOfflineBackupManager**-provided data JSON


### Testing Methodology

* Instantiation

* All itineraries present

* Data at random intervals


*/
class TravelDataTests: XCTestCase {
    
    var _manager: TravelDataManager { return TravelDataManager.SharedInstance }
    var _travelData: TravelData { return _travelDataObservable.value }
    var _travelDataObservable: MutableProperty<TravelData> { return TravelDataManager.SharedInstance.travelData }
    
    var _offlineTravelData: TravelData { return TravelData(JSONOfflineBackupManager.StoredJSON!) }
    
    // called before the invocation of each test method in the class
    override func setUp() {
        
        /** always needs an instance of **TravelData** */
        func ensureDataIsPresent() { XCTAssertNotNil(_travelData) }
        
        super.setUp()
        
        ensureDataIsPresent()
        
    }
    
    // called after the invocation of each test method in the class
    override func tearDown() { super.tearDown() }
    
    /// MARK: MFP-Pulled JSON
    func testConnectToMFP() {
        
        let expectation = expectationWithDescription("Connect to MFP and get data.")
        
        TravelDataManager.SharedInstance.fetchTravelData() {
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(20.0, handler: nil)
        
    }
    
    // instantiation
    func testMFPJSONInstantiation() {
        
        XCTAssertTrue(_manager.isConnectedToMFP, "Connection with MFP required prior to testing MFP JSON.")
        XCTAssertNotNil(TravelDataManager.SharedInstance.travelData, "Nil TravelData.")
        
    }
    
    // validity
    func testMFPJSONValidity() {
        
        XCTAssertTrue(_manager.isConnectedToMFP, "Connection with MFP required prior to testing MFP JSON.")
        XCTAssertTrue(_travelData.isValid, "Invalid MFP TravelData after connection.")
        
    }
    
    // JSON consistency
    func testMFPJSONConsistency() {
        
        XCTAssertTrue(_manager.isConnectedToMFP, "Connection with MFP required prior to testing MFP JSON.")
        verifyJSONConsistency(_travelData)
        
    }
    
    
    /// MARK: Offline JSON
    func testSettingUpOfflineJSON() {
        
        let StoredJSON = JSONOfflineBackupManager.StoredJSON
        XCTAssertNotNil(StoredJSON)
        
    }
    
    func testOfflineTravelDataPresent() {
        
        let StoredJSON = JSONOfflineBackupManager.StoredJSON
        XCTAssertNotNil(TravelData(StoredJSON!))
        
    }
    
    func testOfflineJSONTravelDataIsValid() {
        
        XCTAssertTrue(_offlineTravelData.isValid)
        
    }
    
    func testOfflineJSONConsistency() {
        
        verifyJSONConsistency(_offlineTravelData)
        
    }
    
    
    /**
    
    MARK: JSON Consistency Tests
    
    The extension below is reusable. Just pass in a JSON and it is thoroughly tested.
    
    Note: The calls are chained. It was quicker to implement this way versus unwrapping
    the JSON in the top method (which would've made for marginally cleaner-looking code.
    
    */
    
    func verifyJSONConsistency(travelData: TravelData) {
        
        verifyUsers(travelData)
        
    }
    
    func verifyUsers(travelData: TravelData) {
        
        XCTAssertNotNil(travelData.users)
        
        var userOnePresent = false
        
        for user in travelData.users! {
            
            if let name = user.name where name == "user1" {
                
                userOnePresent = true
                
            }
            
        }
        
        XCTAssertTrue(userOnePresent)
        
        verifyItinerariesForUserOne(travelData.users!.first!)
        
    }
    
    func verifyItinerariesForUserOne(user: User) {
        
        XCTAssertNotNil(user.itineraries, "Itineraries must not be nil.")
        
        let itineraries = user.itineraries!
        
        // 5 itineraries
        XCTAssertEqual(itineraries.count, 5)
        
        // for each, itinerary data structure
        for itinerary in itineraries {
            
            XCTAssertNotNil(itinerary._id)
            XCTAssertNotNil(itinerary.type)
            XCTAssertNotNil(itinerary._rev)
            XCTAssertNotNil(itinerary.title)
            XCTAssertNotNil(itinerary.version)
            XCTAssertNotNil(itinerary.itineraryStartDate)
            XCTAssertNotNil(itinerary.itineraryEndDate)
            
            XCTAssertNotNil(itinerary.initialLocation)
            let initialLocation = itinerary.initialLocation!
            verifyInitialLocation(initialLocation)
            
            XCTAssertNotNil(itinerary.dates)
            let dates = itinerary.dates!
            let version = itinerary.version!
            verifyDates(dates, itineraryVersion: version)
            
        }
        
    }
    
    func verifyInitialLocation(initialLocation: Location) {
        
        XCTAssertNotNil(initialLocation.city)
        XCTAssertNotNil(initialLocation.country)
        XCTAssertNotNil(initialLocation.lat)
        XCTAssertNotNil(initialLocation.lng)
        
    }
    
    func verifyDates(dates: [Date], itineraryVersion: Int) {
        
        XCTAssertNotEqual(dates.count, 0)
        
        for var i = 0; i < dates.count; i++ {
            
            verifyDate(dates[i], itineraryVersion: itineraryVersion, dateIndex: i)
            
        }
        
    }
    
    func verifyDate(date: Date, itineraryVersion: Int, dateIndex: Int) {
        
        XCTAssertNotNil(date.date)
        XCTAssertNotNil(date.temperatureLow)
        XCTAssertNotNil(date.temperatureHigh)
        XCTAssertNotNil(date.events)
        XCTAssertNotNil(date.condition)
        
        let events = date.events!
        XCTAssertNotEqual(events.count, 0)
        
        for var i = 0; i < events.count; i++ {
            
            verifyEvent(events[i], itineraryVersion: itineraryVersion, dateIndex: dateIndex, eventIndex: i)
            
        }
        
        // TODO: version-specific, date-index-specific tests
        func nothing(){}
        
        switch (itineraryVersion, dateIndex) {
            
        case (1, dateIndex):
            nothing()
            
            // TODO case ((2,3,4,5), dateIndex):
        default:
            nothing() // never reached
            
        }
        
    }
    
    func testThatNothing() {
        XCTAssertTrue(true, "True should be true")
    }
    
    func verifyEvent(event: Event, itineraryVersion: Int, dateIndex: Int, eventIndex: Int) {
        
        XCTAssertNotNil(event.subType)
        
        let subType = event.subType!
        
        func nothing(){}
        
        XCTAssertNotNil(event.itineraryId)
        
        XCTAssertNotNil(event.start_time)
        XCTAssertNotNil(event.end_time)
        
        XCTAssertNotNil(event.affectedByWeather)
        
        switch subType {
            
        case "meeting":
            XCTAssertNotNil(event.title)
            XCTAssertNotNil(event.geometry)
            XCTAssertNotNil(event.vicinity)
            XCTAssertNotNil(event.isOutdoor)
            XCTAssertNotNil(event.time)
            XCTAssertNotNil(event.imageUrl)
            
        case "restaurant":
            XCTAssertNotNil(event.isTrustedPartner)
            XCTAssertNotNil(event.title)
            XCTAssertNotNil(event.name)
            XCTAssertNotNil(event.geometry)
            XCTAssertNotNil(event.price_level)
            XCTAssertNotNil(event.rating)
            XCTAssertNotNil(event.cuisine)
            XCTAssertNotNil(event.distance)
            XCTAssertNotNil(event.location)
            XCTAssertNotNil(event.reviewHighlight)
            XCTAssertNotNil(event.reviewer)
            XCTAssertNotNil(event.reviewTime)
            XCTAssertNotNil(event.vicinity)
            XCTAssertNotNil(event.isOutdoor)
            XCTAssertNotNil(event.time)
            XCTAssertNotNil(event.imageUrl)
            
            if let affected = event.affectedByWeather {
                if(affected == true){
                    XCTAssertNotNil(event.recommendedReplacements)
                }
                else{
                    XCTAssertNil(event.recommendedReplacements)
                }
            }
            else{
                XCTAssertTrue(false)
            }
            
        case "flight":
            XCTAssertNotNil(event.boardingTime)
            XCTAssertNotNil(event.departureTime)
            XCTAssertNotNil(event.arrivalTime)
            XCTAssertNotNil(event.departureAirportCode)
            XCTAssertNotNil(event.arrivalLocation)
            XCTAssertNotNil(event.departureLocation)
            XCTAssertNotNil(event.arrivalAirportCode)
            XCTAssertNotNil(event.gate)
            XCTAssertNotNil(event.terminal)
            XCTAssertNotNil(event.itineraryId)
            
        case "lodging":
            XCTAssertNotNil(event.name)
            XCTAssertNotNil(event.title)
            XCTAssertNotNil(event.room)
            XCTAssertNotNil(event.geometry)
            XCTAssertNotNil(event.confirmation)
            XCTAssertNotNil(event.checkin)
            XCTAssertNotNil(event.checkout)
            XCTAssertNotNil(event.price)
            XCTAssertNotNil(event.isTrustedPartner)
            XCTAssertNotNil(event.hasPromotionalDiscount)
            XCTAssertNotNil(event.promotionalDiscount)
            XCTAssertNotNil(event.isLoyaltyMember)
            XCTAssertNotNil(event.loyaltyDiscount)
            XCTAssertNotNil(event.rationale)
            XCTAssertNotNil(event.description)
            //XCTAssertNotNil(event.displayType)
            
            XCTAssertNotNil(event.imageUrl)
            XCTAssertNotNil(event.rating)
            XCTAssertNotNil(event.location)
            XCTAssertNotNil(event.reviewHighlight)
            XCTAssertNotNil(event.reviewer)
            XCTAssertNotNil(event.reviewTime)
            XCTAssertNotNil(event.loyaltyProgramName)
            XCTAssertNotNil(event.loyaltyPoints)
            
        case "transit":
            XCTAssertNotNil(event.isTrustedPartner)
            XCTAssertNotNil(event.cost)
            XCTAssertNotNil(event.ios_transit_name)
            XCTAssertNotNil(event.transit_steps)
            XCTAssertNotNil(event.departureStreet)
            
        case "recommendations":
            XCTAssertNotNil(event.rec_type)
            XCTAssertNotNil(event.message)
            
            if let recType = event.rec_type {
                if(recType == "transit"){
                    XCTAssertNotNil(event.fromLocation)
                    XCTAssertNotNil(event.toLocation)
                }
                else if(recType == "lodging"){
                    XCTAssertNotNil(event.lodgingLocation)
                }
            }
            else{
                XCTAssertTrue(false)
            }
            
            XCTAssertNotNil(event.recommendationList)
            
            let recommendationList = event.recommendationList!
            
            for recommendation in recommendationList {
                
                verifyEvent(recommendation, itineraryVersion: itineraryVersion, dateIndex: dateIndex, eventIndex: eventIndex)
                
            }
            
            XCTAssertNotNil(event.alert)
            
            XCTAssertNotNil(event._id)
            XCTAssertNotNil(event.type)
            XCTAssertNotNil(event._rev)
         
        default:
            nothing()
            
        }
        
    }
    
}
