/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

/**
* This cell is used for both restaurants and meetings
* Meetings do not show the stars, but the restaurants do.
**/
class MeetingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardHolderView: UIView!
    @IBOutlet weak var circleIconImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var expensiveLabel: UILabel!
    @IBOutlet weak var weatherAlertBanner: UIView!
    @IBOutlet weak var weatherAlertBannerLabel: UILabel!
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var starImageView1: UIImageView!
    @IBOutlet weak var starImageView2: UIImageView!
    @IBOutlet weak var starImageView3: UIImageView!
    @IBOutlet weak var starImageView4: UIImageView!
    @IBOutlet weak var starImageView5: UIImageView!
    
    var restaurantImage : UIImage?
    var meetingImage : UIImage?
    var otherImage : UIImage?
    let weatherAlertBannerText = "Inclement weather may affect this event."
    
    
    /**
    Method that is called when we wake up from nib and we set up the view
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    
    /**
    Method that sets up the view's UI
    */
    func setUpView(){
        
        backgroundColor = UIColor.travelItineraryCellBackgroundColor()
        cardHolderView.backgroundColor = UIColor.travelItineraryCardBackgroundColor()
        circleIconImage.backgroundColor = UIColor.travelMeetingIconColor()
        
        cardHolderView.layer.cornerRadius = 3
        
        weatherAlertBanner.backgroundColor = UIColor.travelMainColor()
        weatherAlertBannerLabel.textColor = UIColor.whiteColor()
        weatherAlertBannerLabel.text = weatherAlertBannerText
        weatherAlertBannerLabel.font = UIFont.travelRegular(12)
        
        timeLabel.font = UIFont.travelSemiBold(11)
        timeLabel.textColor = UIColor.travelSemiDarkMainFontColor()
        
        locationLabel.font = UIFont.travelRegular(11)
        locationLabel.textColor = UIColor.travelLightMainFontColor()
        
        expensiveLabel.font = UIFont.travelRegular(11)
        expensiveLabel.textColor = UIColor.travelLightMainFontColor()
        
        titleLabel.font = UIFont.travelRegular(17)
        titleLabel.textColor = UIColor.travelDarkMainFontColor()
        
        restaurantImage = UIImage(named: "Restaurant")
        meetingImage = UIImage(named: "Meeting")
        otherImage = UIImage(named: "Other")
        
        cardHolderView.layer.shadowOpacity = 0.2
        cardHolderView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cardHolderView.layer.shadowRadius = 1
        cardHolderView.layer.masksToBounds = false
    }
    
    
    /**
    Method that sets up the data for the view
    
    - parameter start_time:          Double?
    - parameter end_time:            Double?
    - parameter title:               String?
    - parameter location:            String?
    - parameter numberOfStars:       Double?
    - parameter expensiveLevel:      Double?
    - parameter subtype:             String?
    - parameter outdoor:             Bool?
    - parameter isAffectedByWeather: Bool?
    */
    func setUpData(start_time : Double?, end_time : Double?, title : String?, location : String?, numberOfStars : Double?, expensiveLevel : Double?,  subtype: String?,
        outdoor: Bool?, isAffectedByWeather : Bool?){


        weatherAlertBanner.hidden = true
        if let affected = isAffectedByWeather {
            if(affected == true){
                weatherAlertBanner.hidden = false
            }
        }
        
        var timeLabelString = ""
        if let s_t = start_time, let e_t = end_time {
            
                timeLabelString = "\( NSDate.convertMillisecondsSince1970ToDateWithTimeOfDay(s_t)) - \( NSDate.convertMillisecondsSince1970ToDateWithTimeOfDay(e_t))"
        }
        timeLabel.text = timeLabelString
    
        
        var titleString = ""
        if let t = title {
            titleString = t
        }
        titleLabel.text = titleString
        
        var locationString = ""
        if let l = location {
            locationString = l
        }
        locationLabel.text = locationString
        
        
        var expensiveString = ""
        if let expensLevel = expensiveLevel {
            expensiveString = Utils.generateExpensiveString(Int(expensLevel))
        }
        expensiveLabel.text = expensiveString
        
        if let rating = numberOfStars {
        
            Utils.setUpStarStackView(rating, starStackView: starStackView)
        }
        
        
        if let t = subtype {
            if t == "restaurant" {
                    expensiveLabel.hidden = false
                    starStackView.hidden = false
                    circleIconImage.image = restaurantImage
                    circleIconImage.backgroundColor = UIColor.travelRestaurantIconColor()
            }
            else if t == "meeting" {
                
                expensiveLabel.hidden = true
                
                if let outdoor = outdoor {
                    
                    if outdoor == false {
                    
                        starStackView.hidden = true
                    
                        circleIconImage.image = meetingImage
                        circleIconImage.backgroundColor = UIColor.travelMeetingIconColor()
                    } else {
                    
                    
                        // it's an event poi
                        starStackView.hidden = true
                        circleIconImage.backgroundColor = UIColor.travelEventIconColor()
                        circleIconImage.image = otherImage
                    }
                    
                }
            }
            else {
                assert(false)
            }
        }
    }
    
    
    /**
    Method that flashes the cell when the event is "added" to the itinerary
    */
    func flash(){
        
        let duration : NSTimeInterval = 0.3
        let duration2 : NSTimeInterval = 0.7
        
        let old = cardHolderView.backgroundColor
        
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.cardHolderView.backgroundColor = UIColor(hex: "e9e9e9")
            }, completion:{ _ in
                
                UIView.animateWithDuration(duration2, animations: {
                    self.cardHolderView.backgroundColor = old
                })
        })
    }

}
