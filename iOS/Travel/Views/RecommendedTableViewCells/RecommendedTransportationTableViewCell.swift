/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

class RecommendedTransportationTableViewCell: UITableViewCell {

    @IBOutlet weak var preferredView: UIView!
    @IBOutlet weak var preferredLabel: UILabel!
    @IBOutlet weak var transitListImageView: UIImageView!
    @IBOutlet weak var timeRangeLabel: UILabel!
    @IBOutlet weak var departureLocationLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    /**
    Method that sets the cell as selected and ensures the preferred view's background stays the same color
    
    - parameter selected: Bool
    - parameter animated: Bool
    */
    override func setSelected(selected: Bool, animated: Bool) {
        let color = preferredView.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if(selected) {
            preferredView.backgroundColor = color
        }
    }
    
    
    /**
    Method that sets the cell as highlighted and ensures the preferred view's background stays the same color
    
    - parameter highlighted: Bool
    - parameter animated:    Bool
    */
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        let color = preferredView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        
        if(highlighted) {
            preferredView.backgroundColor = color
        }
    }
    
    
    /**
    Method that sets up the view's UI
    */
    func setupView() {
        preferredView.backgroundColor = UIColor.travelDarkMainFontColor()
        preferredLabel.textColor = UIColor.whiteColor()
        preferredLabel.font = UIFont.travelRegular(11)
        
        timeRangeLabel.textColor = UIColor.travelDarkMainFontColor()
        timeRangeLabel.font = UIFont.travelSemiBold(11)
        
        departureLocationLabel.textColor = UIColor.travelLightMainFontColor()
        departureLocationLabel.font = UIFont.travelRegular(11)
        
        durationTimeLabel.textColor = UIColor.travelDarkMainFontColor()
        durationTimeLabel.font = UIFont.travelRegular(17)
        
        priceLabel.textColor = UIColor.travelDarkMainFontColor()
        priceLabel.font = UIFont.travelRegular(11)
        
    }
    
    
    /**
    Method that sets up the data for the view
    
    - parameter departureArea:    String?
    - parameter start_time:       Double?
    - parameter end_time:         Double?
    - parameter cost:             String?
    - parameter isPreferred:      Bool?
    - parameter ios_transit_name: String?
    */
    func setUpData(departureArea : String?, start_time : Double?, end_time : Double?, cost : String?, isPreferred : Bool?, ios_transit_name : String?){
        
        var departureString = ""
        
        if let departArea = departureArea {
            departureString = "From \(departArea)"
        }
        departureLocationLabel.text = departureString
        
        priceLabel.text = cost ?? ""
        
        if let start = start_time, let end = end_time {
            timeRangeLabel.text = "\(NSDate.convertMillisecondsSince1970ToDateWithTimeOfDay(start)) - \(NSDate.convertMillisecondsSince1970ToDateWithTimeOfDay(end))"
            
            let min = NSLocalizedString("min", comment: "")
            
            durationTimeLabel.text = "\(Utils.removeTailingZero(NSDate.minutesBetweenDates(start, end: end))) \(min)"
        }
        
        if let transitName = ios_transit_name {
            
            let image = UIImage(named: transitName)!
            
            transitListImageView.image = image
            
            if (UIScreen.mainScreen().nativeBounds.size.height <= 1136) {
                if(transitName == "walk_rail_rail_walk" || transitName == "walk_rail_bus_walk"){
                    transitListImageView.contentMode = .ScaleAspectFit
                }
                else{
                    transitListImageView.contentMode = .Left
                }
            }
        }

        if let pref = isPreferred {
            if(pref == true){
                preferredView.hidden = false
                preferredView.backgroundColor = UIColor(hex: "323232")
                backgroundColor = UIColor(hex: "f2f2f2")
            }
            else{
                preferredView.hidden = true
            }
        }else{
            preferredView.hidden = true
        }
    }
    
}
