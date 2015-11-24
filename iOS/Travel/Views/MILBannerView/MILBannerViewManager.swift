/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**

**MILBannerViewManager**

Class that manages the creation, display, hiding, and deletion of the MILBannerView

*/
public class MILBannerViewManager: NSObject {
    
    public static var SharedInstance: MILBannerViewManager = {
        
        let manager = MILBannerViewManager()
        
        // sets up our manager to hide alerts when data is in
        TravelDataManager.SharedInstance.travelData.producer.start() {
            
            if let dataIsValid = $0.value?.isValid where dataIsValid == true {
                
                manager.hide()
                
            }
            
        }
        
        return manager
        
        }()
    
    
    var isDisplayingBanner: Bool = false        /// current state for is displaying banner
    
    var bottomHeight: CGFloat! = 0      /// height at which to place the bottom of the MILBannerView
    var autoHideTimer: NSTimer? = nil   /// timer to auto hide alert after a certain amount of time
    var milBannerView : MILBannerView!  /// reference to current banner
    
    
    /**
    Method that builds and displays a MILBannerView
    
    :param: alertType       AlertType of MILBannerView to display. If nil, default alertType is .Classic (required)
    :param: text            Body text to display on the MILBannerView. If nil, default text is "MILBannerView" (required)
    :param: textColor       Color of body text to display
    :param: textFont        Font of body text to display
    :param: backgroundColor Background color of the MILBannerView
    :param: reloadImage     Reload button image (MILBannerView Classic style only with a non-nil callback)
    :param: inView          View in which to add alert as a subview. If inView is nil or not set, alert is added to UIApplication.sharedApplication().keyWindow!
    :param: underView       Alert view will be presented a layer beneath underView within inView. If underView is nil or not set, alert is added at the top of inView
    :param: toHeight        Height of how far down the top of the alert will animate to when showing within inView. If toHeight is nil or not set, toHeight will default to 0 and alert will show at top of inView
    :param: forSeconds      NSTimeInterval (Double) for how many seconds the MILBannerView should stay shown before hiding, but only if callback is nil. If callback is nil, the alert will auto-hide after forSeconds seconds. If callback is not nil, forSeconds will be overwritten and the alert will not hide until tapped. If forSeconds is nil or not set (and callback is nil), the alert will also not hide until tapped.
    :param: callback        Callback method to execute when the MILBannerView or its reload button is tapped (required). If callback is nil, reloadButton will be hidden (and alert will hide on tap)
    */
    func show(alertType: MILBannerView.AlertType!,
        text: String!,
        textColor: UIColor? = nil,
        textFont: UIFont? = nil,
        backgroundColor: UIColor? = nil,
        reloadImage: UIImage? = nil,
        inView: UIView? = nil,
        underView: UIView? = nil,
        toHeight: CGFloat? = nil,
        forSeconds: NSTimeInterval? = nil,
        callback: (()->())!) {
            
            self.resetAlert()
            
            self.milBannerView = MILBannerView.buildAlert(alertType,
                text: text,
                textColor: textColor,
                textFont: textFont,
                backgroundColor: backgroundColor,
                reloadImage: reloadImage,
                inView: inView,
                underView: underView,
                toHeight: toHeight,
                callback: callback
            )
            
            //animate showing alert view
            UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.milBannerView.frame.origin.y = (self.milBannerView.frame.size.height + self.bottomHeight) - self.milBannerView.frame.size.height
                }, completion: { finished -> Void in
                    if finished{
                        self.setAutoHide(forSeconds)
                        if let alertview = self.milBannerView {
                            alertview.userInteractionEnabled = true    //now allow user to touch after done animating
                            self.isDisplayingBanner = true
                        }
                    }
            })
            
    }
    
    /**
    Method to remove the MILBannerView from its superview and set it to nil, and reset MILBannerViewManager properties
    */
    private func resetAlert() {
        
        // reset values in case any alerts are currently shown
        if let alert = self.milBannerView {
            
            alert.userInteractionEnabled = false
            alert.removeFromSuperview()
            
            if let timer = self.autoHideTimer {
                
                timer.invalidate()
                self.autoHideTimer = nil
                
            }
            
            self.bottomHeight = 0
            self.milBannerView = nil
            self.isDisplayingBanner = false
            
        }
        
    }
    
    
    /**
    auto-hide alert after a designated number of seconds
    
    :param: forSeconds NSTimeInterval (Double) for how long the alert should stay shown before hiding
    */
    private func setAutoHide(forSeconds: NSTimeInterval?) {
        
        if let time = forSeconds {
            
            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(time * pow(10, 9)))
            
            dispatch_after(delay, dispatch_get_main_queue()) {
                
                MILBannerViewManager.SharedInstance.hide()
                
            }
            
        }
        
    }
    
    /**
    Hides the MILBannerView with an animation
    */
    func hide() {
        
        if let alert = self.milBannerView{
            
            alert.userInteractionEnabled = false
            
            UIView.animateWithDuration(1,
                delay: 0,
                options: .CurveEaseInOut,
                animations: {
                    
                    () -> Void in
                    
                    self.milBannerView.frame.origin.y = self.bottomHeight - self.milBannerView.frame.size.height
                    
                }, completion: {
                    
                    finished -> Void in
                    
                    if finished {
                        self.remove()
                    }
                    
                }
            )
            
        }
        
    }
    
    /**
    Removes the MILBannerView from its superview and sets it to nil
    */
    private func remove() {
        
        if let alert = self.milBannerView {
            
            alert.removeFromSuperview()
            self.milBannerView = nil
            self.isDisplayingBanner = false
            
        }
        
    }
    
    /**
    Reload function that fires when the MILBannerView is tapped
    */
    @IBAction func reload() {
        
        self.milBannerView.callback()
        hide()
        
    }
    
}
