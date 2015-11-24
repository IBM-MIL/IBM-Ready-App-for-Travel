/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/


import UIKit

/// First of the rail purchase flow with choices for rail passes
class RailChoiceListViewController: UIViewController {

    
    @IBOutlet weak var backButton: UIButton!
    
    /// Table view
    @IBOutlet weak var tableView: UITableView!
    
    /// blankview in which stackview will be placed
    @IBOutlet weak var blankViewForStackView: UIView!
    
    /// Horizontal two part stackview
    var horizontalStackView: HorizontalTwoPartStackView!
    
    //number of section in tableView used for UITableView datasource method numberOfSectionsInTableView
    let kNumberOfSectionsInTableView = 1
    
    //number of rows in section in table view used for UITableView datasource method numberOfRowsInSection
    let kNumberOfRowsInSectionInTableView = 3
    
    //height for footer in section used for the UITableView datasource method heightForFooterInSection
    let kHeightForFooterInSection : CGFloat = 0.01
    

    /**
    Method is called upon view did load and it sets up the view and set the status bar text to black
    */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupView()
        setStatusBarTextToBlack()
        
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
        tracker.set(kGAIScreenName, value: "Rail Pass Choice Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    
    /**
    Method to setup status bar color
    */
    private func setStatusBarTextToBlack() { StatusBarColorUtil.SetDark() }

    
    /**
    Method called when we receive a memory warning
    */
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    
    /**
    Setup the view
    */
    func setupView() {
        backButton.setTitleColor(UIColor.travelMainColor(), forState: .Normal)
        setupStackView()
        setUpTableView()
    }

    
    /**
    Method to setup the tableview
    */
    func setUpTableView(){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        Utils.registerNibWithTableView("railPass", nibName: "RailPassOptionTableViewCell", tableView: self.tableView)
        
        tableView.estimatedRowHeight = 145.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    /**
    Method to setup the stackview
    */
    private func setupStackView() {
    
        horizontalStackView = HorizontalTwoPartStackView.instanceFromNib()
        horizontalStackView.frame = CGRectMake(0, 0, self.view.frame.width, blankViewForStackView.frame.height)
        blankViewForStackView.addSubview(horizontalStackView)
        setupDateLabel()
    }
    
    /**
    Method to setup the date label
    */
    private func setupDateLabel() {
    
        let date = NSDate()
        let tomorrow = NSDate.getDateForNumberDaysAfterDate(date, daysAfter: 1)
        let startDateString = NSDate.getDateStringWithDayAndMonth(tomorrow)
        let endDate = NSDate.getDateForNumberDaysAfterDate(tomorrow, daysAfter: 4)
        let endDateString = NSDate.getDateStringWithDayAndMonth(endDate)

        horizontalStackView.secondContentLabel.text = NSLocalizedString("4 Nights\n\(startDateString) " + "- \(endDateString)", comment: "")
        
    }
    
    /**
    Action for popping navVC when back button is tapped
    
    - parameter sender: sender of action
    */
    @IBAction func tappedBackButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}


/**

MARK: UITableViewDelegate

*/
extension RailChoiceListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if (indexPath.row == 0) {
            performSegueWithIdentifier("toSelection", sender: self)
        }
    }
    
}


/**

MARK: UITableViewDataSource

*/
extension RailChoiceListViewController: UITableViewDataSource {
    
    /**
    Method that returns the number of sections in the tableView, which is defined by the kNumberOfSectionsInTableView constant variable
    
    - parameter tableView: UITableView
    
    - returns: Int
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return kNumberOfSectionsInTableView
    }
    
    
    /**
    Method that returns the number of rows in a section, defined by the kNumberOfRowsInSectionInTableView constant variable
    
    - parameter tableView: UITableView
    - parameter section:   Int
    
    - returns: Int
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kNumberOfRowsInSectionInTableView
    }
    
    
    /**
    Method that prepares the cell right before its about to be displayed by removing the 15 point separator inset
    
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
    Method that sets up the cell for row at indexpath
    
    - parameter tableView: UITableView
    - parameter indexPath: NSIndexPath
    
    - returns: UITableViewCell
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("railPass", forIndexPath: indexPath) as! RailPassOptionTableViewCell
        
        if (indexPath.row == 0) {
            //"preferred" cell style
            cell.backgroundColor = UIColor(hex: "F5F5F5")
        } else if (indexPath.row == 1){
           //not "preferred" cell style
            cell.preferredView.hidden = true
            cell.titleLabel.text = NSLocalizedString("(5) One Day Pass for 1 Person", comment: "")
            cell.subTitleLabel.text = NSLocalizedString("Allows for an entire day of transportation.\n", comment: "")
            cell.priceLabel.text = NSLocalizedString("€34,50", comment: "")
        } else {
            cell.hidden = true //empty cell to get extra separator at bottom
        }
        
        return cell
    }
    
    
    
    /**
    Method that returns a view for footer in section, in this case we return a blank view
    
    - parameter tableView: UITableView
    - parameter section:   Int
    
    - returns: UIView?
    */
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    /**
    Method that returns the height for footer in section, defined by the kHeightForFooterInSection constant variable
    
    - parameter tableView: UITableView
    - parameter section:   Int
    
    - returns: CGFloat
    */
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return kHeightForFooterInSection
    }
    
}


