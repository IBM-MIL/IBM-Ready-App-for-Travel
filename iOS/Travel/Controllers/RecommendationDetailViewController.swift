/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit
import MapKit

/// Recommendation detail VC
class RecommendationDetailViewController: UIViewController {
    
    /// Back button
    @IBOutlet weak var backButton: UIButton!
    
    /// mapview
    @IBOutlet weak var mapView: MKMapView!
    
    /// event detail holder view
    @IBOutlet weak var eventDetailHolderView: UIView!
    
    /// transportation detail holder view
    @IBOutlet weak var transportationDetailHolderView: UIView!
    
    /// scroll view content view
    @IBOutlet weak var scrollViewContentView: UIView!
    
    /// bottom button
    @IBOutlet weak var bottomButton: UIButton!
    
    /// nav bar title label
    @IBOutlet weak var navigationBarTitleLabel: UILabel!
    
    /// view model
    var viewModel: RecommendationDetailViewModel!
    
    /// restaurant detail view
    weak var restaurantDetailView: RecommendedRestaurantDetailView!
    
    /// hotel detail view
    weak var hotelDetailView: RecommendedHotelDetailView!
    
    /// transportation detail view
    weak var transportationDetailView: RecommendedTransportationDetailView!
    
    /// loading view
    weak var loadingView: LoadingView!

    /// identifier used when we perform segue's to the event detail VC
    let kEventDetailSegueIdentifier = "eventDetail"
    
    
    /**
    Method called when we receive a memory warning
    */
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    
    /**
    Method called upon view did load that sets up the mapView delegate, status bar, view, holderView, and map
    */
    override func viewDidLoad() {

        super.viewDidLoad()

        self.mapView.delegate = self
        setupStatusBar()
        setupView()
        setUpHolderViewBasedOnSubType()
        setupMap()

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
        tracker.set(kGAIScreenName, value: "Recommendation Detail Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
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
        self.bottomButton.addTarget(self, action: Selector("showItineraryAction"), forControlEvents: .TouchUpInside)
        bottomButton.backgroundColor = UIColor.travelMainColor()
        backButton.setTitleColor(UIColor.travelMainColor(), forState: .Normal)

    }
    
    /**
    Method to pop the navVC when back button tapped
    */
    func backButtonAction(){

        self.navigationController!.popViewControllerAnimated(true)

    }
    
    /**
    Method to setup holder view based on the subtype
    */
    func setUpHolderViewBasedOnSubType(){
        
        let recommendedSubType = viewModel.getRecommendedSubType()
        
        if(recommendedSubType == viewModel.kLodgingSubType){
            setupHolderViewWithHotel()
        }
        else if (recommendedSubType == viewModel.kRestaurantSubType){
            setupHolderViewWithRestaurant()
        }
        else if ( recommendedSubType == viewModel.kTransitSubType){
            setupHolderViewWithTransportation()
        }
        
    }
    
    
    /**
    Method to setup the holder view with restaurant details
    */
    func setupHolderViewWithRestaurant() {
        transportationDetailHolderView.hidden = true
        navigationBarTitleLabel.text = viewModel.getNavigationBarTitle()
        bottomButton.setTitle(viewModel.getBottomButtonTitle(), forState: .Normal)
        restaurantDetailView = RecommendedRestaurantDetailView.instanceFromNib()
        viewModel.setUpRecommendedRestaurantDetailView(restaurantDetailView)
        eventDetailHolderView.frame = CGRectMake(eventDetailHolderView.x, eventDetailHolderView.y, restaurantDetailView.frame.width, restaurantDetailView.frame.height)
        eventDetailHolderView.addSubview(restaurantDetailView)
    }
    
    
    /**
    Method to setup the holder view with hotel details
    */
    func setupHolderViewWithHotel() {
        transportationDetailHolderView.hidden = true
        navigationBarTitleLabel.text = viewModel.getNavigationBarTitle()
        bottomButton.setTitle(viewModel.getBottomButtonTitle(), forState: .Normal)
        
        hotelDetailView = RecommendedHotelDetailView.instanceFromNib()
        viewModel.setUpRecommendedHotelDetailView(hotelDetailView)
        eventDetailHolderView.frame = CGRectMake(eventDetailHolderView.x, eventDetailHolderView.y, hotelDetailView.frame.width, hotelDetailView.frame.height)
        eventDetailHolderView.addSubview(hotelDetailView)
    }
    
    
    /**
    Method to setup the holder view with tranportation details
    */
    func setupHolderViewWithTransportation() {
        transportationDetailHolderView.hidden = false
        navigationBarTitleLabel.text = viewModel.kTransitNavigationBarTitle
        bottomButton.setTitle(viewModel.kTransitBottomButtonTitle, forState: .Normal)
        transportationDetailView = RecommendedTransportationDetailView.instanceFromNib()
        viewModel.setUpRecommendedTransportationDetailView(transportationDetailView)
        transportationDetailHolderView.frame = CGRectMake(transportationDetailHolderView.x, transportationDetailHolderView.y, transportationDetailView.frame.width, transportationDetailView.frame.height)
        transportationDetailHolderView.addSubview(transportationDetailView)
        
        setUpTransportationTableView()
        
    }
    
    /**
    Method to setup the transportation table view
    */
    func setUpTransportationTableView(){
        
        transportationDetailView.tableView.delegate = self
        transportationDetailView.tableView.dataSource = self
        
        Utils.registerNibWithTableView("transportationDetail", nibName: "RecommendedTransportationDetailTableViewCell", tableView: transportationDetailView.tableView)
        
        transportationDetailView.tableView.estimatedRowHeight = 134.0
        transportationDetailView.tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    
    /**
    Method to show the itinerary after loading
    */
    func showItineraryAction() {
        
        if(viewModel.getRecommendedSubType() == viewModel.kLodgingSubType){
            //show loading view
            LoadingViewManager.SharedInstance.showLoadingViewforSecondsWithText(2.5, title: NSLocalizedString("Please wait while your hotel is being booked.", comment: ""), callbackMethod: goToItinerary)
        }
        else if(viewModel.getRecommendedSubType() == viewModel.kTransitSubType){
            //show loading view
            LoadingViewManager.SharedInstance.showLoadingViewforSecondsWithText(2.5, title: NSLocalizedString("Please wait while your arrangements are made.", comment: ""), callbackMethod: goToItinerary)
        }
        else if(viewModel.getRecommendedSubType() == viewModel.kRestaurantSubType){
            goToItinerary()
        }
    }
    
    
    /**
    Method to go to the itinerary page
    */
    func goToItinerary() {
        for vc in self.navigationController!.viewControllers {
            if let itineraryVC = vc as? TripDetailViewController {
                itineraryVC.comingFromRecommendedDetail = true
                self.navigationController!.popToViewController(itineraryVC, animated: true)
                break
            }
        }
        viewModel.switchItineraryOnBottomButtonAction()
    }
    
    
    /**
    Method to go to the event detail page
    */
    func goToEventDetail(){
        viewModel.switchItineraryOnBottomButtonAction()
        self.performSegueWithIdentifier(kEventDetailSegueIdentifier, sender: self)
    }
    
    
    /**
    Method to setup the map view based on coordinates
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
            
            let pin = MKPointAnnotation()
            pin.coordinate = coor
            mapView.addAnnotation(pin)
        }
    }

}



/**

MARK: UITableViewDelegate

*/
extension RecommendationDetailViewController: UITableViewDelegate {
    
    /**
    Method that defines the action taken when a cell in the table view is selected
    
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
extension RecommendationDetailViewController: UITableViewDataSource {
    
    
    /**
    Method that returns the number of seciton in the table view by asking the view model for this Int
    
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
    Method that returns the cell for row at index path by asking the view model to set up this cell
    
    - parameter tableView: UITableView
    - parameter indexPath: NSIndexPath
    
    - returns: UITableViewCell
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return viewModel.setUpTableViewCell(indexPath, tableView: tableView)
        
    }
    
}



/** 

MARK: MKMapViewDelegate

*/
extension RecommendationDetailViewController: MKMapViewDelegate {

    /**
    Method that returns a custom view for the map pin, in this case we set it to a custom color
    
    - parameter mapView:    MKMapView
    - parameter annotation: MKAnnotation
    
    - returns: MKAnnotationView
    */
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let pinView = MKPinAnnotationView()
        pinView.pinTintColor = UIColor.travelMainColor()
        return pinView
    }
}
