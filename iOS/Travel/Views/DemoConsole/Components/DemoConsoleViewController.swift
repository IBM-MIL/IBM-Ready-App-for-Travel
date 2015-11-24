/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

/**

**DemoConsoleViewController**

* **UIPanGestureRecognizer** for showing demo-dropdown

* Handles displaying dropdown to select time of day

*/
class DemoConsoleViewController: UIViewController {
    
//    /**
//    Method sets the status bar style to light content
//    
//    - returns: UIStatusBarStyle
//    */
//    override func preferredStatusBarStyle() -> UIStatusBarStyle { return UIStatusBarStyle.LightContent }
    
    // generic window (latest design)
    weak var window: UIWindow?
    
    // three finger swipe
    var demoConsoleView: DemoConsoleView!
    
    // three finger swipe constants
    private let dropDownViewAnimateDuration = Double(0.75)
    
    // concurrency
    private var sharedQueue: dispatch_queue_t!
    
    // supporting variables
    private var _viewModel: DemoConsoleViewModel!
    
}


/**

MARK: Convenience

*/
extension DemoConsoleViewController {
    
    private var screenBounds: CGRect { return UIScreen.mainScreen().bounds }
    private var screenWidth: CGFloat { return self.screenBounds.width }
    private var screenHeight: CGFloat { return self.screenBounds.height }
    
    private var dropDownHeight: CGFloat { return 354 }
    
}


/**

MARK: Setup

*/
extension DemoConsoleViewController {
    
    /**
    Method is called when we receieve a memory warning
    */
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    
    /**
    Method sets the status bar to be shown
    
    - returns: Bool
    */
    override func prefersStatusBarHidden() -> Bool { return false }
    
    
    /**
    Method is called upon view did load
    */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        assert(self.view != nil, "Set DemoConsoleViewController.view before proceeding.")
        
        self._viewModel = DemoConsoleViewModel()
        
        // three finger swipe
        configureSharedQueue()
    }
    
    
    /**
    Method configures the shared queue
    */
    private func configureSharedQueue() {
        
        var onceToken = dispatch_once_t()
        
        dispatch_once(&onceToken) {
            
            self.sharedQueue = dispatch_queue_create("DemoConsoleQueue", nil)
            
        }
    }
    
}


/**

MARK: - Three Finger Swipe

*/
extension DemoConsoleViewController: DemoConsoleDismissalProtocol {
    
    var demoConsoleFrame: CGRect {
        
        return CGRect(
            x: 0.0,
            y: -self.dropDownHeight,
            width: self.screenWidth,
            height: self.dropDownHeight
        )
        
    }
    
    
    /**
    Method dismisses the demo console
    */
    func dismissDemoConsole() {
        
        MILBackdropManager.SharedInstance.removeOverlay(fadeOut: true)
        
        dispatch_sync(self.sharedQueue) {
            
            UIView.animateWithDuration(self.dropDownViewAnimateDuration) {
                
                if self.demoConsoleView != nil {
                    
                    // animate out dropDownConsole
                    self.demoConsoleView.frame.origin = CGPoint(
                        x: 0.0,
                        y: -self.dropDownHeight
                    )
                }
            }
            
            // after a similar delay + a bit (safety)
            // 1 second = 10E9 nanoseconds
            let timeFudgeFactor: Double = 50000 // nanoseconds
            let deltaTime = Int64(
                self.dropDownViewAnimateDuration * pow(10, 9) + timeFudgeFactor
            )
            
            let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, deltaTime)
            
            dispatch_after(dispatchTime, dispatch_get_main_queue()) {
                
                // destroy demoConsole
                self.destroyDemoConsole()
                
                // restore gesture recognition window size
                self.window?.frame = CGRect(origin: CGPointZero, size: CGSizeZero)
                
            }
        }
    }
    
    
    /**
    Method is called here and from **AppDelegate**, it shows the MILBackdropManager and demo console
    */
    func display() {
        
        MILBackdropManager.SharedInstance.displayGrayOverlay(fadeIn: true)
        
        if self.demoConsoleView == nil {
            
            dispatch_sync(self.sharedQueue) {
                
                // full-screen uiwindow
                self.window?.frame = self.screenBounds
                
                // instantiate dropdownview offscreen
                self.createDemoConsole()
                
                // animate dropdownview in
                UIView.animateWithDuration(self.dropDownViewAnimateDuration, animations: {
                    self.demoConsoleView.frame.origin = self.view.frame.origin
                    
                    }, completion: { _ in
                        
                        if let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController as? UITabBarController {
                            
                            rootViewController.view!.userInteractionEnabled = true
                            
                        }
                })
            }
        }
    }
    
    
    /**
    Method creates the demo console
    */
    private func createDemoConsole() {
        
        self.demoConsoleView = DemoConsoleView.InstanceFromNib(demoConsoleFrame, dismisser: self)
        
        configureReactiveButtonMonitoring()
        
        self.view.addSubview(self.demoConsoleView)
        self.view.bringSubviewToFront(self.demoConsoleView)
        
    }
    
    
    /**
    Method disables buttons until successfully obtained data
    */
    private func configureReactiveButtonMonitoring() {
        
        self.demoConsoleView.isEnabled = false
        
        self.demoConsoleView.dismisser.viewModel.travelData.producer.start() {
            
            if let dataIsValid = $0.value?.isValid where dataIsValid == true {
                
                self.demoConsoleView.isEnabled = true
                self.configureReactiveItineraryMonitoring()
                
            }
        }
    }
    
    
    /**
    Method highlights appropriate itinerary
    */
    private func configureReactiveItineraryMonitoring() {
        
        if let demoConsoleView = self.demoConsoleView {
            
            demoConsoleView.dismisser.viewModel.currentItineraryObservable().producer.start() {
                
                if let currentIndex = $0.value {
                    
                    demoConsoleView.setIndexHighlight(currentIndex)
                    
                }
            }
        }
    }
    
    
    /**
    Method destroys the demo console
    */
    private func destroyDemoConsole() {
        if self.demoConsoleView != nil {
            self.demoConsoleView.removeFromSuperview()
            self.demoConsoleView = nil
        }
    }
    
}


extension DemoConsoleViewController: DemoConsoleDataProviderProtocol {
    
    var viewModel: DemoConsoleViewModel { return _viewModel }
    
}

