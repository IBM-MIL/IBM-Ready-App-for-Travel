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

public enum MILAlertViewType {
    
    case CHECKMARK
    case EXCLAMATION_MARK
    
}

/// MARK: Convenience
public extension MILAlertViewManager {
    
    private var uapp: UIApplication { return UIApplication.sharedApplication() }
    
}


public class MILAlertViewManager: NSObject, MILAlertViewDelegate {
    
    public static var SharedInstance: MILAlertViewManager = MILAlertViewManager()
    
    var fadeAlpha : CGFloat = 0.7
    
    private var callbackOnReviewPress: (()->())?
    private var callbackOnDismissPress: (()->())?
    private var fadeView : UIView?
    private var alertView : UIView!
    
    
    /**
    Method that shows the weather alert and calls the callback with respect to the review or dismiss buttons being pressed.
    
    - parameter alertText:              String?
    - parameter dismissText:            String?
    - parameter reviewText:             String?
    - parameter milAlertViewType:       MILAlertViewType
    - parameter callbackOnReviewPress:  (()->())?
    - parameter callbackOnDismissPress: (()->())?
    */
    public func showInclementWeatherAlert(alertText: String?, dismissText: String?, reviewText: String?, milAlertViewType: MILAlertViewType, callbackOnReviewPress: (()->())?, callbackOnDismissPress: (()->())?) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.checkForExistingAlert()
            
            // show alertview on main UI
            self.alertView = InclementWeatherAlertView.instanceFromNib()
            
            let inclementAlertView = self.alertView as! InclementWeatherAlertView
            
            inclementAlertView.delegate = self
            inclementAlertView.alertBody = alertText
            inclementAlertView.dismissText = dismissText ?? "DISMISS"
            inclementAlertView.reviewText = reviewText ?? "REVIEW"
            inclementAlertView.milAlertViewType = milAlertViewType ?? .EXCLAMATION_MARK
            
            self.callbackOnReviewPress = callbackOnReviewPress
            self.callbackOnDismissPress = callbackOnDismissPress
            
            self.createFade()
            self.configureAndDisplayAlert()
            
        }
        
    }
    

    /**
    Method to show the Remy Alert and will calls the callback on review press. Setting dismissButtonText is optional. Ni results in "DISMISS"
    
    - parameter alertText:             String?
    - parameter dismissButtonText:     String?
    - parameter milAlertViewType:      MILAlertViewType
    - parameter callbackOnReviewPress: (()->())?
    */
    public func showRemyAlert(alertText: String?, dismissButtonText: String?, milAlertViewType: MILAlertViewType, callbackOnReviewPress: (()->())?) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.checkForExistingAlert()
            
            // show alertview on main UI
            self.alertView = RemyAlertView.instanceFromNib()
            
            let remyAlertView = self.alertView as! RemyAlertView
            
            remyAlertView.delegate = self
            remyAlertView.alertBody = alertText
            remyAlertView.dismissText = dismissButtonText ?? "DISMISS"
            remyAlertView.milAlertViewType = milAlertViewType ?? .EXCLAMATION_MARK
            
            self.callbackOnReviewPress = callbackOnReviewPress
            
            self.createFade()
            self.configureAndDisplayAlert()
        }
    }
    
    
    /**
    Method to show the alert
    
    - parameter title:           String
    - parameter message:         String
    - parameter isLoading:       Bool
    - parameter hasFade:         Bool
    - parameter alertButtonText: String
    */
    public func showAlert(title: String, message: String, isLoading : Bool = false, hasFade : Bool = true, alertButtonText : String = "") {
        
        dispatch_async(dispatch_get_main_queue()) {

            self.checkForExistingAlert()
            
            // show alertview on main UI
            self.alertView = MILAlertView.instanceFromNib() as! MILAlertView
            
            let milAlertView = self.alertView as! MILAlertView
            
            milAlertView.setAlertInfo(title, alertBody: message, alertButtonText: alertButtonText, delegate: self, isLoading: isLoading)
            
            if(hasFade) { self.createFade() }
            
            self.configureAndDisplayAlert()
            
        }
        
    }
    
    
    /**
    Method to create Fade
    */
    func createFade() {
        
        self.fadeView = UIView()
        
        if let optWindow = self.uapp.delegate?.window, let window = optWindow {
            
            let fadeView = self.fadeView!
            
            fadeView.frame = window.bounds
            fadeView.backgroundColor = UIColor.blackColor()
            fadeView.alpha = fadeAlpha
            
            if let rootView = window.rootViewController?.view {
                
                rootView.addSubview(fadeView)
                rootView.bringSubviewToFront(fadeView)
                
            }
        }
    }
    
    
    /**
    Method to dismiss the fade
    */
    func dismissFade() {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            if let fadeView = self.fadeView { fadeView.removeFromSuperview() }
            
        }
    }
    
    
    /**
    Method to check if there is already an existing alert
    */
    private func checkForExistingAlert() {
        
        if self.alertView != nil{
            self.dismissAlert()
        }
    }
    
    
    /**
    Method to configure and display the alert
    */
    private func configureAndDisplayAlert() {
        self.alertView.transform = CGAffineTransformMakeScale(0.7, 0.7)
        
        self.alertView.center = self.uapp.keyWindow!.center
        self.uapp.keyWindow?.addSubview(alertView)
        
        //animate popup
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 50, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            
            }, completion: { _ in
                
        })
    }
    
    
    /**
    Method to dismiss alert
    */
    public func dismissAlert() {
        dismissFade()
        
        if let callback = self.callbackOnDismissPress {
            callback()
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            
            if let alertView = self.alertView { alertView.removeFromSuperview() }
            self.alertView = nil
        }
        
    }
    
    
    /**
    Method to review alert
    */
    public func reviewAlert() {
        
        dismissFade()
        
        if let callback = self.callbackOnReviewPress {
            callback()
        }
        dispatch_async(dispatch_get_main_queue()) {
            
            if let alertView = self.alertView {
                alertView.removeFromSuperview()}
            self.alertView = nil
            
        }
  
    }

}
