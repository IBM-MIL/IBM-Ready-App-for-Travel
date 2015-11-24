/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

/// Confirmation view for rail pass purchase
class RailConfirmationView: UIView {
    
    /// valid dates label
    @IBOutlet weak var validDatesLabel: UILabel!
    
    @IBOutlet weak var addPassToWalletHolderView: UIView!
    
    
    
    /**
    Method is called when we wake from nib
    */
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    /**
    Method returns an instance of RailConfirmationView from nib
    
    - returns: RailConfirmationView
    */
    class func instanceFromNib() -> RailConfirmationView {
        let railConfirmationView = UINib(nibName: "RailConfirmationView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! RailConfirmationView
        railConfirmationView.setupView()
        
        return railConfirmationView
    }
    
    func setupView(){
        addPassToWalletHolderView.layer.borderColor = UIColor.travelMainColor().CGColor
        addPassToWalletHolderView.layer.borderWidth = 1.0
        
        
    }
    
    
    /**
    Method to setup the valid dates label
    */
    func setupValidDatesLabel() {
        let startDate = NSDate()
        let tomorrow = NSDate.getDateForNumberDaysAfterDate(startDate, daysAfter: 1)
        let start = NSDate.getDateStringWithDayAndMonth(tomorrow)
        let endDate = NSDate.getDateForNumberDaysAfterDate(tomorrow, daysAfter: 7)
        let end = NSDate.getDateStringWithDayAndMonth(endDate)
        validDatesLabel.text = NSLocalizedString("\(start) - \(end)", comment: "")
        
    }

}
