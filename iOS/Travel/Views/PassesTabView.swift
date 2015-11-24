/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

/// Passes tab view shown in Create trip VC
class PassesTabView: UIView {


    /// location label
    @IBOutlet weak var locationLabel: UILabel!
    
    /// start date label
    @IBOutlet weak var startDateLabel: UILabel!
    
    /// start date label
    @IBOutlet weak var endDateLabel: UILabel!
    
    /// search button
    @IBOutlet weak var searchButton: UIButton!

    
    /**
    Method returns an instance of PassesTabView from nib
    
    - returns: PassesTabView
    */
    class func instanceFromNib() -> PassesTabView {
        return UINib(nibName: "PassesTabView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! PassesTabView
    }
    
    
    /**
    Method to setup the view
    */
    func setupView() {
        let todaysDate = NSDate()
        let tomorrow = NSDate.getDateForNumberDaysAfterDate(todaysDate, daysAfter: 1)
        startDateLabel.text = NSDate.getDateStringWithDayOfWeekDayAndMonth(tomorrow)
        let futureDate = NSDate.getDateForNumberDaysAfterDate(tomorrow, daysAfter: 4)
        endDateLabel.text = NSDate.getDateStringWithDayOfWeekDayAndMonth(futureDate)
        
        searchButton.backgroundColor = UIColor.travelMainColor()
      
    }
    
    
}
