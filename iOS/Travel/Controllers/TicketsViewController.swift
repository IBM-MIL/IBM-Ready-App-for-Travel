/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

/// Passes modal popup VC on trips tab
class TicketsViewController: UIViewController {

    /// Done button
    @IBOutlet weak var doneButton: UIButton!

    /// Scroll view
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// confirmation view
    var confirmationView: RailConfirmationView!
    
    /**
    Method called when we receive a memory wanring
    */
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    
    /**
    method called upon view did load that sets up the view
    */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupView()
        
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
        tracker.set(kGAIScreenName, value: "Passes Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    

    /**
    Method to setup the view
    */
    func setupView() {

        doneButton.setTitleColor(UIColor.travelMainColor(), forState: .Normal)
        
        setupScrollView()
        
    }
    
    
    /**
    Method to setup the scroll view
    */
    func setupScrollView() {
        confirmationView = RailConfirmationView.instanceFromNib()
        confirmationView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: confirmationView.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width, height: confirmationView.frame.height)
        scrollView.addSubview(confirmationView)
        
        setupDateLabel()
        
    }
    
    
    /**
    Method to setup the date label
    */
    func setupDateLabel() {
        
        confirmationView.setupValidDatesLabel()
        
    }
    
    
    /**
    Method to dismiss the view
    */
    func dismissView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }

}
