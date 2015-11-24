/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

class HotelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var roomView: UIView!
    @IBOutlet weak var roomTextLabel: UILabel!
    @IBOutlet weak var cardHolderView: UIView!
    @IBOutlet weak var circleIconImage: UIImageView!
    @IBOutlet weak var accommodationTextLabel: UILabel!
    @IBOutlet weak var accommodationLabel: UILabel!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var confirmationTextLabel: UILabel!
    @IBOutlet weak var roomNumberLabel: UILabel!
    @IBOutlet weak var checkInOutTextLabel: UILabel!
    @IBOutlet weak var checkInOutTimeLabel: UILabel!
    @IBOutlet weak var checkInOutView: UIView!
    
    var displayType : String?
    
    /**
    Method that is called when we wake from nib and it sets up the view
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    /**
    Method that returns the proper height of the cell
    
    - returns: CGFloat
    */
    func getHeight() -> CGFloat
    {
        return 100
    }
    
    
    /**
    Method that sets up the view's UI
    */
    func setUpView(){
        
        backgroundColor = UIColor.travelItineraryCellBackgroundColor()
        cardHolderView.backgroundColor = UIColor.travelItineraryCardBackgroundColor()
        circleIconImage.backgroundColor = UIColor.travelHotelIconColor()
        
        let image = UIImage(named: "Hotel")
        circleIconImage.image = image
        
        cardHolderView.layer.cornerRadius = 3
        
        accommodationTextLabel.font = UIFont.travelRegular(11)
        accommodationTextLabel.textColor = UIColor.travelLightMainFontColor()
        
        confirmationTextLabel.font = UIFont.travelRegular(11)
        confirmationTextLabel.textColor = UIColor.travelLightMainFontColor()
        
        roomTextLabel.font = UIFont.travelRegular(11)
        roomTextLabel.textColor = UIColor.travelLightMainFontColor()
        
        checkInOutTextLabel.font = UIFont.travelRegular(11)
        checkInOutTextLabel.textColor = UIColor.travelLightMainFontColor()
        
        roomNumberLabel.font = UIFont.travelRegular(17)
        roomNumberLabel.textColor = UIColor.travelDarkMainFontColor()
        
        accommodationLabel.font = UIFont.travelRegular(17)
        accommodationLabel.textColor = UIColor.travelDarkMainFontColor()
        
        checkInOutTimeLabel.font = UIFont.travelRegular(17)
        checkInOutTimeLabel.textColor = UIColor.travelDarkMainFontColor()
        
        confirmationLabel.font = UIFont.travelRegular(17)
        confirmationLabel.textColor = UIColor.travelDarkMainFontColor()
        
        cardHolderView.layer.shadowOpacity = 0.2
        cardHolderView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cardHolderView.layer.shadowRadius = 1
        cardHolderView.layer.masksToBounds = false

        
    }
    
    
    /**
    Method that sets up the data for the view
    
    - parameter start_time:    Double?
    - parameter end_time:      Double?
    - parameter accommodation: String?
    - parameter confirmation:  String?
    - parameter roomNumber:    String?
    - parameter typeOfCheck:   String?
    - parameter checkIn:       Double?
    - parameter checkOut:      Double?
    - parameter displayType:   String?
    */
    func setUpData(start_time : Double?, end_time : Double?, accommodation: String?, confirmation: String?, roomNumber : String?, typeOfCheck : String?, checkIn : Double?, checkOut : Double?, displayType: String? ){
        
        //RoomNumberLabel Setup
        var roomNumberLabelString = ""
        if let r_Number = roomNumber {
            roomNumberLabelString = r_Number
            roomNumberLabel.text = roomNumberLabelString
        }
        
        //CheckInOutTimeLabel Setup
        var checkInOutTimeLabelString = ""
 
        if let type = displayType {
            if type == "checkin" {
                checkInOutTextLabel.text = "Check-In"
                if let check = checkIn {
                    checkInOutTimeLabelString = NSDate.convertMillisecondsSince1970ToTimeOfDayThenDayOfMonthThenMonth(Double(check))
                }
            }
            else if type == "checkout"{
                 checkInOutTextLabel.text = "Check-Out"
                
                if let check = checkOut {
                    checkInOutTimeLabelString = NSDate.convertMillisecondsSince1970ToTimeOfDayThenDayOfMonthThenMonth(Double(check))
                }
            }
        }
        checkInOutTimeLabel.text = checkInOutTimeLabelString
    
        
        var accommodationLabelString = ""
        if let a = accommodation {
            accommodationLabelString = a
        }
        accommodationLabel.text = accommodationLabelString
        
        
        var confirmationLabelString = ""
        if let c = confirmation {
            confirmationLabelString = c
        }
        confirmationLabel.text = confirmationLabelString

        
        if displayType == "stay" {
            checkInOutView.hidden = true
            confirmationLabel.hidden = true
            confirmationTextLabel.hidden = true
        } else {
            confirmationLabel.hidden = false
            confirmationTextLabel.hidden = false
            checkInOutView.hidden = false
        }
    }
    
    
    /**
    Method that flashes the cell when the event has been "added" to the itinerary
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
