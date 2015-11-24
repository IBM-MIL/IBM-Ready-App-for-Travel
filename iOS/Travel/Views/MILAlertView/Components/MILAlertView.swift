/**************************************
*
*  Licensed Materials - Property of IBM
*  © Copyright IBM Corporation 2015. All Rights Reserved.
*  This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer
*  (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product,
*  either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's
*  own products.
*
***************************************/

import UIKit

public class MILAlertView : UIView {
    
    @IBOutlet weak var alertTitleLabel : UILabel!
    @IBOutlet weak var alertBodyLabel : UILabel!
    @IBOutlet weak var alertButton : UIButton!
    @IBOutlet weak var loadingImage : UIImageView!
    
    var delegate : MILAlertViewDelegate?;
    var isLoading = false
    
    
    /**
    Method to create and return an instance of MILAlertView from nib
    
    - returns: UIView
    */
    static func instanceFromNib() -> UIView {
        return UINib(nibName: "MILAlertView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    
    /**
    Method used to define the action when the button is fired
    
    - parameter sender: AnyObject
    */
    @IBAction func buttonFired(sender : AnyObject) {
        self.delegate?.dismissAlert()
    }
    
    
    /**
    Method used to set the alert info
    
    - parameter alertTitle:      String
    - parameter alertBody:       String
    - parameter alertButtonText: String
    - parameter delegate:        MILAlertViewDelegate
    - parameter isLoading:       Bool
    */
    func setAlertInfo(alertTitle : String, alertBody : String, alertButtonText : String, delegate : MILAlertViewDelegate, isLoading : Bool) {
        
        self.delegate = delegate
        self.alertTitleLabel.text = alertTitle
        self.alertBodyLabel.text = alertBody
        self.alertButton.titleLabel?.text = alertButtonText
        self.isLoading = isLoading
        
        if(isLoading) {
            self.showLoadingAnimation()
        }
    }
    
    
    /**
    Method to show the loading animation
    */
    func showLoadingAnimation() {
        
        self.alertButton.hidden = true
        self.loadingImage.image = UIImage.animatedImageNamed("load", duration: 1.0)
        self.loadingImage.hidden = false
        
    }
    
}