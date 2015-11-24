/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit


/// Recommendations VC
class RecommendationsViewController: UIViewController {
    
    /// nav bar view
    @IBOutlet weak var navigationBar: UIView!
    
    /// table view
    @IBOutlet weak var tableView: UITableView!
    
    /// banner view
    @IBOutlet weak var bannerView: UIView!
    
    /// nav bar title label
    @IBOutlet weak var navigationBarTitleLabel: UILabel!
    
    /// back button
    @IBOutlet weak var backButton: UIButton!
    
    /// options button
    @IBOutlet weak var optionsButton: UIButton!
    
    /// view model
    var viewModel: RecommendationsViewModel!
    
    /// horizontal two part stack view
    var horizontalStackView: HorizontalTwoPartStackView!
    
    /// horizontal one part stack view
    var onePartStackView : HorizontalOnePartStackView!
    
    /// horizontal two part stack view
    var twoPartStackView : HorizontalTwoPartStackView!

    
    /**
    Method called when we receive a memory warning
    */
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    
    /**
    Method called upon view did load that sets up the status bar, view, and table view
    */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupStatusBar()
        setupView()
        setUpTableView()
        
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
        tracker.set(kGAIScreenName, value: "Recommendations Screen")
        
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
        self.optionsButton.hidden = true //hide option button for every case except transportation
        self.navigationBarTitleLabel.text = viewModel.getNavigationBarTitle()
        self.backButton.addTarget(self, action: Selector("backButtonAction"), forControlEvents: .TouchUpInside)
        self.optionsButton.addTarget(self, action: Selector("optionsButtonAction"), forControlEvents: .TouchUpInside)
        setupStackView()
        backButton.setTitleColor(UIColor.travelMainColor(), forState: .Normal)
    }
    
    
    /**
    Action to pop navVC when back is tapped
    */
    func backButtonAction(){
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    
    /**
    Action to pop navVC when options button tapped
    */
    func optionsButtonAction(){
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    
    /**
    Method to setup the table view
    */
    func setUpTableView(){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        Utils.registerNibWithTableView("restaurant", nibName: "RecommendedRestaurantTableViewCell", tableView: self.tableView)
        Utils.registerNibWithTableView("hotel", nibName: "RecommendedHotelTableViewCell", tableView: self.tableView)
        Utils.registerNibWithTableView("transportation", nibName: "RecommendedTransportationTableViewCell", tableView: self.tableView)
        Utils.registerNibWithTableView("blablacar", nibName: "RecommendedBlaBlaCarTableViewCell", tableView: self.tableView)
        
        tableView.estimatedRowHeight = 104.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    
    /**
    Method to setup the stackview based on the rec type
    */
    func setupStackView() {
    
        let recommendationsType = viewModel.getRecommendationsType()
        
        if let recType = recommendationsType {
        
            if(recType == viewModel.kLodgingRecType){
                twoPartStackView = HorizontalTwoPartStackView.instanceFromNib()
                viewModel.setupTwoPartStackView(recType, twoPartStackView: twoPartStackView)
                twoPartStackView.frame = CGRectMake(0, 0, view.frame.width, bannerView.frame.height)
                bannerView.addSubview(twoPartStackView)
            }
            else if(recType == viewModel.kRestaurantRecType){
                onePartStackView = HorizontalOnePartStackView.instanceFromNib()
                viewModel.setupOnePartStackView(onePartStackView)
                onePartStackView.frame = CGRectMake(0, 0, view.frame.width, bannerView.frame.height)
                bannerView.addSubview(onePartStackView)
            }
            else if(recType == viewModel.kTransportationRecType){
                twoPartStackView = HorizontalTwoPartStackView.instanceFromNib()
                viewModel.setupTwoPartStackView(recType, twoPartStackView: twoPartStackView)
                twoPartStackView.frame = CGRectMake(0, 0, view.frame.width, bannerView.frame.height)
                bannerView.addSubview(twoPartStackView)  
            }
        }
        
    }
    
    
    /**
    Method that sets of the recommendation detail VC view model before segueing to the recommendation VC
    
    - parameter segue:  UIStoryboardSegue
    - parameter sender: AnyObject?
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if(segue.identifier == "recommendationDetail"){
            let recommendationDetailViewController = segue.destinationViewController as! RecommendationDetailViewController
            
            recommendationDetailViewController.viewModel = viewModel.getRecommendationDetailViewModel()
        }
    }
    
}


/** 

MARK: UITableViewDelegate

*/
extension RecommendationsViewController: UITableViewDelegate {
    
    
    /**
    Method that defines the action that is taken when a cell of the table view is  selected, in this case we segue to the recommendation detail view controller if the cell selected is at indexPath.row 0
    
    - parameter tableView: UITableView
    - parameter indexPath: NSIndexPath
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.row == 0){
            viewModel.selectedRecommendationIndexPath(indexPath)
            performSegueWithIdentifier("recommendationDetail", sender: self)
        }
    }
    
}


/**

MARK: UITableViewDataSource

*/
extension RecommendationsViewController: UITableViewDataSource {

    /**
    Method that returns the number of section in the table view by asking the view model
    
    - parameter tableView: UITableView
    
    - returns: Int
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.numberOfSectionsInTableView()
    }
    
    
    /**
    Method that returns the number of rows in the section by asking the view model
    
    - parameter tableView: UITableView
    - parameter section:   Int
    
    - returns: Int
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    
    /**
    Method that sets up the cell right before its about to be displayed. In this case we remove the 15 pt separator inset
    
    - parameter tableView: UITableView
    - parameter cell:      UITableViewCell
    - parameter indexPath: NSIndexPath
    */
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //remove 15 pt separator inset so it goes all the way across width of tableview
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
    }
    
    
    /**
    Method that returns the cell for row at indexPath by asking the view model to set up th cell
    
    - parameter tableView: UITableView
    - parameter indexPath: NSIndexPath
    
    - returns: UITableViewCell
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return viewModel.setUpTableViewCell(indexPath, tableView: tableView)
    }
    

}
