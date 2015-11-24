/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

class RecommendedTransportationDetailView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var transitListImageView: UIImageView!
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var durationTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    /**
    Method that returns an instance of RecommendedTransportationDetailView from nib
    
    - returns: RecommendedTransportationDetailView
    */
    class func instanceFromNib() -> RecommendedTransportationDetailView {
        return UINib(nibName: "RecommendedTransportationDetailView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! RecommendedTransportationDetailView
    }
    
    
    /**
    Method called when we wake from nib
    */
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    /**
    Method that sets up the data for the view
    
    - parameter start_time:       Double?
    - parameter end_time:         Double?
    - parameter ios_transit_name: String?
    */
    func setUpData(start_time : Double?, end_time : Double?, ios_transit_name : String?){
        if let start = start_time, let end = end_time {
            let min = NSLocalizedString("min", comment: "")
            durationTimeLabel.text = "\(Utils.removeTailingZero(NSDate.minutesBetweenDates(start, end: end))) \(min)"
        }
        
        if let transitName = ios_transit_name {
            transitListImageView.image = UIImage(named: transitName)
            
            
            if (UIScreen.mainScreen().nativeBounds.size.height <= 1136) {
                transitListImageView.contentMode = .ScaleAspectFit
            }
        }
    }
    
    
    

}







