/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import Foundation

/**

**Event**

1. Meeting

2. Restaurant

3. Flight

4. Lodging

5. Transit

*/
class Event {
    
    var itineraryId: String?
    var subType: String?
    
    var start_time: Double?
    var end_time: Double?
    
    /**
    1. Meeting
    2. Restaurant
    */
    var title: String?
    
    /**
    1. Meeting
    2. Restaurant
    4. Lodging
    */
    var geometry: Geometry?
    
    /**
    1. Meeting
    2. Restaurant
    4. Lodging
    */
    var vicinity: String?
    
    /**
    1. Meeting
    2. Restaurant
    */
    var isOutdoor: Bool?
    
    /**
    1. Meeting
    2. Restaurant
    */
    var time: Double?
    
    /**
    1. Meeting
    4. Lodging
    */
    var displayType: String?
    
    /**
    1. Meeting
    2. Restaurant
    3. Hotel
    4. Lodging
    */
    var imageUrl: String?
    var numberOfStars: Double?
    
    /**
    2. Restaurant
    */
    var price_level: Double?
    var cuisine: String?
    var distance: String?
    var recommendedReplacements: Event?
    
    /**
    2. Restaurant
    4. Lodging
    */
    var name: String?
    var rating: Double?
    var location: String?
    var reviewHighlight: String?
    var reviewer: String?
    var reviewTime: String?
    
    /**
    3. Flight
    */
    var boardingTime: Double?
    var departureTime: Double?
    var arrivalTime: Double?
    var departureAirportCode: String?
    var arrivalLocation: Location?
    var departureLocation: Location?
    var arrivalAirportCode: String?
    var gate: String?
    var terminal: String?
    
    /**
    4. Lodging
    */
    var room: String?
    var confirmation: String?
    var checkin: Double?
    var checkout: Double?
    var price: Double?
    var isTrustedPartner: Bool?
    var hasPromotionalDiscount: Bool?
    var promotionalDiscount: Discount?
    var isLoyaltyMember: Bool?
    var loyaltyDiscount: Discount?
    var rationale: String?
    var description: String?
    var loyaltyProgramName: String?
    var loyaltyPoints: Double?
    
    /**
    5. Transit
    */
    var cost: String?
    var ios_transit_name: String?
    var transit_steps: [TransitStep]?
    var departureStreet: String?
    
    /**
    6. Recommendation
    */
    var rec_type: String?
    var message: String?
    var recommendationList: [Event]?
    var alert: Bool?
    var fromLocation: String?
    var toLocation: String?
    var lodgingLocation: String?
    
    /** All Six */
    var affectedByWeather: Bool?
    var _id: String?
    var type: String?
    var _rev: String?
    
    
    init(_ data: Dict) {
        
        self.itineraryId = data["itineraryId"] as? String
        self.subType = data["subType"] as? String
        
        if let value = data["start_time"] as? Double { self.start_time = value}
        if let value = data["end_time"] as? Double { self.end_time = value }

        
        if let subType = self.subType {
            
            configureAffectedByWeather(data)
            
            switch subType {
                
            case "meeting":
                configureMeetingName(data)
                configureGeometry(data)
                configureVicinity(data)
                configureIsOutdoor(data)
                configureTime(data)
                configureImageUrl(data)
                //configureName(data)
                //configureDisplayType(data)
                
            // this does not actually come in. But it should!
            case "other":
                configureMeetingName(data)
                configureGeometry(data)
                configureVicinity(data)
                configureTime(data)
                
                self.name = data["name"] as? String
                self.imageUrl = data["imageUrl"] as? String
                self.isOutdoor = data["isOutdoor"] as? Bool
                
                
            case "restaurant":
                configureIsTrustedPartner(data)
                configureMeetingName(data)
                configureName(data)
                configureGeometry(data)
                configurePriceLevel(data)
                configureRating(data)
                configureCuisine(data)
                configureDistance(data)
                configureLocation(data)
                configureReviewHighlight(data)
                configureReviewer(data)
                configureReviewTime(data)
                configureVicinity(data)
                configureIsOutdoor(data)
                configureTime(data)
                configureImageUrl(data)
                configureRecommendedReplacements(data)
                
            case "flight":
                configureBoardingTime(data)
                configureDepartureTime(data)
                configureArrivalTime(data)
                configureDepartureAirportCode(data)
                configureArrivalLocation(data)
                configureDepartureLocation(data)
                configureArrivalAirportCode(data)
                configureGate(data)
                configureTerminal(data)
                
            case "lodging":
                configureName(data)
                configureMeetingName(data)
                configureRoom(data)
                configureGeometry(data)
                configureConfirmation(data)
                configureCheckin(data)
                configureCheckout(data)
                configurePrice(data)
                configureIsTrustedPartner(data)
                configureHasPromotionalDiscount(data)
                configurePromotionalDiscount(data)
                configureIsLoyaltyMember(data)
                configureLoyaltyDiscount(data)
                configureRationale(data)
                configureDescription(data)
                configureDisplayType(data)
                configureImageUrl(data)
                configureRating(data)
                configureLocation(data)
                configureReviewHighlight(data)
                configureReviewer(data)
                configureReviewTime(data)
                configureLoyaltyProgramName(data)
                configureLoyaltyPoints(data)
                
                
            case "transit":
                configureIsTrustedPartner(data)
                configureCost(data)
                configureIOSTransitName(data)
                configureTransitSteps(data)
                configureDepartureStreet(data)
                
            case "recommendations":
                self.rec_type = data["rec_type"] as? String
                self.message = data["message"] as? String
                self.fromLocation = data["fromLocation"] as? String
                self.toLocation = data["toLocation"] as? String
                self.lodgingLocation = data["lodgingLocation"] as? String
                
                if let recommendationList = data["recommendationList"] as? [Dict] {
                    
                    self.recommendationList = []
                    
                    for recommendation in recommendationList {
                        
                        self.recommendationList!.append(Event(recommendation))
                        
                    }
                    
                }
                
                self.alert = data["alert"] as? Bool
                
            default: Utils.printMQA("Unsupported event type in Event.swift") // check for errors in BE
                
            }
            
        } else {
            
            Utils.printMQA("Received an improperly formatted **Event** from backend. Tossing. \nTitle: \(self.title)")
            
        }

        self._id = data["_id"] as? String
        self.type = data["type"] as? String
        self._rev = data["_rev"] as? String
        
    }
    
    // MARK: private, shared setter methods
    private func configureTitle(data: Dict) {
        
        self.title = data["title"] as? String
        
    }
    
    private func configureMeetingName(data: Dict) {
        
        self.title = data["meetingName"] as? String
        
    }
    
    private func configureGeometry(data: Dict) {
        
        if let geometry = data["geometry"] as? Dict {
            self.geometry = Geometry(geometry)
        }
        
    }
    
    private func configureVicinity(data: Dict) {
        
        self.vicinity = data["vicinity"] as? String
        
    }
    
    private func configureIsOutdoor(data: Dict) {
        
        self.isOutdoor = data["isOutdoor"] as? Bool
        
    }
    
    private func configureTime(data: Dict) {
        
        if let value = (data["time"] as? Double) { self.time = value }
        
    }
    
    private func configureImageUrl(data: Dict) {
        
        self.imageUrl = data["imageUrl"] as? String
        
    }
    
    private func configureName(data: Dict) {
        
        self.name = data["name"] as? String
        
    }
    
    private func configureAffectedByWeather(data: Dict) {
        
        self.affectedByWeather = data["affectedByWeather"] as? Bool
        
    }

    private func configurePriceLevel(data: Dict) {
        
        if let value = (data["price_level"] as? Double) { self.price_level = value }
        
    }
    
    private func configureRating(data: Dict) {
        
        if let value = (data["rating"] as? Double) { self.rating = value }
        
    }
    
    private func configureCuisine(data: Dict) {
        
        self.cuisine = data["cuisine"] as? String
        
    }
    
    private func configureDistance(data: Dict) {
        
        self.distance = data["distance"] as? String
        
    }
    
    private func configureLocation(data: Dict) {
        
        self.location = data["location"] as? String
        
    }
    
    private func configureReviewHighlight(data: Dict) {
        
        self.reviewHighlight = data["reviewHighlight"] as? String
        
    }
    
    private func configureLoyaltyProgramName(data: Dict) {
        self.loyaltyProgramName = data["loyaltyProgramName"] as? String
    }
    
    private func configureLoyaltyPoints(data: Dict) {
        
        self.loyaltyPoints = data["loyaltyPoints"] as? Double
        
    }
    
    private func configureReviewer(data: Dict) {
        
        self.reviewer = data["reviewer"] as? String
        
    }
    
    private func configureReviewTime(data: Dict) {
        
        self.reviewTime = data["reviewTime"] as? String
        
    }
    
    private func configureBoardingTime(data: Dict) {
        
        if let value = data["boardingTime"] as? Double { self.boardingTime = value }
        
    }
    
    private func configureDepartureTime(data: Dict) {
        
        if let value = data["departureTime"] as? Double { self.departureTime = value }
        
    }
    
    private func configureArrivalTime(data: Dict) {
        
        if let value = data["arrivalTime"] as? Double { self.arrivalTime = value }
        
    }
    
    private func configureDepartureAirportCode(data: Dict) {
        
        self.departureAirportCode = data["departureAirportCode"] as? String
        
    }
    
    private func configureArrivalLocation(data: Dict) {
        
        if let arrivalLocation = data["arrivalLocation"] as? Dict {
            self.arrivalLocation = Location(arrivalLocation)
        }
        
    }
    
    private func configureDepartureLocation(data: Dict) {
        
        if let departureLocation = data["departureLocation"] as? Dict {
            self.departureLocation = Location(departureLocation)
        }
        
    }
    
    private func configureArrivalAirportCode(data: Dict) {
        
        self.arrivalAirportCode = data["arrivalAirportCode"] as? String
        
    }
    
    private func configureGate(data: Dict) {
        
        self.gate = data["gate"] as? String
        
    }
    
    private func configureTerminal(data: Dict) {
        
        self.terminal = data["terminal"] as? String
        
    }
    
    private func configureRoom(data: Dict) {
        
        self.room = data["room"] as? String
        
    }

    private func configureConfirmation(data: Dict) {
        
        self.confirmation = data["confirmation"] as? String
        
    }
    
    private func configureCheckin(data: Dict) {
        
        if let value = data["checkin"] as? Double { self.checkin = value }
        
    }
    
    private func configureCheckout(data: Dict) {
        
        if let value = data["checkout"] as? Double { self.checkout = value }
        
    }
    
    private func configureCost(data: Dict) {
        
        self.cost = data["cost"] as? String
        
    }
    
    private func configureIOSTransitName(data: Dict){
        
        self.ios_transit_name = data["ios_transit_name"] as? String

    }
    
    private func configureDepartureStreet(data: Dict) {
        
        self.departureStreet = data["departureStreet"] as? String
    
    }
    
    private func configureTransitSteps(data: Dict) {
        
        if let transitSteps = data["transit_steps"] as? [Dict] {
            
            self.transit_steps = []
            
            for transitStep in transitSteps {
                
                self.transit_steps?.append(TransitStep(transitStep))
                
            }
            
        }
        
    }
    
    private func configurePrice(data: Dict) {
        
        if let value = (data["price"] as? Double) { self.price = value }
        
    }

    private func configureIsTrustedPartner(data: Dict) {
        
        self.isTrustedPartner = data["isPreferred"] as? Bool

    }
    
    private func configureHasPromotionalDiscount(data: Dict) {
        
        self.hasPromotionalDiscount = data["hasPromotionalDiscount"] as? Bool
        
    }
    
    private func configurePromotionalDiscount(data: Dict) {
        
        if let value = data["promotionalDiscount"] as? Dict { self.promotionalDiscount = Discount(value) }
        
    }
    
    private func configureIsLoyaltyMember(data: Dict) {
        
        self.isLoyaltyMember = data["isLoyaltyMember"] as? Bool
        
    }
    
    private func configureLoyaltyDiscount(data: Dict) {
        
        if let value = data["loyaltyDiscount"] as? Dict { self.loyaltyDiscount = Discount(value) }
        
    }
    
    private func configureRationale(data: Dict) {
        
        self.rationale = data["rationale"] as? String
        
    }
    
    private func configureDescription(data: Dict) {
        
        self.description = data["description"] as? String
        
    }
    
    
    private func configureDisplayType(data: Dict) {
        
        self.displayType = data["displayType"] as? String
        
    }
    
    private func configureRecommendedReplacements(data: Dict) {
        
        if let value = data["recommendedReplacements"] as? Dict { self.recommendedReplacements = Event(value) }
        
    }
    
}
