/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

class MixedTransitCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardHolderView: UIView!
    @IBOutlet weak var circleIconImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var departingTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var departingLocationLabel: UILabel!
    @IBOutlet weak var transitListImageView: UIImageView!
    
    var transportImage : UIImage?
    
    
    /**
    Method that is called when we wake from nib and it sets up the view
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    
    /**
    Method that sets up the views UI
    */
    func setUpView(){
        
        backgroundColor = UIColor.travelItineraryCellBackgroundColor()
        cardHolderView.backgroundColor = UIColor.travelItineraryCardBackgroundColor()
        circleIconImage.backgroundColor = UIColor.travelTransitIconColor()
        
        cardHolderView.layer.cornerRadius = 3
        
        timeLabel.font = UIFont.travelSemiBold(11)
        timeLabel.textColor = UIColor.travelSemiDarkMainFontColor()
        
        departingTimeLabel.font = UIFont.travelRegular(17)
        departingTimeLabel.textColor = UIColor.travelDarkMainFontColor()
        
        departingLocationLabel.font = UIFont.travelItalic(11)
        departingLocationLabel.textColor = UIColor.travelDarkMainFontColor()
        
        durationLabel.font = UIFont.travelRegular(17)
        durationLabel.textColor = UIColor.travelDarkMainFontColor()
        
        circleIconImage.image = UIImage(named: "Ground_transportation")
        
        cardHolderView.layer.shadowOpacity = 0.2
        cardHolderView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cardHolderView.layer.shadowRadius = 1
        cardHolderView.layer.masksToBounds = false
    }
    
    
    /**
    Method that sets up the data for the view
    
    - parameter start_time:        Double?
    - parameter end_time:          Double?
    - parameter departingLocation: String?
    - parameter type:              String?
    */
    func setUpData(start_time : Double?, end_time : Double?, departingLocation : String?, type: String?){
        
        if let imageName = type {
            let image = UIImage(named: imageName)
            if let img = image{
                transitListImageView.image = img
                if (UIScreen.mainScreen().nativeBounds.size.height <= 1136) {
                    transitListImageView.contentMode = .ScaleAspectFit
                }
            }
        }

        var timeLabelString = ""
        if let s_t = start_time {
            if let e_t = end_time {
                timeLabelString = "\( NSDate.convertMillisecondsSince1970ToDateWithTimeOfDay(s_t)) - \( NSDate.convertMillisecondsSince1970ToDateWithTimeOfDay(e_t))"
            }
        }
        timeLabel.text = timeLabelString
        
        
        var departingTimeLabelString = ""
        if let s_t = start_time {
                departingTimeLabelString = NSDate.convertMillisecondsSince1970ToDateWithTimeOfDay(s_t)
        }
        departingTimeLabel.text = departingTimeLabelString
        
        
        var departingLocationLabelString = "From "
        if let departingLoc = departingLocation {
            departingLocationLabelString = "\(departingLocationLabelString) \(departingLoc)"
        }
        departingLocationLabel.text = departingLocationLabelString
        
        // calculate the duration from the start and end times
        let duration = (end_time! - start_time!)/60000.0
        let min = NSLocalizedString("min", comment: "")
        durationLabel.text = "\(Utils.removeTailingZero(duration)) \(min)"
        
    }
    
    
    /**
    Method that flashes the cell when the card is "added" to the itinerary
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
