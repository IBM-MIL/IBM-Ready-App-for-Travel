/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

/// Horizontal two part stack view
class HorizontalTwoPartStackView: UIView {

    /// first header label
    @IBOutlet weak var firstHeaderLabel: UILabel!
    
    /// second header label
    @IBOutlet weak var secondHeaderLabel: UILabel!
    
    /// first content label
    @IBOutlet weak var firstContentLabel: UILabel!
    
    /// second content label
    @IBOutlet weak var secondContentLabel: UILabel!
    
    /// separator view
    @IBOutlet weak var separatorView: UIView!
    
    /// horizontal separator view
    @IBOutlet weak var horizontalSeparatorView: UIView!
    
    
    let kHotelRecType = "lodging"
    let kTransitRecType = "transit"
    let kHotelFirstHeader = NSLocalizedString("Location", comment: "")
    let kHotelSecondHeader = NSLocalizedString("Duration", comment: "")
    let kTransitFirstHeader = NSLocalizedString("From", comment: "")
    let kTransitSecondHeader = NSLocalizedString("To", comment: "")
    
    
    /**
    Method is called when we wake from nib and we setup the view's UI
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    
    /**
    Method returns an instance of HorizontalTwoPartStackView from nib
    
    - returns: HorizontalTwoPartStackView
    */
    class func instanceFromNib() -> HorizontalTwoPartStackView {
        return UINib(nibName: "HorizontalTwoPartStackView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! HorizontalTwoPartStackView
    }
    
    
    /**
    Method to setup the view
    */
    func setupView() {
        separatorView.backgroundColor = UIColor(hex: "c9c9c9")
        horizontalSeparatorView.backgroundColor = UIColor(hex: "c9c9c9")
        
        firstHeaderLabel.textColor = UIColor(hex: "9a9a9a")
        firstHeaderLabel.font = UIFont.travelSemiBold(11)
        
        firstContentLabel.textColor = UIColor.travelMainColor()
        firstContentLabel.font = UIFont.travelSemiBold(11)
        
        secondHeaderLabel.textColor = UIColor(hex: "9a9a9a")
        secondHeaderLabel.font = UIFont.travelSemiBold(11)
        
        secondContentLabel.textColor = UIColor.travelMainColor()
        secondContentLabel.font = UIFont.travelSemiBold(11)
        
    }
    
    
    /**
    Method to setup the data in the view
    
    - parameter recType:         type
    - parameter lodgingLocation: location
    - parameter fromLocation:    from location
    - parameter toLocation:      to location
    - parameter start_time:      start time
    - parameter end_time:        end time
    */
    func setUpData(recType : String, lodgingLocation : String?, fromLocation : String?, toLocation : String?, start_time : Double?, end_time : Double?){
        
        if(recType == kHotelRecType){
        
            firstHeaderLabel.text = kHotelFirstHeader
            secondHeaderLabel.text = kHotelSecondHeader
            
            firstContentLabel.text = lodgingLocation ?? ""
            

            //DurationDatesLabel Setup and DurationNightsLabel Setup
            var durationDatesString = ""
            var durationNightsString = ""
            if let s_t = start_time {
                if let e_t = end_time {
                    durationDatesString = "\( NSDate.convertMillisecondsSince1970ToDayOfWeekDayAndMonth(Double(s_t))) - \( NSDate.convertMillisecondsSince1970ToDayOfWeekDayAndMonth(Double(e_t)))"
                    
                    let nights = NSLocalizedString("Nights", comment: "")
                    durationNightsString = "\(Utils.removeTailingZero(NSDate.nightsBetweenDates(s_t, end: e_t))) " + nights
                }
            }
            secondContentLabel.text = "\(durationNightsString)\n\(durationDatesString)"
            
    
        }
        else if(recType == kTransitRecType){
            firstHeaderLabel.text = kTransitFirstHeader
            secondHeaderLabel.text = kTransitSecondHeader
            
            firstContentLabel.text = fromLocation ?? ""
            secondContentLabel.text = toLocation ?? ""
            
        }
    }
    
    
}
