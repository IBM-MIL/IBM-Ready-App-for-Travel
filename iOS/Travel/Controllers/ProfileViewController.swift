/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import Foundation

class ProfileViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIButton!
    
    
    /**
    Method is called upon view did appear and sets up the stauts bar color
    
    - parameter animated: Bool
    */
    override func viewDidAppear(animated: Bool) {
        setupStatusBar()
        
        signOutButton.setTitleColor(UIColor.travelMainColor(), forState: .Normal)
    }
    
    
    /**
    Method is called upon view will appear that sends data to Google Analytics about what view controller is currently being viewed by the user
    
    - parameter animated: Bool
    */
    override func viewWillAppear(animated: Bool) {
        setupGoogleAnalyticsTracking()
    }
    
    
    /**
    Method is called upon view will appear that sends data to Google Analytics about what view controller is currently being viewed by the user
    */
    func setupGoogleAnalyticsTracking(){
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "User Profile Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    
    
    
    
    /**
    Method to setup status bar
    */
    func setupStatusBar() {
        StatusBarColorUtil.SetDark()
        
    }
    
}
