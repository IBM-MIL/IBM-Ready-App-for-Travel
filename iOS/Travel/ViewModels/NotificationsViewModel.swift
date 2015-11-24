/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

class NotificationsViewModel: NSObject {

    //Date data array used to populate the Notifications tableView
    var dataArray : [NotificationObject] = [NotificationObject]()
    
    //Property that defines the number of sections in the Notifications tableView
    let kNumberOfSections = 1
    
    
    /**
    Method that setups up the dataArray upon init by calling the setupDataArrayMethod
    
    - returns:
    */
    override init(){
        super.init()
        setupDataArray()
    }
    
    
    /**
    Method that setups up the dataArray with NotificationObjects
    */
    func setupDataArray(){
        
        let object1 = NotificationObject()
        object1.notificationType = "weatherAlert"
        object1.notificationText = NSLocalizedString("Inclement weather may affect your Regroup with audio/visual team at Pfau Cafe.", comment: "")
        object1.notificationTimeStamp = NSLocalizedString("Just now", comment: "")
        dataArray.append(object1)
        
        let object2 = NotificationObject()
        object2.notificationType = "event"
        object2.notificationText = NSLocalizedString("Richard added a location for Event Launch", comment: "")
        object2.notificationTimeStamp = NSLocalizedString("2 mins ago", comment: "")
        dataArray.append(object2)
        
        let object3 = NotificationObject()
        object3.notificationType = "flight"
        object3.notificationText = NSLocalizedString("Your flight to Berlin is boarding now at Gate 316", comment: "")
        object3.notificationTimeStamp = NSLocalizedString("1 day ago", comment: "")
        dataArray.append(object3)
        
        let object4 = NotificationObject()
        object4.notificationType = "event"
        object4.notificationText = NSLocalizedString("You created a new trip: Berlin, Event Planning", comment: "")
        object4.notificationTimeStamp = NSLocalizedString("7 days ago", comment: "")
        dataArray.append(object4)
        
    }
    
    
    /**
    Method that returns the number of rows in the section defined by the section parameter
    
    - parameter section: Int
    
    - returns: Int
    */
    func numberOfRowsInSection(section : Int) -> Int {
        return dataArray.count
    }
    
    
    /**
    Method that returns the number of sections in the table view
    
    - returns: Int
    */
    func numberOfSectionsInTableView() -> Int {
        return kNumberOfSections
    }
    
    
    /**
    Method that setups up the tableViewCell at the indexPath parameter using the data from the notificationObject at that respective indexPath
    
    - parameter indexPath: NSIndexPath
    - parameter tableView: UITableView
    
    - returns: UITableViewCell
    */
    func setUpTableViewCell(indexPath : NSIndexPath, tableView: UITableView) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NotificationsTableViewCell", forIndexPath: indexPath) as! NotificationsTableViewCell
        
        if (indexPath.row == 0) {
            cell.backgroundColor = UIColor(hex: "f2f2f2")
        }
        
        let notificationObject = dataArray[indexPath.row]
        
        cell.setupData(notificationObject.notificationType,
            notificationText: notificationObject.notificationText,
            notificationTimeStamp: notificationObject.notificationTimeStamp
        )
        
        return cell
    }
    
    
    /**
    Method that returns the weather alert event view model by settting up data returned from the TravelDataManager's getEventAndDateForWeatherAlert
    
    - returns: EventDetailViewModel
    */
    func getWeatherAlertEventViewModel() -> EventDetailViewModel {
        
        let tuple = TravelDataManager.SharedInstance.getEventAndDateForWeatherAlertEvent()
        
        let date = tuple.date
        let event = tuple.event
        
        let eventDetailViewModel = EventDetailViewModel(date: date!, event: event!)
        
        return eventDetailViewModel
        
    }
    
}


class NotificationObject {
    
    var notificationType : String!
    var notificationText : String!
    var notificationTimeStamp: String!

}
