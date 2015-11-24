/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

public class MILBackdropManager {
    
    static let SharedInstance: MILBackdropManager = {
        
        let manager = MILBackdropManager()
        
        return manager
        
        }()
    
    
    var fadeAlpha: CGFloat = 0.7
    var animationDuration: NSTimeInterval = 1.5
    
    /**
    Method to remove the overlay
    
    - parameter fadeOut: Bool
    */
    func removeOverlay(fadeOut fadeOut: Bool) {
        
        if let view = self.currentOverlay {
            
            func removeView() { view.removeFromSuperview() }
            
            if fadeOut {
                
                MILDelayedBlock.Execute(secondsDelay: self.animationDuration) { removeView() }
                
                UIView.animateWithDuration(self.animationDuration) { view.alpha = 0.0 }
                
            } else {
                removeView()
            }
        }
    }
    
    /**
    Method to display gray overlay
    
    - parameter fadeIn: Bool
    */
    func displayGrayOverlay(fadeIn fadeIn: Bool) {
        
        let view = UIView()
        view.alpha = fadeAlpha
        displayOverlay(view, fadeIn: fadeIn, tryAgain: true)
        
    }
    
    
    /**
    Method to display burred overlay
    
    - parameter fadeIn:    Bool
    - parameter blurStyle: UIBlurEffectStyle
    */
    func displayBlurredOverlay(fadeIn fadeIn: Bool, blurStyle: UIBlurEffectStyle) {
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        displayOverlay(view, fadeIn: fadeIn, tryAgain: true)
        
    }
    
    private var currentOverlay: UIView?
    
}


/// MARK: Private Implementation
extension MILBackdropManager {
    
    
    /**
    Method to display overlay
    
    - parameter overlayView: UIView?
    - parameter fadeIn:      Bool
    - parameter tryAgain:    Bool
    */
    private func displayOverlay(overlayView: UIView?, fadeIn: Bool, tryAgain: Bool) {
        let optionalOptionalWindow = UIApplication.sharedApplication().delegate?.window
        
        if let optionalWindow = optionalOptionalWindow,
            let window = optionalWindow,
            let view = overlayView {
                
                self.currentOverlay = view
                
                view.frame = window.bounds
                view.backgroundColor = UIColor.blackColor()
                view.alpha = 0
                
                if let rootView = window.rootViewController?.view {
                    
                    func display() {
                        rootView.addSubview(view)
                        rootView.bringSubviewToFront(view)
                    }
                    
                    if fadeIn {
                        display()
                        
                        UIView.animateWithDuration(self.animationDuration) {
                            view.alpha = self.fadeAlpha
                        }
                        
                    } else {
                        display()
                        view.alpha = fadeAlpha
                    }
                }
                
        } else {
            
            // attempt (only once) again in 0.2 seconds, perhaps we tried too soon in app initialization
            guard (tryAgain == true) else { return }
            
            MILDelayedBlock.Execute(secondsDelay: 0.2) {
                
                self.displayOverlay(overlayView, fadeIn: fadeIn, tryAgain: false)
                
            }
        }
    }
    
}
