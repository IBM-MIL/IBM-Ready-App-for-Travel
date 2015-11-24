/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

class HotelDetailView: UIView {

    @IBOutlet weak var activityTitleLabel: UILabel!
    @IBOutlet weak var bigTimeLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var visitWebsiteButton: UIButton!
    @IBOutlet weak var openInWalletButton: UIButton!
    @IBOutlet weak var confirmationCodeLabel: UILabel!
    @IBOutlet weak var findTransportationButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var rewardsProgramLabel: UILabel!
    @IBOutlet weak var pointsEarnedLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var contactHotelButton: UIButton!
    @IBOutlet weak var openReservationInWalletHolderView: UIView!
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var starImageView1: UIImageView!
    @IBOutlet weak var starImageView2: UIImageView!
    @IBOutlet weak var starImageView3: UIImageView!
    @IBOutlet weak var starImageView4: UIImageView!
    @IBOutlet weak var starImageView5: UIImageView!


    
    /**
    Method that returns an instance of HotelDetailView from nib
    
    - returns: HotelDetailView
    */
    class func instanceFromNib() -> HotelDetailView {
        let hotelDetailView = UINib(nibName: "HotelDetailView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! HotelDetailView
        hotelDetailView.visitWebsiteButton.setTitleColor(UIColor.travelMainColor(), forState: .Normal)
        hotelDetailView.contactHotelButton.setTitleColor(UIColor.travelMainColor(), forState: .Normal)
        hotelDetailView.openReservationInWalletHolderView.layer.borderColor = UIColor.travelMainColor().CGColor
        hotelDetailView.openReservationInWalletHolderView.layer.borderWidth = 1.0
        
        return hotelDetailView
    }
    
    
    /**
    Method that sets up the data for the view
    
    - parameter activityTitleString: String?
    - parameter checkIn:             Double?
    - parameter checkOut:            Double?
    - parameter confirmationCode:    String?
    - parameter rating:              Double?
    - parameter price_level:         Double?
    - parameter temperatureHigh:     Double?
    - parameter temperatureLow:      Double?
    - parameter weatherCondition:    String?
    - parameter locationName:        String?
    - parameter locationAddress:     String?
    - parameter loyaltyProgramName:  String?
    - parameter loyaltyPoints:       Double?
    */
    func setupData(activityTitleString : String?, checkIn : Double?, checkOut : Double?, confirmationCode : String?, rating : Double?, price_level : Double?, temperatureHigh : Double?, temperatureLow : Double?, weatherCondition : String?, locationName : String?, locationAddress : String?, loyaltyProgramName : String?, loyaltyPoints : Double?){
        
        activityTitleLabel.text = activityTitleString ?? ""
        
        confirmationCodeLabel.text = confirmationCode ?? ""
        
        locationAddressLabel.text = locationAddress ?? ""
        
        if let r = rating {
             Utils.setUpStarStackView(r, starStackView: starStackView)
        }

        
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
        
        
        var bigTimeLabelString = ""
        var dateLabelString = ""
        if let check_in = checkIn {
            
            bigTimeLabelString = NSDate.convertMillisecondsSince1970ToDateWithTimeOfDay(check_in)
            
            dateLabelString = NSDate.convertMillisecondsSince1970ToFullDayOfWeekDayAndMonth(check_in)
            
        }
        bigTimeLabel.text = bigTimeLabelString
        dateLabel.text = dateLabelString
        

        var checkOutDateLabelString = ""
        if let check_out = checkOut {
            checkOutDateLabelString = NSDate.convertMillisecondsSince1970ToTimeOfDayThenDayOfMonthThenMonth(check_out)
        }
        checkOutDateLabel.text = checkOutDateLabelString
        
        
        rewardsProgramLabel.text = loyaltyProgramName ?? ""
        
        var pointsString = ""
        if let points = loyaltyPoints {
            pointsString = "\(Utils.removeTailingZero(points))"
        }
        pointsEarnedLabel.text = pointsString
  
    }
    
}
