/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import Foundation
import ReactiveCocoa

class DemoConsoleViewModel {
    
    weak var travelDataManager: TravelDataManager! = TravelDataManager.SharedInstance
    weak var currParameters = TravelDataManager.SharedInstance.currentItinerary

    var travelData: MutableProperty<TravelData> { return TravelDataManager.SharedInstance.travelData }
    
    var isConnectedToMFP: Bool { return TravelDataManager.SharedInstance.isConnectedToMFP }
    
    // commit holders
    private var _currentItineraryUncommittedValue: Int!
    
}


/// MARK: Current
extension DemoConsoleViewModel {

    
    /**
    Methods that returns the current itinerary observable
    
    - returns: MutableProperty<Int>
    */
    func currentItineraryObservable() -> MutableProperty<Int> {
        return TravelDataManager.SharedInstance.currentItinerary
    }
    
    
    /**
    Method returns the current itinerary
    
    - returns: Int
    */
    func currentItinerary() -> Int {
        return currentItineraryObservable().value
    }
    
}


/// MARK: Uncommitted State
extension DemoConsoleViewModel {
    
    /**
    Method is called every time slider updates
    
    - parameter itinerary: Int
    */
    func setUncommittedItinerary(itinerary: Int) { _currentItineraryUncommittedValue = itinerary }
    
    /**
    Method tosses uncommitted state
    */
    func tossUncommittedState() { _currentItineraryUncommittedValue = nil }
    
}


/// MARK: Committing State
extension DemoConsoleViewModel {
    
    // only when "confirm" is pressed
    func commitCurrentDay() {
        if _currentItineraryUncommittedValue != nil {
            TravelDataManager.SharedInstance.setItinerary(_currentItineraryUncommittedValue)
        }
    }
    
}
