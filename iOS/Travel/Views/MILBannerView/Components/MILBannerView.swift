/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  The view presented when an alert is triggered
*/
public class MILBannerView : UIView {
    
    //// Label of the alert
    @IBOutlet weak var alertLabel : UILabel!
    
    /// Reload button that may or may not be shown
    @IBOutlet weak var reloadButton: UIButton!
    
    /// Callback of the Alert
    var callback : (()->())!
    
    /// Small tab view on bottom of MILFakeMessageAlertView only
    @IBOutlet weak var pullDownView: UIView?
    
    /// Type of alert to show
    var alertType: AlertType?
    
    /**
    Enum for type of Banner to show
    
    - Classic:     Classic alert with a refresh button
    - FakeMessage: Fake Message banner
    */
    enum AlertType {
        case Classic
        case FakeMessage
    }
    
    /**
    Initializer for MILBannerView
    
    :returns: And instance of MILBannerView
    */
    private class func classicAlertFromNib() -> MILBannerView {
        return UINib(nibName: "MILBannerView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! MILBannerView
    }
    
    /**
    Initializer for MILFakeMessageBannerView
    
    :returns: And instance of MILFakeMessageBannerView
    */
    private class func fakeMessageAlertFromNib() -> MILBannerView {
        return UINib(nibName: "MILFakeMessageBannerView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! MILBannerView
    }
    
    /**
    Builds an MILBannerView that is initialized with the appropriate data
    
    :param: alertType       AlertType of MILBannerView to display. If nil, default alertType is .Classic (required)
    :param: text            Body text to display on the MILBannerView. If nil, default text is "MILBannerView" (required)
    :param: textColor       Color of body text to display
    :param: textFont        Font of body text to display
    :param: backgroundColor Background color of the MILBannerView
    :param: reloadImage     Reload button image (MILBannerView .Classic style only with a non-nil callback)
    :param: inView          View in which to add alert as a subview. If inView is nil or not set, alert is added to UIApplication.sharedApplication().keyWindow!
    :param: underView       Alert view will be presented a layer beneath underView within inView. If underView is nil or not set, alert is added at the top of inView
    :param: toHeight        Height of how far down the top of the alert will animate to when showing within inView. If toHeight is nil or not set, toHeight will default to 0 and alert will show at top of inView
    :param: callback        Callback method to execute when the MILBannerView or its reload button is tapped (required). If callback is nil, reloadButton will be hidden (and alert will hide on tap)
    
    :returns: An initialized MILBannerView
    */
    class func buildAlert(alertType: AlertType!,
        text: String!,
        textColor: UIColor? = nil,
        textFont: UIFont? = nil,
        backgroundColor: UIColor? = nil,
        reloadImage: UIImage? = nil,
        inView: UIView? = nil,
        underView: UIView? = nil,
        toHeight: CGFloat? = nil,
        callback: (()->())!)-> MILBannerView {
            
            var milBanner : MILBannerView!
            
            MILBannerViewManager.SharedInstance.bottomHeight = toHeight ?? 0
            
            //build alert with correct type
            let typeOfAlert = alertType ?? .Classic
            
            switch typeOfAlert {
                
            case .Classic:
                milBanner = MILBannerView.classicAlertFromNib() as MILBannerView
                
            case .FakeMessage:
                milBanner = MILBannerView.fakeMessageAlertFromNib() as MILBannerView
                milBanner.pullDownView!.layer.cornerRadius = 2
                
            }
            
            milBanner.alertType = typeOfAlert
            
            //temporarily disable user interaction while building and showing alert
            milBanner.userInteractionEnabled = false
            
            // setup text
            if let txt = text {
                milBanner.alertLabel.text = txt
            }
            if let newTextColor = textColor {
                milBanner.alertLabel.textColor = newTextColor
            }
            if let newTextFont = textFont {
                milBanner.alertLabel.font = newTextFont
            }
            
            // setup background color
            if let newColor = backgroundColor { milBanner.backgroundColor = newColor }
            
            // setup reload button image
            if let image = reloadImage where milBanner.alertType == .Classic {
                
                milBanner.reloadButton.setImage(image, forState: UIControlState.Normal)
                
            }
            
            // setup which view alert is in and/or under
            var onView: UIView
            if let view = inView {
                onView = view
            } else {
                onView = UIApplication.sharedApplication().keyWindow!
            }
            
            if let under = underView {
                onView.insertSubview(milBanner, belowSubview: under)
            } else {
                onView.addSubview(milBanner)
            }
            
            //set origin, width, and bottom
            milBanner.frame.origin = CGPoint(x: 0, y: milBanner.frame.origin.y)
            milBanner.frame.size.width = UIScreen.mainScreen().bounds.width
            milBanner.frame.origin.y = MILBannerViewManager.SharedInstance.bottomHeight - milBanner.frame.size.height
            
            milBanner.setCallbackFunc(callback)
            
            return milBanner
    }
    
    
    /**
    Sets the callback for the MILBannerView and reloadButton to either hide (if callback is nil) or reload (call callback) in the MILBannerViewManager
    
    :param: callback The callback function that is to be executed when the MILBannerView or reload button is tapped
    */
    private func setCallbackFunc(callback:(()->())!) {
        
        var tapGesture = UITapGestureRecognizer(target: MILBannerViewManager.SharedInstance, action: "hide") //hide if no callback
        
        if let cb = callback {
            
            self.reloadButton.hidden = false
            self.callback = cb
            tapGesture = UITapGestureRecognizer(target: MILBannerViewManager.SharedInstance, action: "reload") //reload then hide if callback
            self.reloadButton.addTarget(MILBannerViewManager.SharedInstance, action: "reload", forControlEvents: UIControlEvents.TouchUpInside)
            
        } else{
            
            self.reloadButton.hidden = true
            
        }
        
        self.addGestureRecognizer(tapGesture)
        
    }
    
}
