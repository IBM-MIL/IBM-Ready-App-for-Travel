/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

class RecommendedBlaBlaCarTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var departureLocationLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var seatsLeftLabel: UILabel!

    /**
    Method called when wakes from nib and sets up the view's UI
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    
    /**
    Method that sets the cell as selected
    
    - parameter selected: Bool
    - parameter animated: Bool
    */
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    /**
    Method that sets up the view's UI
    */
    func setupView() {
        titleLabel.textColor = UIColor.travelDarkMainFontColor()
        titleLabel.font = UIFont.travelSemiBold(17)
        
        seatsLeftLabel.textColor = UIColor.travelLightMainFontColor()
        seatsLeftLabel.font = UIFont.travelSemiBold(11)
        
        departureTimeLabel.textColor = UIColor.travelDarkMainFontColor()
        departureTimeLabel.font = UIFont.travelSemiBold(11)
        
        departureLocationLabel.textColor = UIColor.travelLightMainFontColor()
        departureLocationLabel.font = UIFont.travelRegular(11)
        
        durationTimeLabel.textColor = UIColor.travelDarkMainFontColor()
        durationTimeLabel.font = UIFont.travelRegular(17)
        
        priceLabel.textColor = UIColor.travelDarkMainFontColor()
        priceLabel.font = UIFont.travelRegular(11)
  
    }
    
    
    /**
    Method that sets up the data for the view
    
    - parameter departureArea:     String?
    - parameter start_time:        Double?
    - parameter end_time:          Double?
    - parameter cost:              String?
    - parameter numberOfSeatsLeft: Double?
    */
    func setUpData(departureArea : String?, start_time : Double?, end_time : Double?, cost : String?, numberOfSeatsLeft : Double?){
        
        var departureString = ""
        
        if let departArea = departureArea {
            departureString = "From \(departArea)"
        }
        departureLocationLabel.text = departureString
        
        priceLabel.text = cost ?? ""
        
        
        if let start = start_time, let end = end_time {
            departureTimeLabel.text = "\(NSDate.convertMillisecondsSince1970ToDateWithTimeOfDay(start))"
            let min = NSLocalizedString("min", comment: "")
            
            durationTimeLabel.text = "\(Utils.removeTailingZero(NSDate.minutesBetweenDates(start, end: end))) \(min)"
            
        }
        
        var numberOfSeatsString = ""
        if let numOfSeats = numberOfSeatsLeft{
            numberOfSeatsString = "\(Utils.removeTailingZero(numOfSeats)) " + NSLocalizedString("seats left", comment: "")
        }
        seatsLeftLabel.text = numberOfSeatsString
        
    }
    
}
