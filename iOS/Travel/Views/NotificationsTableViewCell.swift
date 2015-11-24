/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit


/// Notifications table view cell
class NotificationsTableViewCell: UITableViewCell {
    
    /// icon image view
    @IBOutlet weak var iconImageView: UIImageView!
    
    /// notification text label
    @IBOutlet weak var notificationTextLabel: UILabel!
    
    /// right arrow image view
    @IBOutlet weak var rightArrowImageView: UIImageView!

    
    
    /**
    Method is called when we wake from nib
    */
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    /**
    Method sets the cell as selected and ensures the iconImageView background color stays the same
    
    - parameter selected: Bool
    - parameter animated: Bool
    */
    override func setSelected(selected: Bool, animated: Bool) {
        let color = iconImageView.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if(selected) {
            iconImageView.backgroundColor = color
        }
    }
    
    
    /**
    Method sets the cell as highlighted and ensures the iconImageView background color stays the same
    
    - parameter highlighted: Bool
    - parameter animated:    Bool
    */
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        let color = iconImageView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        
        if(highlighted) {
            iconImageView.backgroundColor = color
        }
    }
    
    
    /**
    setup the data for the view
    
    - parameter notificationType:      type of notification
    - parameter notificationText:      text of notification
    - parameter notificationTimeStamp: time stamp of notification
    */
    func setupData(notificationType : String, notificationText: String, notificationTimeStamp: String){
        
        notificationTextLabel.text = notificationText
        
        let string = "\(notificationText) \n\(notificationTimeStamp)"
        let attributedString = NSMutableAttributedString(string: string as String)
        
        //Add attributes to two parts of the string
        attributedString.addAttributes([NSFontAttributeName: UIFont.travelRegular(14),  NSForegroundColorAttributeName: UIColor.travelDarkMainFontColor()], range: (string as NSString).rangeOfString("\(notificationText) "))
        attributedString.addAttributes([NSFontAttributeName: UIFont.travelRegular(11),  NSForegroundColorAttributeName: UIColor.travelLightMainFontColor()], range: (string as NSString).rangeOfString("\n\(notificationTimeStamp)"))
        
        notificationTextLabel.attributedText = attributedString
        
        rightArrowImageView.hidden = true
        
        iconImageView.layer.cornerRadius = iconImageView.frame.size.width/2
        iconImageView.sizeThatFits( CGSize(width: 10, height: 10))
        if(notificationType == "weatherAlert"){
            rightArrowImageView.hidden = false
            
            iconImageView.image = UIImage(named:"Alert_on_popup")
        }
        else if(notificationType == "event"){
            
            iconImageView.image = UIImage(named:"Other")
            iconImageView.backgroundColor = UIColor.travelEventIconColor()
        }
        else if(notificationType == "meeting"){
            iconImageView.image = UIImage(named:"Meeting")
            iconImageView.backgroundColor = UIColor.travelMeetingIconColor()
        }
        else if(notificationType == "flight"){
            iconImageView.image = UIImage(named:"Flight")
            iconImageView.backgroundColor = UIColor.travelFlightIconColor()
        }
    }
 
}
