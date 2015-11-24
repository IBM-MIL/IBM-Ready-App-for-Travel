/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

/// MARK: Constants
extension TabBarViewController {
    
    // TabBarViewController is our root view controller
    var SHOW_LOADING_SCREEN: Bool { return true }
    
}

/**

**TabBarViewController**

* Animates hiding the tab bar

*/
class TabBarViewController: UITabBarController {
    
    // animation
    var kAnimateHideDuration: NSTimeInterval = 0.5
    
    // tabBar
    private var _tabBar: UITabBar { return self.tabBar }
    
    /// loading View manager shared instance
    var loadingVM: LoadingViewManager! { return LoadingViewManager.SharedInstance }
    
    /// go vc object
    var goVC: GoViewController!
    
    // concurrency queue
    private var sharedQueue: dispatch_queue_t!
    
    // only show loading on app launch
    private var isAppLaunch = true
    
}


/**
*  MARK: - Setup & Memory
*/
extension TabBarViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle { return UIStatusBarStyle.LightContent }
    
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        configureTabItemIcons()
        configureSharedQueue()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if isAppLaunch {
            isAppLaunch = false
            configureLoading()
        }
    }
    
    
    /**
    Method to setup loading view and show it
    */
    private func configureLoading() {
        if (SHOW_LOADING_SCREEN) {
            
            self.loadingVM.showLoadingViewforSecondsWithText(0, title: NSLocalizedString("Loading data.", comment: "")) {}
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideDataLoadingScreen", name: "TravelDataPost", object: nil)

        }
        
    }
    

    /**
    Method to setup a new shared queue for concurrency
    */
    private func configureSharedQueue() {
        var onceToken = dispatch_once_t()
        
        dispatch_once(&onceToken) {
            self.sharedQueue = dispatch_queue_create("LoadingQueue", nil)
        }
    }
    
    
    /**
    Method to start reactive monitoring on a producer
    */
    func configureReactiveButtonMonitoring() {
        TravelDataManager.SharedInstance.travelData.producer.start() {
            
            Utils.printMQA("Reactive: start on producer value")
            
            if let dataIsValid = $0.value?.isValid where dataIsValid == true {
                
                Utils.printMQA("done!!!, we have data mofos")
                Utils.printMQA("calling dismiss from reactive method, \(dataIsValid)")
                
            } else {
                
                Utils.printMQA("no data loaded yet \(NSDate.timeIntervalSinceReferenceDate())")
                
            }
        }
    }
    
    
    /**
    Method to configure the tabbar color
    */
    private func configureTabBar() {
        UITabBar.appearance().tintColor = UIColor.travelMainColor()
    }
    
    
    /**
    Method to configure tab bar icons
    */
    private func configureTabItemIcons() {
        
        let errorString = "TabBarViewController: Error finding child view controllers."
        
        guard let viewControllers = self.viewControllers else {
            Utils.printMQA(errorString); return
        }
        
        for viewController in viewControllers {
            
            if let preGo = viewController as? PreGoViewController {
                
                self.goVC = preGo.viewControllers.first as! GoViewController
                
                
                viewController.tabBarItem = UITabBarItem(
                    title: NSLocalizedString("Booking", comment: ""),
                    image: UIImage(named: "Rail_Booking"),
                    selectedImage: UIImage(named: "Rail_Booking_filled")
                )
                
            } else if let _ = viewController as? MyTripsNavigationController {
            
                viewController.tabBarItem = UITabBarItem(
                    title: NSLocalizedString("Trips", comment: ""),
                    image: UIImage(named: "My_Trip"),
                    selectedImage: UIImage(named: "My_Trip_filled")
                )
            
            } else if let _ = viewController as? NotificationsNavigationController {
            
                viewController.tabBarItem = UITabBarItem(
                    title: NSLocalizedString("Notifications", comment: ""),
                    image: UIImage(named: "Notifications"),
                    selectedImage: UIImage(named: "Notifications_filled")
                )
            
            } else if let _ = viewController as? ProfileViewController {
                
                viewController.tabBarItem = UITabBarItem(
                    title: NSLocalizedString("Profile", comment: ""),
                    image: UIImage(named: "Profile"),
                    selectedImage: UIImage(named: "Profile_filled")
                )
                
            }
        }
    }
    
}


/**
*  MARK: - Hide TabBar Animation
*/
extension TabBarViewController {

    /**
    Method to animate the tab bar
    */
    func animateHideTabBar() {
        
        let animations: ()->() = {
            
            let tabBar = self.tabBar
            
            self.tabBar.frame = CGRect(
                x: tabBar.x,
                y: tabBar.y + tabBar.height,
                width: tabBar.width,
                height: tabBar.height
            )
            
        }
        UIView.animateWithDuration(self.kAnimateHideDuration, animations: animations, completion: nil)
    }

}


/// MARK: Hide the data-loading screen upon successful receipt
extension TabBarViewController {
    
    /**
    Method to hide the loading screen
    */
    func hideDataLoadingScreen() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.loadingVM.dismissLoadingView()
        self.showOnboardingOnce()
        
    }
    
    
    /**
    Method to show the onboarding VC one time
    */
    func showOnboardingOnce() {
        OnboardingViewController.SharedInstance.showOnboardingVCOnce()
        
    }
    
}
