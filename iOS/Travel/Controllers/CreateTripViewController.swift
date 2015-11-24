/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

/// Create trip VC shown in opening screen of application
class CreateTripViewController: UIViewController {

    /// Holder for segmented control
    @IBOutlet weak var segmentedControlHolderView: UIView!
    
    /// transit passes blank view
    @IBOutlet weak var transitPassesBlankView: UIView!
    
    /// info button which brings up demo controller
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var navigationBar: UIView!
    
    /// segmented control -- custom framework HHSegmentedControl
    var segmentedControl: HMSegmentedControl!
    
    /// transit tab view
    var transitView: TransitTabView!
    
    /// Passes tab view
    var passesView: PassesTabView!
    
    /// scrollview
    var scrollView: UIScrollView!
    

    /**
    Method called when we receive a memory wanring
    */
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    
    /**
    Method that is called upon view did load. It sets up the blank view with either transit or passes tab view, sets up the HMSegmentedControler and configures the info button
    */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureBlankView()
        setUpHMSegmentedControl()
        configureInfoButton()
        
        navigationBar.backgroundColor = UIColor.travelNavigationBarColor()
        
    }
    
    
    
    /**
    Method to configure the blank view with either transit or passes tab view
    */
    private func configureBlankView() {
        
        //setup views
        transitView = TransitTabView.instanceFromNib()
        passesView = PassesTabView.instanceFromNib()
        transitView.setupView()
        passesView.setupView()
        
        transitPassesBlankView.addSubview(transitView)
        transitPassesBlankView.addSubview(passesView) //this should show first
        passesView.searchButton.addTarget(self, action: "goToRailPurchase", forControlEvents: .TouchUpInside)
        transitView.searchButton.hidden = true //hide initially
        
    }
    
    
    /**
    Method to setup the segmented control
    */
    func setUpHMSegmentedControl(){
        self.segmentedControl = HMSegmentedControl(sectionTitles: [NSLocalizedString("Buy Tickets", comment: ""), NSLocalizedString("Buy Passes", comment: "")])
        
        self.segmentedControl.selectedSegmentIndex = 1
        
        self.segmentedControl.autoresizingMask = [.FlexibleRightMargin, .FlexibleWidth]
        
        self.segmentedControl.frame = CGRectMake(0, 0, self.segmentedControlHolderView.frame.size.width, self.segmentedControlHolderView.frame.size.height)

        
        self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10)
        self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe
        self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        self.segmentedControl.selectionIndicatorColor =  UIColor.travelMainColor()
        self.segmentedControl.selectionIndicatorHeight = 2
        
        self.segmentedControl.backgroundColor = UIColor.clearColor()
        
        self.segmentedControl.titleFormatter = {(segmentedControl : HMSegmentedControl!, title : String!, index : UInt, selected : Bool)->NSAttributedString! in
            
            let attributedString = NSMutableAttributedString(string: title)
            
            
            //Create attributes for two parts of the string
            let firstAttributes = [NSFontAttributeName: UIFont.travelSemiBold(11), NSForegroundColorAttributeName: UIColor.travelMainColor()]
            
            attributedString.addAttributes(firstAttributes, range: NSMakeRange(0, title.length))
            
            return attributedString
        }
        
        
        self.segmentedControl.indexChangeBlock = {(index : NSInteger) in
            
            switch index {
            case 0:
                self.transitPassesBlankView.bringSubviewToFront(self.transitView)
                self.transitView.searchButton.hidden = false
            case 1:
                self.transitPassesBlankView.bringSubviewToFront(self.passesView)
                self.transitView.searchButton.hidden = true
            default:
                self.transitPassesBlankView.bringSubviewToFront(self.passesView)
                self.transitView.searchButton.hidden = true
            }

        }
        
        self.segmentedControlHolderView.addSubview(self.segmentedControl)
    }
    
    
    /**
    Method to setup info button
    */
    private func configureInfoButton() {
        infoButton.addTarget(self, action: "infoButtonTapped", forControlEvents: .TouchUpInside)
    }
    
    
    /**
    Method to present demo controller when info button tapped
    */
    func infoButtonTapped() {
        
        (self.parentViewController as! GoViewController).isFirstLoad = false

        DemoConsoleManager.SharedInstance.displayDemoConsole()
        
    }
    
    
    /**
    Method to go to the rail purchase screen
    */
    func goToRailPurchase() {
        self.performSegueWithIdentifier("toPurchasing", sender: self)
        
    }
    
    

}
