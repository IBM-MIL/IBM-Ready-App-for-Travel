/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit
import CoreSpotlight
import MobileCoreServices

/// Go view controller responsible for starting page of application
class GoViewController: UIViewController {

    /// Container for create trip VC
    @IBOutlet weak var createTripViewControllerContainerView: UIView!
    
    /// X center constraint for Container view
    @IBOutlet weak var createTripViewControllerContainerViewCenterXConstraint: NSLayoutConstraint!

    /// Blur view
    @IBOutlet weak var blurView: UIView!
    
    /// trip view banner (At the moment anything related to the tripView is disabled)
    var tripView : TripView!
    
    /// fake trip view banner for animation (At the moment anything related to the tripView is disabled)
    var fakeTripView : TripView!
    
    /// boolean for when animation was triggered
    var animationTriggered = false
    
    /// boolean for when animation is in progress
    var animationInProgress = false
    
    //set to true to show TripView, when itinerary created
    var itinerarySeen = false
    
    /// boolean for when to setup trip view
    var tripViewsSetup = false
    
    /// boolean for if currently visible
    var isCurrentlyVisible = false
    
    /// booolean for if first load
    var isFirstLoad = true
    

    /**
    Method called upon view did load that observes the TravelDataManager sharedInstance's currentItinerary property for changes
    */
    override func viewDidLoad() {
        super.viewDidLoad()
    
        observeCurrentItinerary()
        
    }
    
    
    /**
    Method called when a we receieve a memory warning
    */
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    
    /**
    Method called upon view did appear that sets the isCurrentlyVisible property to true
    
    - parameter animated: Bool
    */
    override func viewDidAppear(animated: Bool) {
        isCurrentlyVisible = true
        
    }
    
    
    /**
    Method called upon view will disappear that sets the isCurrentlyVisible property to false
    
    - parameter animated: Bool
    */
    override func viewWillDisappear(animated: Bool) {
        isCurrentlyVisible = false
    }

    
    /**
    method called upon view will appear that resets the view if the animation was triggered and sets up the trip views and status bar color. It also sends data to Google Analytics about what view controller is currently being viewed by the user
    
    - parameter animated: Bool
    */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if animationTriggered == true {
            reset()
            animationTriggered = false
        }
        
        setupGoogleAnalyticsTracking()
        
        //If you ever wanted to show the trip view banner on the bottom, uncomment this code
        //setUpTripViews()
        
        setStatusBarColor()
    }
    
    
    /**
    Method is called upon view will appear that sends data to Google Analytics about what view controller is currently being viewed by the user
    */
    func setupGoogleAnalyticsTracking(){
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Buy passes (Home Screen)")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    
    
    /**
    Method to observe the current itinerary producer
    */
    func observeCurrentItinerary(){
        
        TravelDataManager.SharedInstance.currentItinerary.producer
        .start({
        $0
            if(self.isFirstLoad == false){
                self.segueToTripDetailViewController()
            }
            
        })
    }
    
    
    /**
    Method to segue to the trip detail VC
    */
    func segueToTripDetailViewController(){
        
        if(isCurrentlyVisible == true){
            let tripDetailViewController = Utils.vcWithNameFromStoryboardWithName("TripDetailViewController", storyboardName: "MyTrips") as! TripDetailViewController
        
            self.navigationController?.pushViewController(tripDetailViewController, animated: true)
        }
 
    }
    
    
    /**
    Method to create a tripview (At the moment anything related to the tripView is disabled)
    
    - returns: TripView object
    */
    private func createTripView() -> TripView {
        
        let newTripView = TripView.instanceFromNib()
        
        newTripView.frame = getTripViewFrame()
        newTripView.setText()
        newTripView.setupTripDurationDateLabel()
        newTripView.setUpView()
        
        return newTripView
        
    }
    
    
    /**
    Method to setup the tripView (At the moment anything related to the tripView is disabled)
    */
    private func setUpTripViews() {
        
        //show trip view if itinerary has been created
        if itinerarySeen && tripViewsSetup == false {
            tripViewsSetup = true
            
            tripView = createTripView()
            tripView.button.addTarget(self, action: Selector("tripButtonAction"), forControlEvents: .TouchUpInside)
            
            fakeTripView = createTripView()
            
            view.addSubview(tripView)
            view.insertSubview(fakeTripView, belowSubview: tripView)
            MQALogger.log("Finished setting up trip views")
            
        }
    }
    
    
    /**
    Set status bar color
    */
    private func setStatusBarColor() {
        StatusBarColorUtil.SetLight()
    }
    
    
   
    
    /**
    Method to get tripview's frame
    
    - returns: a CGRect of the frame
    */
    private func getTripViewFrame() -> CGRect {
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height
        let viewFrame = self.view.frame

        return CGRect(
            x: 0.0,
            y: viewFrame.height - 15.0 - tabBarHeight!,
            width: viewFrame.width,
            height: 64.0
        )
    }
    
    
    /**
    Method to reset the whole view (At the moment anything related to the tripView is disabled)
    */
    private func reset() {
        createTripViewControllerContainerViewCenterXConstraint.constant = 0.0
        resetFakeTripView()
        tripView.hidden = false
        
    }
    
    
    /**
    Method to reset the fake trip view  (At the moment anything related to the tripView is disabled)
    */
    private func resetFakeTripView() {
        fakeTripView = createTripView()
        view.addSubview(fakeTripView)
        view.bringSubviewToFront(tripView)
    }
    
}


/** 

MARK: Button Action(s)

*/
extension GoViewController {
    
    /**
    Action that is called when the tripView is pressed (At the moment anything related to the tripView is disabled)
    */
    func tripButtonAction(){
        
        if(animationInProgress == false){
            animationInProgress = true
            animationTriggered = true
            
            let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController! as! TabBarViewController
            rootViewController.tabBar.userInteractionEnabled = false
            
            let tripDetailViewController = Utils.vcWithNameFromStoryboardWithName("TripDetailViewController", storyboardName: "MyTrips") as! TripDetailViewController
    
            let animationManager = TripDetailAnimationManager()
        
            animationManager.animateIn(self.view,
                            realViewToTop: self.tripView,
                            viewToTop: fakeTripView,
                            tripDetailViewController: tripDetailViewController,
                            viewToLeft : self.createTripViewControllerContainerView,
                            viewToLeftConstraint: self.createTripViewControllerContainerViewCenterXConstraint,
                            fromViewController : self
            )
        }
        
    }
    
}



