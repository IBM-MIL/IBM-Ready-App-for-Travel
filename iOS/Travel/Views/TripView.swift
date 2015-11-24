/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

/// Trip view
class TripView: UIView {
    
    /// button
    @IBOutlet weak var button: UIButton!
    
    /// label holder view
    @IBOutlet weak var labelHolderView: UIView!
    
    /// background image view
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    /// black overlay view
    @IBOutlet weak var blackOverlayView: UIView!
    
    /// trip title label
    var tripTitleLabel : UILabel = UILabel()
    
    /// trip detail label
    var tripDetailLabel : UILabel = UILabel()
    
    /// setup finished boolean
    var setUpFinished : Bool = false
    
    let kTripTitleLabelDistanceFromLabelHolderViewCenter : CGFloat = 9
    let kTripDetailLabelDistanceFromTripTitleLabelCenter : CGFloat = 8.5
    
    
    /**
    Method called when we layout subviews
    */
    override func layoutSubviews() {
        
        if(setUpFinished == false){
            self.setUpFinished = true
        }
    }
    
    
    /**
    Method returns an instance of TripView from nib
    
    - returns: TripView
    */
    class func instanceFromNib() -> TripView {
        return UINib(nibName: "TripView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! TripView
    }
    
    
    /**
    Method to setup text labels
    */
    func setText(){
        self.tripTitleLabel.text = NSLocalizedString("Berlin, Event Planning", comment: "")
        self.tripDetailLabel.text = NSLocalizedString("21 Sept - 25 Sept", comment: "")
        self.labelHolderView.setNeedsLayout()
        self.labelHolderView.layoutIfNeeded()
    }
    
    /**
    Method to setup duration dates label
    */
    func setupTripDurationDateLabel() {
        let startDate = NSDate()
        let tomorrow = NSDate.getDateForNumberDaysAfterDate(startDate, daysAfter: 1)
        let start = NSDate.getDateStringWithDayAndMonth(tomorrow)
        let endDate = NSDate.getDateForNumberDaysAfterDate(tomorrow, daysAfter: 4)
        let end = NSDate.getDateStringWithDayAndMonth(endDate)
        tripDetailLabel.text = NSLocalizedString("\(start) - \(end)", comment: "")
        
    }
    
    
    /**
    Method to setup the view's UI
    */
    func setUpView(){
        self.layoutIfNeeded()
    
        let centerY = labelHolderView.frame.size.height/2 - self.kTripTitleLabelDistanceFromLabelHolderViewCenter
        
        let tripTitleFrame = CGRectMake(0, self.labelHolderView.center.y - self.kTripTitleLabelDistanceFromLabelHolderViewCenter, self.labelHolderView.frame.width, CGFloat(20))
        self.tripTitleLabel.frame = tripTitleFrame
        self.tripTitleLabel.center.x = self.labelHolderView.frame.size.width/2
        self.tripTitleLabel.center.y = centerY
        self.tripTitleLabel.font = UIFont.travelRegular(15)
        self.tripTitleLabel.textColor = UIColor.whiteColor()
        self.tripTitleLabel.textAlignment = NSTextAlignment.Center
        self.labelHolderView.addSubview(self.tripTitleLabel)
        
        let tripDetailFrame = CGRectMake(0, self.tripTitleLabel.center.y + self.kTripDetailLabelDistanceFromTripTitleLabelCenter , self.labelHolderView.frame.width, CGFloat(20))
        self.tripDetailLabel.frame = tripDetailFrame
        self.tripDetailLabel.center.x = self.labelHolderView.frame.size.width/2
        self.tripDetailLabel.font = UIFont.travelSemiBold(12)
        self.tripDetailLabel.textColor = UIColor.whiteColor()
        self.tripDetailLabel.textAlignment = NSTextAlignment.Center
        self.labelHolderView.addSubview(self.tripDetailLabel)
        
        self.blackOverlayView.userInteractionEnabled = false
        
    }
    
}
