/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import Foundation

class Itinerary {
    
    var id: String?
    var title: String?
    var version: Int?
    
    var itineraryStartDate: Double?
    var itineraryEndDate: Double?
    
    var initialLocation: Location?
    
    var dates: [Date]?
    
    var _id: String?
    var type: String?
    var _rev: String?

    
    init(_ data: Dict) {
        
        self.id = data["id"] as? String
        self.title = data["title"] as? String
        self.version = data["version"] as? Int
        
        self.itineraryStartDate = data["itineraryStartDate"] as? Double
        self.itineraryEndDate = data["itineraryEndDate"] as? Double

        if let initialLocation = data["initialLocation"] as? Dict {
            self.initialLocation = Location(initialLocation)
        }
        
        if let dates = data["dates"] as? [Dict] {
            
            self.dates = []
            
            for date in dates {
                
                self.dates?.append(Date(date))
                
            }
            
        }
        
        self._id = data["_id"] as? String
        self.type = data["type"] as? String
        self._rev = data["_rev"] as? String
        
    }
    
}
