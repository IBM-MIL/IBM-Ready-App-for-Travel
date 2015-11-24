/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit
import MapKit


/// Event detail VC
class EventDetailViewController: UIViewController {
    
    /// ignore button
    @IBOutlet weak var ignoreButton: UIButton!
    
    /// view recs button
    @IBOutlet weak var viewRecommendationsButton: UIButton!
    
    /// back button
    @IBOutlet weak var backButton: UIButton!
    
    /// map view
    @IBOutlet weak var mapView: MKMapView!
    
    /// nav bar label
    @IBOutlet weak var navigationBarSubTitleLabel: UILabel!
    
    /// scroll view
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// scroll view content view
    @IBOutlet weak var scrollViewContentView: UIView!
    
    /// weather alert banner
    @IBOutlet weak var weatherAlertBanner: UIView!
    
    /// event detail holder view
    @IBOutlet weak var eventDetailHolderView: UIView!
    
    /// banner top space
    @IBOutlet weak var weatherAlertBannerTopSpaceConstraint: NSLayoutConstraint!
    
    /// banner height
    @IBOutlet weak var weatherAlertBannerHeightConstraint: NSLayoutConstraint!
    
    /// transportation detail holder
    @IBOutlet weak var transportationDetailHolderView: UIView!
    
    /// open in app pass view
    @IBOutlet weak var openInAppRailPassView: UIView!
    
    /// open in app pass button
    @IBOutlet weak var openInAppRailPassButton: UIButton!
    
    /// weather alert body text label
    @IBOutlet weak var weatherAlertBodyTextLabel: UILabel!
    
    /// view model
    var viewModel: EventDetailViewModel!
    
    /// meeting detail view
    weak var meetingDetailView: MeetingDetailView!
    
    /// hotel detail view
    weak var hotelDetailView: HotelDetailView!
    
    /// transportation detail view
    weak var transportationDetailView: RecommendedTransportationDetailView!
    
    /// constants used to animate and display the weather alert
    let kWeatherAlertAnimationDelay : NSTimeInterval = 1.0
    let kWeatherAlertAnimationDuration : NSTimeInterval = 0.5
    let kWeatherAlertAnimationSpringDamping : CGFloat = 0.8
    let kWeatherAlertAnimationSpringVelocity : CGFloat = 0
    
    /// constant height for weather alert if the last vc the user was at was the notificaiotn vc
    let kWeatherAlertHeightForCameFromNotificationsViewController : CGFloat = 100
    
    /// boolean for if it is coming from rec detail view
    var isFromRecommendationDetail = false
    
    /// boolean for if came from notifications vc
    var cameFromNotifcationsViewController = false
    
    
    /**
    Method called when we receive a memory warning
    */
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    
    /**
    Method called upon view did load that sets up the view, navigation title, status bar, map, and view depending on the type of event
    */
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.mapView.delegate = self
        
        setupView()
        setupNavigationBarTitle()
        setupMap()

        setupEventDetailDependingOnTypeOfEvent()
        
    }
    
    
    /**
    Method is called upon view will appear that sends data to Google Analytics about what view controller is currently being viewed by the user. It also sets up the back button title and status bar color
    
    - parameter animated: Bool
    */
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        setupBackButtonTitle()
        
        setupStatusBar()
        
        setupGoogleAnalyticsTracking()
        
    }
    
    
    /**
    Method that is called upon view did appear which shows the weather alert banner if the event is affect by bad weather or came from the notifications view controller
    
    - parameter animated: Bool
    */
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if(viewModel.isEventAffectedByBadWeather() == true || cameFromNotifcationsViewController == true){
            showWeatherAlertBanner()
        }
    }
    
    
    /**
    Method is called upon view will appear that sends data to Google Analytics about what view controller is currently being viewed by the user
    */
    func setupGoogleAnalyticsTracking(){
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Event Detail Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    
    
    /**
    Method to prepare alert if coming from notifications vc
    */
    func prepWeatherAlertIfComingFromNotifcationsViewController(){
        if(cameFromNotifcationsViewController == true){
            viewRecommendationsButton.hidden = true
            ignoreButton.hidden = true
            
            weatherAlertBannerHeightConstraint.constant = kWeatherAlertHeightForCameFromNotificationsViewController
        
        }
    }
    
    
    /**
    Method to setup event detail based on event type
    */
    func setupEventDetailDependingOnTypeOfEvent(){
        
        if(viewModel.getEventSubType() == viewModel.kRestaurantSubType){
            setupHolderViewWithMeeting()
            setUpWeatherAlertBanner()
        }
        else if(viewModel.getEventSubType() == viewModel.kLodgingSubType){
            setupHolderViewWithHotel()
            hideWeatherAlertBanner()
        }
        else if(viewModel.getEventSubType() == viewModel.kTransitSubType){
            setupHolderViewWithTransportation()
            hideWeatherAlertBanner()
        }
    }
    
    
    /**
    Method to setup status bar
    */
    func setupStatusBar() {
        StatusBarColorUtil.SetDark()
        
    }
    
    
    /**
    Method to setup the view
    */
    func setupView() {
        self.backButton.addTarget(self, action: Selector("backButtonAction"), forControlEvents: .TouchUpInside)
        self.viewRecommendationsButton.addTarget(self, action: Selector("viewRecommendationsAction"), forControlEvents: .TouchUpInside)
        self.ignoreButton.addTarget(self, action: Selector("animateHideWeatherAlertBanner"), forControlEvents: .TouchUpInside)
        self.openInAppRailPassButton.addTarget(self, action: Selector("openInAppRailPassAction"), forControlEvents: .TouchUpInside)
        
        backButton.setTitleColor(UIColor.travelMainColor(), forState: .Normal)
        
        viewRecommendationsButton.setTitleColor(UIColor.travelMainColor(), forState: .Normal)
        ignoreButton.setTitleColor(UIColor.travelMainColor(), forState: .Normal)
    }
    
    
    /**
    Action for when back button is tapped
    */
    func backButtonAction(){
        
        if(isFromRecommendationDetail == true){
            goToItinerary()
        }
        else{
            self.navigationController!.popViewControllerAnimated(true)
        }
    }
    
    
    /**
    Action to go to the itinerary trip detail vc
    */
    func goToItinerary() {
        for vc in self.navigationController!.viewControllers {
            if let itineraryVC = vc as? TripDetailViewController {
                
                itineraryVC.comingFromRecommendedDetail = true
                self.navigationController!.popToViewController(itineraryVC, animated: true)
                break
            }
        }
    }
    
    
    /**
    Method to setup the holder with meeting view
    */
    func setupHolderViewWithMeeting() {
        transportationDetailHolderView.hidden = true
        openInAppRailPassView.hidden = true
        
        meetingDetailView = MeetingDetailView.instanceFromNib()
        eventDetailHolderView.frame = CGRectMake(eventDetailHolderView.x, eventDetailHolderView.y, meetingDetailView.frame.width, meetingDetailView.frame.height)
        eventDetailHolderView.addSubview(meetingDetailView)
        
        viewModel.setupMeetingDetailViewWithData(meetingDetailView)
        
    }
    
    
    /**
    Method to setup the holder with hotel view
    */
    func setupHolderViewWithHotel() {
        transportationDetailHolderView.hidden = true
        openInAppRailPassView.hidden = true
        
        hotelDetailView = HotelDetailView.instanceFromNib()
        eventDetailHolderView.frame = CGRectMake(eventDetailHolderView.x, eventDetailHolderView.y, hotelDetailView.frame.width, hotelDetailView.frame.height)
        eventDetailHolderView.addSubview(hotelDetailView)
        
        viewModel.setupHotelDetailViewWithData(hotelDetailView)
        
    }
    
    
    /**
    Method to setup the holder with transportation view
    */
    func setupHolderViewWithTransportation() {
        transportationDetailHolderView.hidden = false
        openInAppRailPassView.hidden = true
        
        transportationDetailView = RecommendedTransportationDetailView.instanceFromNib()
        transportationDetailHolderView.frame = CGRectMake(0, 0, transportationDetailView.frame.width, transportationDetailView.frame.height)
        transportationDetailHolderView.backgroundColor = UIColor.blueColor()
        transportationDetailHolderView.addSubview(transportationDetailView)
        viewModel.setUpRecommendedTransportationDetailView(transportationDetailView)
        
        setUpTableView()
    }
    
    
    /**
    Method to setup nav bar title
    */
    func setupNavigationBarTitle(){

        navigationBarSubTitleLabel.text = viewModel.getNavigationBarDateString()
        
    }
    
    
    /**
    Method to setup back button title
    */
    func setupBackButtonTitle(){
        
        if(isFromRecommendationDetail == true){
            backButton.setTitle(NSLocalizedString("   Berlin", comment: ""), forState:.Normal)
        }
    }
    
    
    /**
    Method to setup table view
    */
    func setUpTableView(){
        
        transportationDetailView.tableView.delegate = self
        transportationDetailView.tableView.dataSource = self
        
        Utils.registerNibWithTableView("transportationDetail", nibName: "RecommendedTransportationDetailTableViewCell", tableView: transportationDetailView.tableView)
        
        transportationDetailView.tableView.estimatedRowHeight = 134.0
        transportationDetailView.tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    
    /**
    Method to view the recommendations after loading
    */
    func viewRecommendationsAction() {
        LoadingViewManager.SharedInstance.showLoadingViewforSecondsWithText(2.5, title: NSLocalizedString("Formulating Watson\nrecommendations.", comment: ""), callbackMethod: goToInclementRecommendations)
    }
    
    
    /**
    Method to push to next vc to show recommendations
    */
    func goToInclementRecommendations() {
        performSegueWithIdentifier("inclementRecommendations", sender: self)
        
    }
    
    
    /**
    Method to open the in app rail pass
    */
    func openInAppRailPassAction() {
        
        
    }
    
    
    /**
    Method to setup the weather alert banner
    */
    func setUpWeatherAlertBanner(){
        
        weatherAlertBanner.hidden = true
        
        if(cameFromNotifcationsViewController == true){
            viewRecommendationsButton.hidden = true
            ignoreButton.hidden = true
        
            weatherAlertBannerHeightConstraint.constant = kWeatherAlertHeightForCameFromNotificationsViewController
            let difference = weatherAlertBanner.frame.size.height - kWeatherAlertHeightForCameFromNotificationsViewController
            weatherAlertBannerTopSpaceConstraint.constant = -(weatherAlertBanner.frame.size.height - mapView.frame.size.height - difference)
        }
        else{
            weatherAlertBannerTopSpaceConstraint.constant = -(weatherAlertBanner.frame.size.height - mapView.frame.size.height)
        }
    
        weatherAlertBanner.backgroundColor = UIColor(hex: "fed4d3")
        
    }
    
    
    /**
    Method to present the weather alert banner
    */
    func showWeatherAlertBanner(){
        
        weatherAlertBanner.hidden = false
        
        UIView.animateWithDuration(kWeatherAlertAnimationDuration, delay: kWeatherAlertAnimationDelay, usingSpringWithDamping: kWeatherAlertAnimationSpringDamping, initialSpringVelocity: kWeatherAlertAnimationSpringVelocity, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.weatherAlertBannerTopSpaceConstraint.constant = 90
            
            self.view.layoutIfNeeded()
            
            }, completion: { _ in
           
        })
        
    }
    
    
    /**
    Method to animate hiding the weather alert banner
    */
    func animateHideWeatherAlertBanner(){
            
            UIView.animateWithDuration(kWeatherAlertAnimationDuration, delay: 0.0, usingSpringWithDamping: kWeatherAlertAnimationSpringDamping, initialSpringVelocity: kWeatherAlertAnimationSpringVelocity, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                self.weatherAlertBannerTopSpaceConstraint.constant = -(self.weatherAlertBanner.frame.size.height - self.mapView.frame.size.height)
                
                self.view.layoutIfNeeded()
                
                }, completion: { _ in
                    self.weatherAlertBanner.hidden = true
            })
    }
    
    
    /**
    Method to hide the weather banner
    */
    func hideWeatherAlertBanner(){
        
        weatherAlertBannerTopSpaceConstraint.constant = -(weatherAlertBanner.frame.size.height - mapView.frame.size.height)
        weatherAlertBanner.hidden = true
    }
    
    
    /**
    Method to setup the map based on coordinates
    */
    func setupMap(){
        
        let latDelta : CLLocationDegrees = 0.005
        let longDelta : CLLocationDegrees = 0.005
        
        let coordinates = viewModel.getMapViewCLLocationCoordinate2D()

        if let coor = coordinates {
            var region = MKCoordinateRegion()
            var span = MKCoordinateSpan()
        
            span.latitudeDelta = latDelta
            span.longitudeDelta = longDelta
        
            region.span = span
            region.center = coor
        
            mapView.setRegion(region, animated: true)
            //mapView.mapType = MKMapType.Hybrid
            
            let pin = MKPointAnnotation()
            pin.coordinate = coor
            mapView.addAnnotation(pin)
        }
    }
    
    /**
    Method that prepares the recommendations VC viewModel right before it segues to the recommendations VC
    
    - parameter segue:  UIStoryboardSegue
    - parameter sender: AnyObject?
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if(segue.identifier == "inclementRecommendations"){
            
            let recommendationsViewController = segue.destinationViewController as! RecommendationsViewController
            
            recommendationsViewController.viewModel = viewModel.getInclimentWeatherRecommendations()
            
        }
    }
   
}


/**

MARK: UITableViewDelegate

*/
extension EventDetailViewController: UITableViewDelegate {
    
    
    /**
    Method that defines the action taken when a row is selected in the tableView, in this case we unhighlight the cell from selection
    
    - parameter tableView: UITableView
    - parameter indexPath: NSIndexPath
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.transportationDetailView.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}


/**

MARK: UITableViewDataSource

*/
extension EventDetailViewController: UITableViewDataSource {
    
    /**
    Method that returns the number of section in the table view by asking the view model for this Int
    
    - parameter tableView: UITableView
    
    - returns: Int
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.numberOfSectionsInTableView()
    }
    
    /**
    Method that returns the number of rows in section by asking the view model for this Int
    
    - parameter tableView: UITableView
    - parameter section:   Int
    
    - returns: Int
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    
    /**
    Method that returns the cell for row at indexPath by asking the view model to set up this cell
    
    - parameter tableView: UITableView
    - parameter indexPath: NSIndexPath
    
    - returns: UITableViewCell
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return viewModel.setUpTableViewCell(indexPath, tableView: tableView)
    }
    
}

// MARK: - MKMapViewDelegate
extension EventDetailViewController: MKMapViewDelegate {

    /**
    Method that returns the view for the map pin, here we make the map pin a special color
    
    - parameter mapView:    mapView
    - parameter annotation: MKAnnotation
    
    - returns: MKAnnotationView?
    */
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let pinView = MKPinAnnotationView()
        pinView.pinTintColor = UIColor.travelMainColor()
        return pinView
    }

}
