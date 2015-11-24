/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

/// Trip detail suppplementary view class (UICollectionReusableView)
class TripDetailSupplementaryView: UICollectionReusableView {
    
    /// time date label
    @IBOutlet weak var timeDateLabel: UILabel!
    
    /// temperature label
    @IBOutlet weak var temperatureLabel: UILabel!
    
    /// section header view
    @IBOutlet weak var sectionHeaderView: UIView!
    
    /// weather image view
    @IBOutlet weak var weatherImageView: UIImageView!
    
    /// line view
    var lineView : UIView!
    
    
    /**
    Method to setup the data of the view
    
    - parameter indexPath:       indexPath
    - parameter date:            date Double
    - parameter highTemperature: hi temp
    - parameter lowTemperature:  low temp
    - parameter condition:       condition string
    */
    func setUp(indexPath: NSIndexPath, date : Double?, highTemperature : Double?, lowTemperature : Double?, condition: String?){
        
        setUpTimeDateLabel(indexPath, date: date)
        setUpTemperatureLabel(highTemperature, temperatureLow : lowTemperature)
        
        
        sectionHeaderView.backgroundColor = UIColor.travelItineraryCellBackgroundColor()
        
        
        let image = Utils.getWeatherConditionIcon( condition!)
        weatherImageView.image = image
        
        lineView = UIView(frame: CGRectMake(0, self.bounds.size.height-52, self.bounds.size.width, 1))
        lineView.backgroundColor = UIColor(hex: "C7C7C7")
        
        if indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 1) {
            // don't draw the horizontal line
            lineView.hidden = true
        } else {
            lineView.hidden = false
           
        }
    }
    
    
    /**
    Method to setup the time date label
    
    - parameter indexPath: indexPath
    - parameter date:      date to setup Double
    */
    func setUpTimeDateLabel(indexPath: NSIndexPath, date : Double?){
        if let d = date {
            
            let time = NSNumber(double: d)
            let milliseconds : NSTimeInterval = time.doubleValue
            
            let dayAndMonth = NSDate.convertMillisecondsSince1970ToDateStringWithDayAndMonth(milliseconds)
            
            let dayOfWeek : String!
            
            if(indexPath.section == 0){
                dayOfWeek = "Tomorrow"
            }
            else{
                dayOfWeek = NSDate.convertMillisecondsSince1970ToDayOfTheWeekString(milliseconds)
            }
            
            let string = "\(dayAndMonth) \(dayOfWeek)"
            let attributedString = NSMutableAttributedString(string: string as String)
            
            //Add attributes to two parts of the string
            attributedString.addAttributes([NSFontAttributeName: UIFont.travelRegular(31),  NSForegroundColorAttributeName: UIColor.travelDarkMainFontColor()], range: (string as NSString).rangeOfString("\(dayAndMonth) "))
            attributedString.addAttributes([NSFontAttributeName: UIFont.travelRegular(14),  NSForegroundColorAttributeName: UIColor.travelLightMainFontColor()], range: (string as NSString).rangeOfString("\(dayOfWeek)"))
            
            timeDateLabel.attributedText = attributedString

        }
        else{
            timeDateLabel.text = ""
        }
    }
    
    
    /**
    Method to setup the tempearture label
    
    - parameter temperatureHigh: hi tem double
    - parameter temperatureLow:  low temp double
    */
    func setUpTemperatureLabel(temperatureHigh : Double?, temperatureLow : Double?){
        
        var highTemp = ""
        
        if let highTemperature = temperatureHigh { highTemp = Utils.removeTailingZero(highTemperature) }
   
        var lowTemp = ""
        
        if let lowTemperature = temperatureLow { lowTemp = Utils.removeTailingZero(lowTemperature) }
        
        let upArrow = "↑"
        
        let downArrow = "↓"
        
        let degreeCircle = "º"
        
        let tempUnit = "C"
        
        temperatureLabel.text = "\(upArrow)\(highTemp)\(degreeCircle)\(tempUnit) \(downArrow)\(lowTemp)\(degreeCircle)\(tempUnit)"
        temperatureLabel.font = UIFont.travelSemiBold(11)
        temperatureLabel.textColor = UIColor.travelSemiDarkMainFontColor()
    }
    
}
