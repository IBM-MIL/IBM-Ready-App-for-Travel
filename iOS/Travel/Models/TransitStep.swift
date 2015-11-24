/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import Foundation

/**

**TransitStep**

1. Walk

2. Rail

*/
class TransitStep {
    
    /** Both */
    var type: String?
    var start_time: Double?
    var end_time: Double?
    var departureArea: String?
    var arrivalArea: String?
    var details: String?
    var walkTime: String?
    var transitLine: String?
    var title: String?
    
    /** Rail */
    var stops: Double?
    
    
    init(_ data: Dict) {
        
        self.type = data["type"] as? String
        
        if let value = (data["start_time"] as? Double) { self.start_time = value }
        if let value = (data["end_time"] as? Double) { self.end_time = value }
        
        
        self.departureArea = data["departureArea"] as? String
        self.arrivalArea = data["arrivalArea"] as? String
        self.details = data["details"] as? String
        self.walkTime = data["walkTime"] as? String
        self.transitLine = data["transitLine"] as? String
        self.title = data["title"] as? String
        
        if let value = (data["stops"] as? Double) { self.stops = value }
        
    }
    
}
