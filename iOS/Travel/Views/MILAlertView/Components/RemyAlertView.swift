/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

class RemyAlertView: UIView {
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var dismissButton: UIButton!
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
    Method that returns an instance of RemyAlertView from nib file
    
    - returns: RemyAlertView
    */
    static func instanceFromNib() -> RemyAlertView {
        
        let returnView = UINib(nibName: "RemyAlertView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! RemyAlertView
        
        returnView.backgroundColor = UIColor.travelAlertBodyColor()
        
        returnView.dismissButton.setTitleColor(UIColor.travelMainColor(), forState: UIControlState.Normal)
        returnView.dismissButton.backgroundColor = UIColor(hex: "e8e8e8")
        
        return returnView
        
    }
    
    /**
    Method that defines the action that happens when the button is fired
    
    - parameter sender: AnyObject
    */
    @IBAction func buttonFired(sender : AnyObject) {
        
        self.delegate?.dismissAlert()
        self.delegate?.reviewAlert()
        
    }
    
}
