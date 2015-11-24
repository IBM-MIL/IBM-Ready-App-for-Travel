/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

class MyTripsViewModel: NSObject {

    //Array that holds all the MyTripsObjects to display in the MyTrips TableView
    var dataArray : [MyTripsObject] = [MyTripsObject]()
    
    //Constant property that defines the number of sections in the MyTrips table view
    let kNumberOfSections = 1
    
    
    /**
    Method calls the setupDataArray upon init
    
    - returns:
    */
    override init(){
        super.init()
        setupDataArray()
    }
    
    /**
    Method returns the number of rows in section depending on the dataArray.count
    
    - parameter section: Int
    
    - returns: Int
    */
    func numberOfRowsInSection(section : Int) -> Int {
        return dataArray.count
    }
    
    
    /**
    Method returns the number of sections in the table view, which is a constant of 1
    
    - returns: Int
    */
    func numberOfSectionsInTableView() -> Int {
        return kNumberOfSections
    }
    
    
    /**
    Method setups up the tableViewCell at the indexPath parameter using the respective MyTripsObjects in the Data Array
    
    - parameter indexPath: NSIndexPath
    - parameter tableView: tableView
    
    - returns: UITableViewCell
    */
    func setUpTableViewCell(indexPath : NSIndexPath, tableView: UITableView) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MyTripsTableViewCell", forIndexPath: indexPath) as! MyTripsTableViewCell
        
        cell.setupTripView()
        
        let myTripsObject = dataArray[indexPath.row]
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.setupData(myTripsObject.title, subTitle: myTripsObject.subtitle, imageNameString: myTripsObject.imageNameString)
        
        return cell
    }
    

    
    /**
    Method creates hard coded MyTripsObjects and adds the to the dataArray
    */
    func setupDataArray(){
        
        let object1 = MyTripsObject()
        object1.title = NSLocalizedString("Berlin, Event Planning", comment: "")
        object1.subtitle = setupTripDurationForBerlin()
        object1.imageNameString = "Trips-berlin"
        dataArray.append(object1)
        
        let object2 = MyTripsObject()
        object2.title = NSLocalizedString("Brand B London PR Event", comment: "")
        object2.subtitle = setupTripDurationForLondon()
        object2.imageNameString = "trips-london"
        dataArray.append(object2)
        
        let object3 = MyTripsObject()
        object3.title = NSLocalizedString("Expansion Proposal New York", comment: "")
        object3.subtitle = setupTripDurationForNYC()
        object3.imageNameString = "trips-nyc"
        dataArray.append(object3)
        
    }
    
    
    /**
    Method setups up the trip duration subtitle of the MyTripsObject for Berlin
    
    - returns: String
    */
    func setupTripDurationForBerlin() -> String {
        let startDate = NSDate()
        let startDateReal = NSDate.getDateForNumberDaysAfterDate(startDate, daysAfter: 1)
        let start = NSDate.getDateStringWithDayAndMonth(startDateReal)
        let endDate = NSDate.getDateForNumberDaysAfterDate(startDateReal, daysAfter: 4)
        let end = NSDate.getDateStringWithDayAndMonth(endDate)
        return NSLocalizedString("\(start) - \(end)", comment: "")
    }
    
    /**
    Method setups the trip duration subtitle of the MyTripsObject for London
    
    - returns: String
    */
    func setupTripDurationForLondon() -> String {
        let startDate = NSDate()
        let startDateReal = NSDate.getDateForNumberDaysAfterDate(startDate, daysAfter: 54)
        let start = NSDate.getDateStringWithDayAndMonth(startDateReal)
        let endDate = NSDate.getDateForNumberDaysAfterDate(startDate, daysAfter: 60)
        let end = NSDate.getDateStringWithDayAndMonth(endDate)
        return NSLocalizedString("\(start) - \(end)", comment: "")
    }
    
    /**
    Method setups the trip duration subtitle of the MyTripsObject for NYC
    
    - returns: String
    */
    func setupTripDurationForNYC() -> String {
        let startDate = NSDate()
        let startDateReal = NSDate.getDateForNumberDaysAfterDate(startDate, daysAfter: 115)
        let start = NSDate.getDateStringWithDayAndMonth(startDateReal)
        let endDate = NSDate.getDateForNumberDaysAfterDate(startDate, daysAfter: 120)
        let end = NSDate.getDateStringWithDayAndMonth(endDate)
        return NSLocalizedString("\(start) - \(end)", comment: "")
    }
    

}


class MyTripsObject: NSObject {

    var title: String!
    var subtitle: String!
    var imageNameString: String!
    
}