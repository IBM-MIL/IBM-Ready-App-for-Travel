/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

class RecommendedTransportationDetailTableViewCell: UITableViewCell {


    @IBOutlet weak var bigTimeLabel: UILabel!
    @IBOutlet weak var toTimeLabel: UILabel!
    @IBOutlet weak var fromLocationLabel: UILabel!
    @IBOutlet weak var directionsTitleLabel: UILabel!
    @IBOutlet weak var toLocationLabel: UILabel!
    @IBOutlet weak var transitStepImageView: UIImageView!
    @IBOutlet weak var transitImageSubtitleLabel: UILabel!
    
    let kWalkTransitType = "walk"
    let kRailTransitType = "rail"
    
    
    /**
    Method called when we wake from nib
    */
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    /**
    Method sets the cell as selected
    
    - parameter selected: Bool
    - parameter animated: Bool
    */
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    /**
    Method that sets up the data for the view
    
    - parameter start_time:    Double?
    - parameter end_time:      Double?
    - parameter details:       String?
    - parameter type:          String?
    - parameter walkTime:      String?
    - parameter transitLine:   String?
    - parameter departureArea: String?
    - parameter arrivalArea:   String?
    - parameter numberOfStops: Double?
    */
    func setUpData(start_time : Double?, end_time : Double?, details : String?, type : String?, walkTime : String?, transitLine : String?, departureArea : String?, arrivalArea : String?, numberOfStops : Double?){
    
    
        var bigTimeString = ""
        if let start = start_time {
            bigTimeString = NSDate.convertMillisecondsSince1970ToDateWithTimeOfDay(start)
        }
        bigTimeLabel.text = bigTimeString
    
        
        var fromString = ""
        if let departArea = departureArea {
            let from = NSLocalizedString("From", comment: "")
            fromString = "\(from) \(departArea)"
        }
        fromLocationLabel.text = fromString
        
        
        if let end = end_time {
            let toWord = NSLocalizedString("To", comment: "")
            toTimeLabel.text = "\(toWord) \(NSDate.convertMillisecondsSince1970ToDateWithTimeOfDay(end))"
        }
    
        toLocationLabel.text = arrivalArea ?? ""
        
        if let transitType = type {
            
            transitStepImageView.image = UIImage(named: transitType)
            
            if(transitType == kWalkTransitType){
                directionsTitleLabel.text = details ?? ""
                
                let minWord = NSLocalizedString("min", comment: "")
                if let w_Time = walkTime {
                    transitImageSubtitleLabel.text = "\(w_Time) \(minWord)"
                    transitImageSubtitleLabel.textColor = UIColor(hex: "ababab")
                    transitImageSubtitleLabel.font = UIFont.travelRegular(14)
                }
                
            }
            else if(transitType == kRailTransitType){
                
                if let directions = details, let stops = numberOfStops {
                    
                    var stopWord = ""
                    if(stops > 1){
                        stopWord = NSLocalizedString("stops", comment: "")
                    }
                    else{
                        stopWord = NSLocalizedString("stop", comment: "")
                    }
                        
                    let string = "\(directions) (\(Utils.removeTailingZero(stops)) \(stopWord))"
                    let attributedString = NSMutableAttributedString(string: string as String)
                    
                    //Add attributes to two parts of the string
                    attributedString.addAttributes([NSFontAttributeName: UIFont.travelRegular(14),  NSForegroundColorAttributeName: UIColor.travelDarkMainFontColor()], range: (string as NSString).rangeOfString("\(directions) "))
                    attributedString.addAttributes([NSFontAttributeName: UIFont.travelRegular(14),  NSForegroundColorAttributeName: UIColor.travelLightMainFontColor()], range: (string as NSString).rangeOfString("(\(Utils.removeTailingZero(stops)) \(stopWord))"))
                    
                    directionsTitleLabel.attributedText = attributedString
                    
                    transitImageSubtitleLabel.text = transitLine ?? ""
                    transitImageSubtitleLabel.textColor = UIColor(hex: "5AA400")
                    transitImageSubtitleLabel.font = UIFont.travelSemiBold(17)
                }
            }
        }
        
        
        
        
        }
    
    
}
