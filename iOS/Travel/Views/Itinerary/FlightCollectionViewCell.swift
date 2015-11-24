/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

class FlightCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cardHolderView: UIView!
    @IBOutlet weak var circleIconImage: UIImageView!
    @IBOutlet weak var departingCodeLabel: UILabel!
    @IBOutlet weak var arrivingCodeLabel: UILabel!
    @IBOutlet weak var departingCityLabel: UILabel!
    @IBOutlet weak var arrivingCityLabel: UILabel!
    @IBOutlet weak var pinImageView: UIImageView!
    @IBOutlet weak var boardingTimeLabel: UILabel!
    @IBOutlet weak var gateLabel: UILabel!
    @IBOutlet weak var terminalLabel: UILabel!
    @IBOutlet weak var delayButton: UIButton!
    @IBOutlet weak var boardingTitleLabel: UILabel!
    @IBOutlet weak var terminalTitleLabel: UILabel!
    @IBOutlet weak var gateTitleLabel: UILabel!
    
    
    /**
    Method that is called when we wake up from nib - it sets up the view
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
        circleIconImage.backgroundColor = UIColor.travelFlightIconColor()
        
        let image = UIImage(named: "Flight")
        circleIconImage.image = image
        circleIconImage.sizeThatFits( CGSize(width: 10, height: 10))
        
        cardHolderView.layer.cornerRadius = 3

        timeLabel.font = UIFont.travelSemiBold(11)
        timeLabel.textColor = UIColor.travelSemiDarkMainFontColor()
        
        departingCodeLabel.font = UIFont.travelRegular(11)
        departingCodeLabel.textColor = UIColor.travelLightMainFontColor()
        
        departingCityLabel.font = UIFont.travelRegular(17)
        departingCityLabel.textColor = UIColor.travelDarkMainFontColor()
        
        arrivingCodeLabel.font = UIFont.travelRegular(11)
        arrivingCodeLabel.textColor = UIColor.travelLightMainFontColor()
        
        arrivingCityLabel.font = UIFont.travelRegular(17)
        arrivingCityLabel.textColor = UIColor.travelDarkMainFontColor()
        
        boardingTitleLabel.font = UIFont.travelRegular(11)
        boardingTitleLabel.textColor = UIColor.travelLightMainFontColor()
        
        boardingTimeLabel.font = UIFont.travelRegular(17)
        boardingTimeLabel.textColor = UIColor.travelDarkMainFontColor()
        
        gateTitleLabel.font = UIFont.travelRegular(11)
        gateTitleLabel.textColor = UIColor.travelLightMainFontColor()
        
        gateLabel.font = UIFont.travelRegular(17)
        gateLabel.textColor = UIColor.travelDarkMainFontColor()
        
        terminalTitleLabel.font = UIFont.travelRegular(11)
        terminalTitleLabel.textColor = UIColor.travelLightMainFontColor()
        
        terminalLabel.font = UIFont.travelRegular(17)
        terminalLabel.textColor = UIColor.travelDarkMainFontColor()
        
        cardHolderView.layer.shadowOpacity = 0.2
        cardHolderView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cardHolderView.layer.shadowRadius = 1
        cardHolderView.layer.masksToBounds = false
        
    }
    
    
    /**
    Method that sets up the data for the view
    
    - parameter start_time:            Double?
    - parameter end_time:              Double?
    - parameter departureAirportCode:  String?
    - parameter departingCityLocation: String?
    - parameter arrivalAirportCode:    String?
    - parameter arrivingCityLocation:  String?
    - parameter gate:                  String?
    - parameter terminal:              String?
    - parameter boardingTime:          Double?
    */
    func setUpData(start_time : Double?, end_time : Double?, departureAirportCode : String?, departingCityLocation: String?, arrivalAirportCode : String?, arrivingCityLocation : String?, gate : String?, terminal : String?, boardingTime : Double?){
        
        //TimeLabelString Setup
        var timeLabelString = ""
        if let s_t = start_time {
            if let e_t = end_time {
                timeLabelString = "\( NSDate.convertMillisecondsSince1970ToDateWithTimeOfDay(s_t)) - \( NSDate.convertMillisecondsSince1970ToDateWithTimeOfDay(e_t))"
            }
        }
        timeLabel.text = timeLabelString
        
        
        //DepartingCodeLabel Setup
        let departingString = NSLocalizedString("Departing", comment: "")
        var departingAirportCodeLabelString = "\(departingString)"
        if let d_AirportCode = departureAirportCode {
            departingAirportCodeLabelString = "\(departingAirportCodeLabelString) \(d_AirportCode)"
        }
        departingCodeLabel.text = departingAirportCodeLabelString
        
        
        //DepartingCityLabel Setup
        departingCityLabel.text = departingCityLocation
        
        //ArrivingCodeLabel Setup
        let arrivingString = NSLocalizedString("Arriving", comment: "")
        var arrivalAirportCodeLabelString = "\(arrivingString)"
        if let a_AirportCode = arrivalAirportCode {
            arrivalAirportCodeLabelString = "\(arrivalAirportCodeLabelString) \(a_AirportCode)"
        }
        arrivingCodeLabel.text = arrivalAirportCodeLabelString
        
        
        //ArrivingCityLabel Setup
        var arrivingCityLabelString = ""
        if let a_CityLocation = arrivingCityLocation {
                arrivingCityLabelString = a_CityLocation
        }
        arrivingCityLabel.text = arrivingCityLabelString
        
        
        //GateLabelString Setup
        var gateLabelString = ""
        if let g = gate {
            gateLabelString = g
        }
        gateLabel.text = gateLabelString
        

        //TerminalLabelString Setup
        var terminalLabelString = ""
        if let t = terminal {
            terminalLabelString = t
        }
        terminalLabel.text = terminalLabelString
        
        
        //BoardingTimeLabel Setup
        var boardingTimeLabelString = ""
        if let b_Time = boardingTime {
            
            boardingTimeLabelString = NSDate.convertMillisecondsSince1970ToDateWithTimeOfDay(Double(b_Time))
        }
        boardingTimeLabel.text = boardingTimeLabelString
  
    }
    
}
