/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

class InclementWeatherAlertView: UIView {
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var alertBodyLabel: UILabel!
    
    
    var delegate: MILAlertViewDelegate?
    var alertBody: String? {
        willSet { alertBodyLabel.text = newValue }
    }
    var dismissText: String? {
        willSet {
            dismissButton.setTitle(newValue, forState: .Normal)
            dismissButton.setTitle(newValue, forState: .Highlighted)
        }
    }
    var reviewText: String? {
        willSet {
            reviewButton.setTitle(newValue, forState: .Normal)
            reviewButton.setTitle(newValue, forState: .Highlighted)
        }
    }
    
    var milAlertViewType: MILAlertViewType = .EXCLAMATION_MARK {
        
        willSet {
            
            self.icon.contentMode = UIViewContentMode.ScaleAspectFit
            
            func setImage(name name: String) { self.icon.image = UIImage(named: name) }
            
            switch newValue {
                
            case .CHECKMARK: setImage(name: "Confirmation_on_popup")
            case .EXCLAMATION_MARK: setImage(name: "Alert_on_popup")
                
            }
        }
    }
    
    
    /**
    Method to create and return an instance of InclementWeatherAlertView from nib file
    
    - returns: InclementWeatherAlertView
    */
    static func instanceFromNib() -> InclementWeatherAlertView {
        
        let returnView = UINib(nibName: "InclementWeatherAlertView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! InclementWeatherAlertView
        
        returnView.backgroundColor = UIColor.travelAlertBodyColor()
        
        returnView.dismissButton.setTitleColor(UIColor.travelMainColor(), forState: UIControlState.Normal)
        returnView.reviewButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)

        returnView.dismissButton.backgroundColor = UIColor.travelAlertDismissButtonColorNormal()
        returnView.reviewButton.backgroundColor = UIColor.travelMainColor()
        
        return returnView
        
    }
    
    /**
    Method used to define the action when button is fired
    
    - parameter sender: AnyObject
    */
    @IBAction func buttonFired(sender : AnyObject) {
        
        self.delegate?.dismissAlert()
        
    }
    
    
    /**
    Method used to define the action when review is fired
    
    - parameter sender: UIButton
    */
    @IBAction func reviewFired(sender: UIButton) {
    
        self.delegate?.reviewAlert()
        
    }
    
}
