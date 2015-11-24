/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

/// Second screen in rail purchase flow with detail of rail pass
class RailSelectionViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    /// Dates and duration of pass
    @IBOutlet weak var durationDatesLabel: UILabel!
    
    /// Nav bar view
    @IBOutlet weak var navigationBarView: UIView!
    
    /// purchase pass button
    @IBOutlet weak var purchaseButton: UIButton!
    
    /// loading view
    var loadingView: LoadingView!

    /**
    Method called when we receieve a memory warning
    */
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    
    /**
    Method called upon view did load that sets up the view
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
        tracker.set(kGAIScreenName, value: "Rail Pass Selection Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    
    
    /**
    Method to setup the view
    */
    private func setupView() {
        
        setupDateLabel()
        purchaseButton.addTarget(self, action: Selector("purchasePassNow"), forControlEvents: UIControlEvents.TouchUpInside)
        
        backButton.setTitleColor(UIColor.travelMainColor(), forState: .Normal)
        purchaseButton.backgroundColor = UIColor.travelMainColor()
    }
    
    
    /**
    Method to set up the date label
    */
    func setupDateLabel() {
        
        let date = NSDate()
        let tomorrow = NSDate.getDateForNumberDaysAfterDate(date, daysAfter: 1)
        let startDateString = NSDate.getDateStringWithDayAndMonth(tomorrow)
        let endDate = NSDate.getDateForNumberDaysAfterDate(tomorrow, daysAfter: 7)
        let endDateString = NSDate.getDateStringWithDayMonthAndYear(endDate)
        durationDatesLabel.text = NSLocalizedString("\(startDateString) " + "- \(endDateString)", comment: "")
        
    }
    
    
    /**
    Action triggered to pop the navVC when back button tapped
    
    - parameter sender: sender of the action
    */
    @IBAction func tappedBackButton(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    /**
    Method to start the loading screen when purchase pass button tapped
    */
    func purchasePassNow() {
        
        startLoading()  
    }
    
    
    /**
    Method to start loading animation
    */
    func startLoading() {
        //show loading view
        LoadingViewManager.SharedInstance.showLoadingViewforSecondsWithText(2.5, title: NSLocalizedString("Please wait while your\npass is being purchased.", comment: ""), callbackMethod: loadingDone)
    }
    
    
    /**
    Method to push to next VC when loading done
    */
    func loadingDone() {
        performSegueWithIdentifier("toConfirmation", sender: self)
    }
    


}


    

