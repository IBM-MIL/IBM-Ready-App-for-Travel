/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import Foundation

/// MyTrips tab
class MyTripsViewController: UIViewController {

    /// Nav bar for Viewcontroller
    @IBOutlet weak var navigationBar: UIView!
    
    /// tableView
    @IBOutlet weak var tableView: UITableView!
    
    /// tickets button
    @IBOutlet weak var ticketsButton: UIButton!
    
    /// center X constraint for tableview
    @IBOutlet weak var tableViewCenterXConstraint: NSLayoutConstraint!
    
    /// TicketsVC object
    var ticketsVC: TicketsViewController!
    
    /// view model for the trips tab
    var viewModel : MyTripsViewModel!
    
    /// tableview cell height
    let kTableViewCelHeight : CGFloat = 196
    
    /// fake TripView object
    var fakeTripView : TripView!
    
    
    /**
    Method that is called when view did load. Specifically sets up the view model, some view background colors, and adds a target to the tickets button
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MyTripsViewModel()
        setupTableView()
        
        self.view.backgroundColor = UIColor.travelItineraryCellBackgroundColor()
        self.tableView.backgroundColor = UIColor.travelItineraryCellBackgroundColor()
        ticketsButton.setTitleColor(UIColor.travelMainColor(), forState: .Normal)
        
        self.ticketsButton.addTarget(self, action: "showTicketVC", forControlEvents: .TouchUpInside)
        
    }
    
    
    /**
    Method that is called when view will appear. Specificlly sets up the status bar color and resets the view from the custom animation segue that moved some of the views off screen in the process. It also sends data to Google Analytics about what view controller is currently being viewed by the user
    
    - parameter animated:
    */
    override func viewWillAppear(animated: Bool) {
         //setupStatusBar()
         reset()
        
        setupGoogleAnalyticsTracking()
        
        setupStatusBar()
    }
    
    
    /**
    Method is called upon view will appear that sends data to Google Analytics about what view controller is currently being viewed by the user
    */
    func setupGoogleAnalyticsTracking(){
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "My Trips Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    
    /**
    Method to show the passes VC
    */
    func showTicketVC() {
        self.ticketsVC = Utils.vcWithNameFromStoryboardWithName("ticket", storyboardName: "MyTrips") as! TicketsViewController
        
        self.presentViewController(self.ticketsVC, animated: true, completion: { _ in
            self.ticketsVC.doneButton.addTarget(self, action: "hideTicketVC", forControlEvents: .TouchUpInside)
            
        })
    }
    
    
    /**
    Method to hide the passes VC
    */
    func hideTicketVC() {
        self.ticketsVC.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    /**
    Setup the status bar color
    */
    func setupStatusBar() {
        StatusBarColorUtil.SetDark()
        
    }
    
    
    /**
    Method to create a new tripView instance
    
    - parameter frame: frame to create (CGRect)
    
    - returns: TripView object
    */
    private func createTripView(frame : CGRect) -> TripView {
        
        let newTripView = TripView.instanceFromNib()
        
        newTripView.frame = frame
        newTripView.setText()
        newTripView.setupTripDurationDateLabel()
        newTripView.setUpView()
        
        return newTripView
        
    }
    
    
    /**
    Setup the tableview style
    */
    func setupTableView(){
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        
        Utils.registerNibWithTableView("MyTripsTableViewCell", nibName: "MyTripsTableViewCell", tableView: tableView)
        
    }
    
    
    /**
    Setup the TripView for a certain indexPath
    
    - parameter indexPath: indexPath of cell to setup
    */
    func setUpTripViewsForIndexPath(indexPath : NSIndexPath){
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MyTripsTableViewCell
        
        cell.tripView.hidden = true
        cell.contentView.backgroundColor = UIColor.travelItineraryCellBackgroundColor()
        
        self.fakeTripView = createTripView(CGRect(x: 0, y: Utils.convertViewOriginToRootViewControllersView(cell).y, width: cell.frame.size.width, height: cell.frame.size.height))
        
        Utils.rootViewController().view.addSubview(fakeTripView)

    }
    
    
    /**
    Method to reset tableView
    */
    func reset(){
        
        tableView.reloadData()
        tableViewCenterXConstraint.constant = 0.0
        
    }
    
}

// MARK: - UITableViewDelegate
extension MyTripsViewController: UITableViewDelegate {
    
    /**
    Method defines the action that is taken when a table view cell is selected, in this case it makes a custom segue animation to the trip detail view controller
    
    - parameter tableView: UITableView
    - parameter indexPath: NSIndexPath
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == 0){
            
            let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController! as! TabBarViewController
            
            rootViewController.tabBar.userInteractionEnabled = false

            let tripDetailViewController = Utils.vcWithNameFromStoryboardWithName("TripDetailViewController", storyboardName: "MyTrips") as! TripDetailViewController
        
            setUpTripViewsForIndexPath(indexPath)
        
            let animationManager = TripDetailAnimationManager()
        
            animationManager.animateIn(self.view,
                realViewToTop: nil,
                viewToTop: fakeTripView,
                tripDetailViewController: tripDetailViewController,
                viewToLeft : self.tableView,
                viewToLeftConstraint: self.tableViewCenterXConstraint,
                fromViewController : self
        )
            
        }
        else {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }
    }

}

// MARK: - UITableViewDataSource
extension MyTripsViewController: UITableViewDataSource {
    
    /**
    Method returns the number of sections in the tableview by asking the viewModel for this Int
    
    - parameter tableView: UITableView
    
    - returns: Int
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.numberOfSectionsInTableView()
    }
    
    
    /**
    Method returns the number of rows in section by asking the viewModel for this Int
    
    - parameter tableView: UITableView
    - parameter section:   Int
    
    - returns: Int
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    
    /**
    Method returns the cell for row at indexPath by asking the viewModel to set up this cell
    
    - parameter tableView: UITableView
    - parameter indexPath: NSIndexPath
    
    - returns: UITableViewCell
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return viewModel.setUpTableViewCell(indexPath, tableView: tableView)
    }
    
    
    /**
    Method returns the height for row at index path which is defined by the kTableViewCellHeight constant property
    
    - parameter tableView: <#tableView description#>
    - parameter indexPath: <#indexPath description#>
    
    - returns: <#return value description#>
    */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kTableViewCelHeight
    }
    
    
    
}
