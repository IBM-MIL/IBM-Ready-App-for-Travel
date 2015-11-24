/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer
(a) for its own instruction and study,
(b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for
redistribution by customer, as part of such an application, in customer's own products.
*/

import Foundation
import UIKit
import ReactiveCocoa


/**

**TravelDataManager**

Centralized manager that pulls all itinerary data


**Usage**

1. **func** fetchTravelData(callback: **() -> ()**), where callback uses ( see 2 )...

2. ... the **var** travelData: **TravelData**


**References**

1. http://www-01.ibm.com/support/knowledgecenter/SSHS8R_7.0.0/com.ibm.worklight.dev.doc/devref/c_adapters_endpoint.html

*/
public class TravelDataManager: NSObject {
    
    // MARK: Accessible Properties
    static let SharedInstance: TravelDataManager = {
        
        var manager = TravelDataManager()
        
        MILDelayedBlock.Execute(secondsDelay: 2) {
            
            manager.configureReactiveNotificationPost()
            
        }
        
        return manager
        
        }()
    
    // is-connected to MFP
    // --> accessed by DemoConsoleView to indicate connection success or failure
    var isConnectedToMFP = false
    
    /** contains all data */
    var travelData: MutableProperty<TravelData> {
        
        if _travelData.value.isValid == false {
            // already tried fetching from MFP. load from disk
            if _attemptedRefetchLoadFromDiskNow {
                restoreSavedStateFromLastSuccessfulConnection()
            } else {
                // didn't try another call to MFP yet. do so.
                fetchTravelData() {
                    Utils.printMQA(NSLocalizedString("Successfully connected to MFP, now have travelData", comment: ""))
                }
                _attemptedRefetchLoadFromDiskNow = true
            }
        }
        
        return _travelData
    }
    
    
    /**
    Method configures the reactive notification post
    */
    func configureReactiveNotificationPost() {
        
        self.travelData.producer.start() {
            
            if let dataIsValid = $0.value?.isValid where dataIsValid == true {

                self.post()
                
            } else {
 
            }
        }
    }
    
    
    /**
    Method posts a notification to the NSNotificationCenter under the name "TravelDataPost"
    */
    func post() {
        let notification = NSNotification(name: "TravelDataPost", object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    
    /**
    
    current itinerary -> number choices
    
    **readonly**, use setDay(Int)
    
    */
    var currentItinerary: MutableProperty<Int> {
        get { return _currentItinerary }
    }
    
    //Below are constant properties that define the various indexs for the different itineraries
    private let kBeginningItineraryIndex = 0
    private let kAfterBookHotelItineraryIndex = 1
    private let kWeatherItineraryIndex = 2
    private let kTransportationItineraryIndex = 3
    private let kAfterTransportationItinerayIndex = 4
    
    
    /**
    Method sets the current Itinerary with the newValue parameter
    
    - parameter newValue: Int
    */
    func setItinerary(newValue: Int) { _currentItinerary.value = newValue }
    
    
    /**
    Method returns the beginning itinerary index, which is defined by the kBeginningItineraryIndex property
    
    - returns: Int
    */
    func getBeginningItineraryIndex() -> Int {return kBeginningItineraryIndex}
    
    
    /**
    Method returns the after booking hotel itinerary index which is defined by the kAfterBookHotelItineraryIndex property
    
    - returns: Int
    */
    func getAfterBookHotelItineraryIndex() -> Int { return kAfterBookHotelItineraryIndex}
    
    
    /**
    Method returns the weather alert itinerary index which is defined by the kWeatherItineraryIndex property
    
    - returns: kWeatherItineraryIndex
    */
    func getWeatherItineraryIndex() -> Int {return kWeatherItineraryIndex}
    
    
    /**
    Method returns the transportation itinerary index which is defined by the kTransportationItineraryIndex
    
    - returns: Int
    */
    func getTransportationItineraryIndex() -> Int {return kTransportationItineraryIndex}
    
    
    /**
    Method returns the after transportation itinerary index which is defined by the kAfterTransportationItineraryIndex
    
    - returns: Int
    */
    func getAfterTransportationItinerayIndex() -> Int {return kAfterTransportationItinerayIndex}
    
    func getCurrentItineraryIndex() -> Int{
        return _currentItinerary.value
    }
    // MARK: Supporting Variables, No Direct Access
    
    //The TripsDetailViewModel observes this property for changes, so it knows when to swap out itineraries 
    private var _currentItinerary = MutableProperty<Int>(0)
    
    // callbacks
    private var _callback: (()->())? = { }
    
    // travel data
    private var _travelData: MutableProperty<TravelData> = MutableProperty<TravelData>(TravelData([:]))
    private var _attemptedRefetchLoadFromDiskNow = false
    
    
    /**
    Method returns the event and date objects that are associated with the weather alert
    
    - returns: (event : Event?, date: Date?)
    */
    func getEventAndDateForWeatherAlertEvent() -> (event : Event?, date: Date?){
        
        let dateIndex = 2
        let eventIndex = 1
        
        return getEventAndDateAtIndexs(kWeatherItineraryIndex, dateIndex: dateIndex, eventIndex: eventIndex)
        
    }
    
    
    /**
    Method returns the event and date that correspond with the itineraryIndex, dateIndex, and eventIndex parameters
    
    - parameter itineraryIndex: Int
    - parameter dateIndex:      Int
    - parameter eventIndex:     Int
    
    - returns: (event : Event?, date: Date?)
    */
    func getEventAndDateAtIndexs(itineraryIndex: Int, dateIndex : Int, eventIndex : Int) -> (event : Event?, date: Date?){
        
        let currentUserIndex = 0
        var event : Event? = nil
        var date : Date? = nil
        
        if let users = TravelDataManager.SharedInstance.travelData.value.users {
            
            if(users.count > 0){
                if let itineraries = users[currentUserIndex].itineraries {
                    if(itineraries.count > 0){
                        
                        let itinerary = itineraries[itineraryIndex]
                        
                        if let d = itinerary.dates {
                            date = d[dateIndex]
                            
                            if let e = date!.events {
                                event = e[eventIndex]
                            }
                        }
                    }
                }
            }
        }
        return (event, date)
    }
}


/// MARK: Constants
extension TravelDataManager {
    
    var defaultTimeout: NSTimeInterval { return NSTimeInterval(60.0) }
    
}



/// MARK: Connect to MFP
extension TravelDataManager {
    
    /**
    Method calls MFP adapter via URL
    
    - parameter callback: ()->())
    */
    func fetchTravelData(callback: ()->()) {

        guard isConnectedToMFP else {
            
            connectToMFP()
            _callback = { self.fetchTravelData(callback) }
            return
        }
        
        
        let adaptorURL = Utils.getDataAdapterURL()
        
        let request = WLResourceRequest(
            URL: NSURL(string: adaptorURL),
            method: WLHttpMethodGet
        )
        request.setQueryParameterValue("['en']", forName: "params")
        
        request.sendWithCompletionHandler {
            
            (WLResponse response, NSError error) -> Void in
            
            //connection success with error (can't find user)
            if error != nil {
              
                Utils.printMQA("Error in TravelDataManager: WLDelegate, onSuccess(...)")
                Utils.printMQA("Error: \(error)")
                
            } else {
                if let data = response.getResponseJson() as? [String: AnyObject] {
                    
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: "travelData")
                    
                    self._travelData.value = TravelData(data)
                    self.currentItinerary.value = 0
                    
                    callback()
                    
                }
            }
        }
    }
    
    
    /**
    Method connects to MFP
    */
    func connectToMFP() {
        WLClient.sharedInstance().wlConnectWithDelegate(self)
    }
    
}


/// MARK: WLDelegate Protocol Implementation
extension TravelDataManager: WLDelegate {
    
    /**
    
    Successful MFP connection if resource request is successful, or resource failure error message if unsuccessful
    
    :param: response WLResponse containing user data
    
    */
    public func onSuccess(response: WLResponse!) {
        
        // dismiss any banners
        MILBannerViewManager.SharedInstance.hide()
        
        self.isConnectedToMFP = true
        if let callback = _callback { callback() }
        
    }
    
    /**
    
    Method called upon failure to connect to MFP, will send errorMsg
    
    :param: response WLFailResponse containing failure response
    
    */
    public func onFailure(response: WLFailResponse!) {
        
        restoreSavedStateFromLastSuccessfulConnection()
        
    }
    
    /**
    the clever part here is that we saved our Swift dictionary on last successful pull.
    --> no need to implement NSCoding in our data model classes
    */
    private func restoreSavedStateFromLastSuccessfulConnection() {
        
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("travelData") as? [String: AnyObject] {
            Utils.printMQA(NSLocalizedString("Unable to  connect to MFP, falling back on travelData fetched previously from the last successful connection to MFP", comment: ""))
            _travelData.value = TravelData(data)
    
        } else {
            
            if let backupJSON = JSONOfflineBackupManager.StoredJSON {
                Utils.printMQA(NSLocalizedString("Unable to  connect to MFP. No json stored previously from last successful connection to MFP. Falling back on locally stored offline json using the JSONOfflineBackupManager", comment: ""))
                _travelData.value = TravelData(backupJSON)
                
            } else {
                
                displayBanner("Error pulling data.",
                    duration: 1.5,
                    success: false) { self.fetchTravelData(){ /* no callback */ } }
            }
        }
    }
    
    
    /**
    Method displays the MILBannerView
    
    - parameter text:     String
    - parameter duration: NSTimeInterval
    - parameter success:  Bool
    - parameter callback: (()->())
    */
    private func displayBanner(text: String, duration: NSTimeInterval, success: Bool, callback: (()->())) {
        
        MILDelayedBlock.Execute(millisecondsDelay: 50) {
            
            if !MILBannerViewManager.SharedInstance.isDisplayingBanner {
                
                MILBannerViewManager.SharedInstance.show(.Classic,
                    text: text,
                    textColor: success ? UIColor.travelBannerSuccessTextColor() : UIColor.travelBannerFailureTextColor(),
                    textFont: nil,
                    backgroundColor: success ? UIColor.travelBannerSuccessBackgroundColor() : UIColor.travelBannerFailureBackgroundColor(),
                    reloadImage: success ? UIImage() : nil,
                    inView: DemoConsoleManager.SharedInstance.viewToAddAlertsTo,
                    underView: nil,
                    toHeight: 0,
                    forSeconds: duration,
                    callback: callback
                )
            }
        }
    }
    
}
