/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit


/// Confirmation screen for rail pass purchase
class RailConfirmationViewController: UIViewController {

    /// done button
    @IBOutlet weak var doneButton: UIButton!

    /// scroll view's bottom constraint
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    /// scroll view
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// new trip popup view
    var newTripPopupView: NewTripPopupView!
    
    //constants used for the animation of showings an instance of the NewTripPopupView
    let kPopupAnimationDuration : NSTimeInterval = 0.5
    let kPopupAnimationDelayToShow : NSTimeInterval = 0
    let kPopupAnimationDelayToHide : NSTimeInterval = 0
    let kPopupAnimationSpringDamping : CGFloat = 0.7
    let kPopupAnimationSpringVelocity : CGFloat = 0
    
    /// rail confirmation view
    var confirmationView: RailConfirmationView!
    
    
    /**
    Method called when we receive a memory warning
    */
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    
    /**
    Method called upon view did load that sets up the view and the new trip popup view
    */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupView()
        setupNewTripPopupView()
        
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
        tracker.set(kGAIScreenName, value: "Rail Pass Confirmation Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }

    
    /**
    Method to setup the view
    */
    func setupView() {
        setupScrollView()
        doneButton.setTitleColor(UIColor.travelMainColor(), forState: .Normal)
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
    Method to setup the dates label
    */
    func setupDateLabel() {
        
        let date = NSDate()
        let tomorrow = NSDate.getDateForNumberDaysAfterDate(date, daysAfter: 1)
        let startDateString = NSDate.getDateStringWithDayAndMonth(tomorrow)
        let endDate = NSDate.getDateForNumberDaysAfterDate(tomorrow, daysAfter: 7)
        let endDateString = NSDate.getDateStringWithDayMonthAndYear(endDate)
        confirmationView.validDatesLabel.text = NSLocalizedString("\(startDateString) " + "- \(endDateString)", comment: "")
        
    }
    
    
    /**
    Method to setup the new trip popup view and show it
    */
    func setupNewTripPopupView() {
        
        newTripPopupView = NewTripPopupView.instanceFromNib()
        newTripPopupView.createNewTripButton.addTarget(self, action: "dismissToItinerary", forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.addTarget(self, action: "dismissToItinerary", forControlEvents: UIControlEvents.TouchUpInside) //also have done button dismiss to itinerary
        newTripPopupView.frame = CGRectMake(0, self.view.frame.height, self.view.frame.width, newTripPopupView.frame.height + 25)
        self.view.addSubview(newTripPopupView)
        
        var _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("prepareToShowPopup"), userInfo: nil, repeats: false)

        
    }
    
    /**
    Method to show the ask calendar permission
    */
    func dismissToItinerary() {
        
        askCalendarPermission()
        
    }
    
    
    /**
    Method to prepare popup animation
    */
    func prepareToShowPopup() {
        self.scrollViewBottomConstraint.constant = self.newTripPopupView.frame.height - 20
        self.view.layoutIfNeeded()
        showPopup()
    }
    
    
    /**
    Method to animate the popup
    */
    func showPopup() {
        
        UIView.animateWithDuration(kPopupAnimationDuration, delay: kPopupAnimationDelayToShow, usingSpringWithDamping: kPopupAnimationSpringDamping, initialSpringVelocity: kPopupAnimationSpringVelocity, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.newTripPopupView.frame = CGRectMake(0, self.view.frame.height - self.newTripPopupView.frame.height + 10, self.view.frame.width, self.newTripPopupView.frame.height)
            if (UIScreen.mainScreen().nativeBounds.size.height <= 1136) { //scroll to bottom if iphone 5/5s size
                self.scrollView.setContentOffset(CGPoint(x: 0, y: 175), animated: false)
                
            } else if (UIScreen.mainScreen().nativeBounds.size.height <= 1334) { //scroll a little if iphone 6
                self.scrollView.setContentOffset(CGPoint(x: 0, y: 85), animated: false)
                
            } else { //iphone 6+
                self.scrollView.setContentOffset(CGPoint(x: 0, y: 20), animated: false)
                
            }
        
            }, completion: { _ in
                
        })
        
    }
    
    
    /**
    Method to hide the popup
    */
    func hidePopup() {
        UIView.animateWithDuration(kPopupAnimationDuration, delay: kPopupAnimationDelayToHide, usingSpringWithDamping: 1.0, initialSpringVelocity: kPopupAnimationSpringVelocity, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.newTripPopupView.frame = CGRectMake(0, self.view.frame.height + 25, self.view.frame.width, self.newTripPopupView.frame.height)
            }, completion: { _ in
                
        })
    }
    
    
    /**
    Method to show the ask calendar permission alert
    */
    func askCalendarPermission() {
        
        let alert = UIAlertController(title: nil, message: NSLocalizedString("\"RA Travel\" Would Like to Access Your Calendar", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Don't Allow", comment: ""), style: .Default, handler: { (action: UIAlertAction!) in
            self.startLoading()
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default, handler: { (action: UIAlertAction!) in
            self.startLoading()
        }))
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    /**
    Method to show the loading view
    */
    func startLoading() {
        switchItineraryToAddHotel()
     
        //show loading view
        LoadingViewManager.SharedInstance.showLoadingViewforSecondsWithText(2.5, title: NSLocalizedString("Loading trip itinerary.\n", comment: ""), callbackMethod: loadingDone)
    }
    
    
    
    /**
    Method to switch itinerary index
    */
    func switchItineraryToAddHotel(){
        let itineraryIndex = TravelDataManager.SharedInstance.getBeginningItineraryIndex()
        TravelDataManager.SharedInstance.setItinerary(itineraryIndex)
    }
    

    /**
    Method to push to trip detail vc
    */
    func loadingDone() {
        //go to trip detail
        let tripDetailViewController = Utils.vcWithNameFromStoryboardWithName("TripDetailViewController", storyboardName: "MyTrips") as! TripDetailViewController
        self.navigationController?.pushViewController(tripDetailViewController, animated: true)
    }
    
}
