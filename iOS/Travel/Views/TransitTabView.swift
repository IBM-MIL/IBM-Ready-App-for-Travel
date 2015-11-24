/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

/// Tranist tab view shown in the Rail pass confirmation screen
class TransitTabView: UIView {

    /// start date label
    @IBOutlet weak var departureDateLabel: UILabel!
    
    /// search button
    @IBOutlet weak var searchButton: UIButton!
    
    
    @IBOutlet weak var refreshButton: UIButton!
    /**
    Method that returns an instance of TransitTabView
    
    - returns: TransitTabView
    */
    class func instanceFromNib() -> TransitTabView {
        return UINib(nibName: "TransitTabView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! TransitTabView
    }
    
    
    /**
    Method to setup the view
    */
    func setupView() {
        let todaysDate = NSDate()
        let tomorrow = NSDate.getDateForNumberDaysAfterDate(todaysDate, daysAfter: 1)
        departureDateLabel.text = NSDate.getDateStringWithDayOfWeekDayAndMonth(tomorrow)
        
        refreshButton.backgroundColor = UIColor.travelMainColor()
    }
     
}
