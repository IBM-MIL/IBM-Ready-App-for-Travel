/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

class MeetingDetailView: UIView {

    @IBOutlet weak var activityTitleLabel: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bigTimeLabel: UILabel!
    @IBOutlet weak var smallTimeLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var visitWebsiteButton: UIButton!
    @IBOutlet weak var openInCalendarButton: UIButton!
    @IBOutlet weak var findTransportationButton: UIButton!
    
    @IBOutlet weak var openEventInCalenderHolderView: UIView!
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var starImageView1: UIImageView!
    @IBOutlet weak var starImageView2: UIImageView!
    @IBOutlet weak var starImageView3: UIImageView!
    @IBOutlet weak var starImageView4: UIImageView!
    @IBOutlet weak var starImageView5: UIImageView!
    
 

    
    /**
    Method that returns an instance of MeetingDetailView from nib
    
    - returns: MeetingDetailView
    */
    class func instanceFromNib() -> MeetingDetailView {
        return UINib(nibName: "MeetingDetailView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! MeetingDetailView
    }
    
    
    /**
    Method that is called when we wake from nib and it sets up the view
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    
    /**
    Method that sets up the view's UI
    */
    func setupView() {
        let withString = NSLocalizedString("With", comment: "")
        let nameString = NSLocalizedString("Arnold Schwarzenegger", comment: "")
        let andString = NSLocalizedString("and", comment: "")
        let otherString = NSLocalizedString("2 others", comment: "")
        let wholeString = "\(withString) \(nameString) \(andString) \(otherString)"
        let attributedString = NSMutableAttributedString(string: wholeString as String)
        
        //Add attributes to two parts of the string
        attributedString.addAttributes([NSFontAttributeName: UIFont.travelRegular(11),  NSForegroundColorAttributeName: UIColor.travelDarkMainFontColor()], range: (wholeString as NSString).rangeOfString("\(withString) "))
        attributedString.addAttributes([NSFontAttributeName: UIFont.travelBold(11),  NSForegroundColorAttributeName: UIColor.travelDarkMainFontColor()], range: (wholeString as NSString).rangeOfString("\(nameString) "))
        attributedString.addAttributes([NSFontAttributeName: UIFont.travelRegular(11),  NSForegroundColorAttributeName: UIColor.travelDarkMainFontColor()], range: (wholeString as NSString).rangeOfString("\(andString) "))
        attributedString.addAttributes([NSFontAttributeName: UIFont.travelBold(11),  NSForegroundColorAttributeName: UIColor.travelDarkMainFontColor()], range: (wholeString as NSString).rangeOfString("\(otherString)"))
        
        friendsLabel.attributedText = attributedString
        
        visitWebsiteButton.setTitleColor(UIColor.travelMainColor(), forState: .Normal)
        openEventInCalenderHolderView.layer.borderColor = UIColor.travelMainColor().CGColor
        openEventInCalenderHolderView.layer.borderWidth = 1.0
    }
    
    
    
    /**
    Method that sets up the data for the view
    
    - parameter activityTitleString: String?
    - parameter start_time:          Double?
    - parameter end_time:            Double?
    - parameter rating:              Double?
    - parameter price_level:         Double?
    - parameter temperatureHigh:     Double?
    - parameter temperatureLow:      Double?
    - parameter weatherCondition:    String?
    - parameter locationName:        String?
    - parameter locationAddress:     String?
    */
    func setupData(activityTitleString : String?, start_time : Double?, end_time : Double?, rating : Double?, price_level : Double?, temperatureHigh : Double?, temperatureLow : Double?, weatherCondition : String?, locationName : String?, locationAddress : String?){
        
        activityTitleLabel.text = activityTitleString ?? ""
        
        var dateString = ""
        if let s_time = start_time {
            dateString = NSDate.convertMillisecondsSince1970ToFullDayOfWeekDayAndMonth(s_time)
        }
        dateLabel.text = dateString
        
        var startTimeString = ""
        if let s_time = start_time {
            startTimeString = NSDate.convertMillisecondsSince1970ToDateWithTimeOfDay(s_time)
        }
        bigTimeLabel.text = startTimeString
        
        var endTimeString = ""
        if let e_time = end_time {
            endTimeString = NSDate.convertMillisecondsSince1970ToDateWithTimeOfDay(e_time)
        }
        smallTimeLabel.text = endTimeString
        
        if let r = rating {
            Utils.setUpStarStackView(r, starStackView: starStackView)
        }
        
        var priceRangeString = ""
        if let priceLevel = price_level {
            priceRangeString = Utils.generateExpensiveString(Int(priceLevel))
        }
        priceRangeLabel.text = priceRangeString
        
        
        if let w_Condition = weatherCondition {
            weatherImageView.image = Utils.getWeatherConditionIcon(w_Condition)
        }
        else {
            weatherImageView.image = UIImage()
        }
        
        var highTemp = ""
        if let highTemperature = temperatureHigh { highTemp = Utils.removeTailingZero(highTemperature) }
        let degreeCircle = "º"
        let tempUnit = "C"
        
        temperatureLabel.text = "\(highTemp)\(degreeCircle)\(tempUnit)"
        
        var locationNameString = ""
        if let locName = locationName {
            locationNameString = locName
        }
        locationNameLabel.text = locationNameString
        
        var locationAddressString = ""
        if let locAddress = locationAddress {
            locationAddressString = locAddress
        }
        locationAddressLabel.text = locationAddressString
        
    }
    
    
    
    
    
}
