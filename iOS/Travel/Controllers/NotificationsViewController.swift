/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import Foundation

/// Notification tab VC
class NotificationsViewController: UIViewController {
    
    /// Nav bar
    @IBOutlet weak var navigationBar: UIView!
    
    /// Title label on nav bar
    @IBOutlet weak var navigationBarTitleLabel: UILabel!
    
    /// tableView for vc
    @IBOutlet weak var tableView: UITableView!
    
    /// Bottom line view for navigation bar
    @IBOutlet weak var navigationBarBottomLine: UIView!
    
    /// tableview cell height
    let kTableViewCelHeight : CGFloat = 110
    
    /// view model
    var viewModel : NotificationsViewModel!
    
    
    /**
    Method is called when view did load. Secifically set sup the navgiationBarBottomLine background color, the tableview, and creates the viewModel
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarBottomLine.backgroundColor = UIColor.travelNotificationsVCNavigationBarBottomLineColor()
        
        viewModel = NotificationsViewModel()
        
        setUpTableView()                  
    }
    
    
    /**
    Method that is called when view did appear. Specifically is sets up the status bar and hides the notification tab badge if shown
    
    - parameter animated: Bool
    */
    override func viewDidAppear(animated: Bool) {
        setupStatusBar()
        hideNotificationTabBadgeIfShown()
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
        tracker.set(kGAIScreenName, value: "Notifications Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    
    
    /**
    Method to setup the status bar
    */
    func setupStatusBar() {
        StatusBarColorUtil.SetDark()
    }
    
    
    /**
    Method to hide the badge if shown on the tab bar icon
    */
    func hideNotificationTabBadgeIfShown() {
        let tabArray = self.tabBarController?.tabBar.items as NSArray!
        let tabItem = tabArray.objectAtIndex(2) as! UITabBarItem
        tabItem.badgeValue = nil
    }
    
    
    /**
    Method to setup the tableview
    */
    func setUpTableView(){

        tableView.delegate = self
        tableView.dataSource = self
        
        Utils.registerNibWithTableView("NotificationsTableViewCell", nibName: "NotificationsTableViewCell", tableView: tableView)
    }
}

// MARK: - UITableViewDelegate
extension NotificationsViewController: UITableViewDelegate {
    
    /**
    Method that defines that action taken when a table view cell is selected. In this case it segue's to the event detail view controller when the first cell is selected.
    
    - parameter tableView: UITableView
    - parameter indexPath: NSIndexPath
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if(indexPath.row == 0){
            let eventDetailViewController = Utils.vcWithNameFromStoryboardWithName("EventDetailViewController", storyboardName: "MyTrips") as! EventDetailViewController
            
            eventDetailViewController.viewModel = viewModel.getWeatherAlertEventViewModel()
            eventDetailViewController.cameFromNotifcationsViewController = true
            
            self.navigationController?.pushViewController(eventDetailViewController, animated: true)

        }
    }

}

// MARK: - UITableViewDataSource
extension NotificationsViewController: UITableViewDataSource {
    
    
    /**
    Method that returns the number of section in the table view by asking the viewModel for this information
    
    - parameter tableView: UITableView
    
    - returns: Int
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.numberOfSectionsInTableView()
    }
    
    
    /**
    Method that returns the number of rows in a section by asking the viewModel for this information
    
    - parameter tableView: UITableView
    - parameter section:   Int
    
    - returns: Int
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    
    /**
    Method that returns the cell for row at index path. It asks the viewModel to set of the specific cell at that indexPath
    
    - parameter tableView: UITableView
    - parameter indexPath: NSIndexPath
    
    - returns: UITableViewCell
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return viewModel.setUpTableViewCell(indexPath, tableView: tableView)
    }
    
    
    /**
    Method that returns the height for row at index path by returning the value that is defined by the kTableViewCellHeight constant
    
    - parameter tableView: UITableView
    - parameter indexPath: NSIndexPath
    
    - returns: CGFloat
    */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kTableViewCelHeight
    }
    
    
}
