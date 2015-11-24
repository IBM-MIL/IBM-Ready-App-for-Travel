/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import Foundation

class Date {
    
    var date: Double?
    
    var temperatureHigh: Double?
    var temperatureLow: Double?
    
    var events: [Event]?
    
    var condition: String?
    
    
    init(_ data: Dict) {
        
        if let value = data["date"] as? Double { self.date = value }
        
        self.temperatureHigh = (data["temperatureHigh"] as? String)?.toDouble()
        self.temperatureLow = (data["temperatureLow"] as? String)?.toDouble()
        
        if let events = data["events"] as? [Dict] {
            
            self.events = []
            
            for event in events {
                
                self.events?.append(Event(event))
                
            }
            
        }
        
        self.condition = data["condition"] as? String
        
    }
    
}
