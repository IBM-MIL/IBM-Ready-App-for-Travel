/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit


/**

MARK: NIB Instantiation

*/
extension DemoConsoleView {
    
    /**
    Method returns the Demo Console View from nib
    
    - parameter frame:     CGRect
    - parameter dismisser: protocol<DemoConsoleDataProviderProtocol, DemoConsoleDismissalProtocol>
    
    - returns: DemoConsoleView
    */
    static func InstanceFromNib(
        frame: CGRect,
        dismisser: protocol<DemoConsoleDataProviderProtocol, DemoConsoleDismissalProtocol>
        ) -> DemoConsoleView {
            
            let returnDemoConsoleView = UINib(nibName: "DemoConsoleView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! DemoConsoleView
            
            returnDemoConsoleView.frame = frame
            returnDemoConsoleView.dismisser = dismisser
            
            returnDemoConsoleView.getStartedButton.backgroundColor = UIColor.travelMainColor()
            returnDemoConsoleView.businessInsightsButton.backgroundColor = UIColor.travelMainColor()
            returnDemoConsoleView.cancelButton.setTitleColor(UIColor.travelMainColor(), forState: .Normal)
            
            return returnDemoConsoleView
    }
    
}


class DemoConsoleView: UIVisualEffectView {
    
    @IBOutlet weak var sliderPosition0: UIButton!
    @IBOutlet weak var sliderPosition1: UIButton!
    @IBOutlet weak var sliderPosition2: UIButton!
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var businessInsightsButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    var businessInsightsView : UIView!
    var sliderImage: UIImage!
  
    /** set this after instantiation */
    var dismisser: protocol<DemoConsoleDataProviderProtocol, DemoConsoleDismissalProtocol>! {
        didSet { self.didSetDismisser = true }
    }
    
    // setup verification
    private var didSetDismisser = false
    
    var isEnabled = false {
        willSet { updateIsEnabledState(newValue) }
    }
    
    
    /**
    Method update enables the state
    
    - parameter newValue: Bool
    */
    private func updateIsEnabledState(newValue: Bool) {
        let norm = UIControlState.Normal
        let pos0 = self.sliderPosition0
        
        if pos0.backgroundImageForState(norm) != nil {
            self.sliderImage = pos0.backgroundImageForState(norm)
        }
        
        self.getStartedButton.setTitle(NSLocalizedString("O N B O A R D I N G", comment: ""), forState: UIControlState.Normal)
        self.getStartedButton.enabled = newValue
        
     
        
        businessInsightsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        businessInsightsButton.setTitle(NSLocalizedString("B U S I N E S S  I N S I G H T S", comment: ""), forState: .Normal)
       
        
        if let gray = UIImage(named: "gray") {
            self.getStartedButton.setBackgroundImage(gray, forState: UIControlState.Disabled)
        }
        
        self.sliderPosition0.enabled = newValue
        self.sliderPosition1.enabled = newValue
        self.sliderPosition2.enabled = newValue
        
        self.button0.enabled = newValue
        self.button1.enabled = newValue
        self.button2.enabled = newValue
        
        let currIndex = TravelDataManager.SharedInstance.currentItinerary.value ?? 0
        
        setIndexHighlight(currIndex)
    }
    
}


/**

MARK: IBAction(s) & Helpers

*/
extension DemoConsoleView {
    
    // Index 0 on demo console -> index 0 of Itineraries
    // Index 1 on demo console -> index 2 of Itineraries
    // Indexs 2 on demo console -> index 3 of Itineraries
    
    
    /**
    Method defines the action when the add Transportation button is pressed
    
    - parameter sender: AnyObject
    */
    @IBAction func addTransportationPressed(sender: AnyObject) { selectIndex(3) }
    
    
    /**
    Method defines the action when the inclement weather button is pressed
    
    - parameter sender: AnyObject
    */
    @IBAction func inclementWeatherPressed(sender: AnyObject) { selectIndex(2) }
    
    
    /**
    Method defines the action when the add hotel button is pressed
    
    - parameter sender: AnyObject
    */
    @IBAction func addHotelPressed(sender: AnyObject) { selectIndex(0) }
    
    
    /**
    Method defines the action when the get started button is pressed
    
    - parameter sender: AnyObject
    */
    @IBAction func getStartedPressed(sender: AnyObject) {
        OnboardingViewController.SharedInstance.showOnboardingVC()
    }
    
    
    /**
    Method defines the action that is taken when the business insights button is pressed
    
    - parameter sender: AnyObject
    */
    @IBAction func businessInsightsButtonAction(sender: AnyObject) {
        if(businessInsightsView == nil){
            businessInsightsView = UIView(frame: UIScreen.mainScreen().bounds)
            businessInsightsView.backgroundColor = UIColor.blackColor()
        
            let imageView = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width , UIScreen.mainScreen().bounds.height))
        
            imageView.image = UIImage(named: "business_insights")
        
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
            businessInsightsView.addSubview(imageView)
        
            let tap = UITapGestureRecognizer(target: self, action: Selector("dismissImageView"))
            businessInsightsView.addGestureRecognizer(tap)

            self.addSubview(businessInsightsView)
            self.bringSubviewToFront(businessInsightsView)
        }
        businessInsightsView.hidden = false
    }
    
    
    /**
    Method is called when the business insights image view is touched
    */
    func dismissImageView(){
       businessInsightsView.hidden = true
    }
    

    /**
    Method is called when the cancel button is pressed on the demo console
    
    - parameter sender: AnyObject
    */
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissDemoConsole()
    }
    
    
    /**
    Method sets the itinerary index, index highlight, and dismisses the demo console
    
    - parameter index: Int
    */
    func selectIndex(index: Int) {
        setItineraryIndex(index)
        setIndexHighlight(index)
        dismissDemoConsole()
    }
    
    
    /**
    Method sets the itinerary index
    
    - parameter index: Int
    */
    private func setItineraryIndex(index: Int) {
        self.dismisser.viewModel.setUncommittedItinerary(index)
        self.dismisser.viewModel.commitCurrentDay()
    }
    
    
    /**
    Method dismisses the demo console
    */
    private func dismissDemoConsole() {
        self.dismisser.dismissDemoConsole()
    }
    
    
    /**
    Method sets the index highlight
    
    - parameter index: Int
    */
    func setIndexHighlight(index: Int) {
        
        // Index 0 on demo console -> index 0 of Itineraries
        // Index 1 on demo console -> index 2 of Itineraries
        // Indexs 2 on demo console -> index 3, 4 of Itineraries (edited)
        switch index {

        case 0, 1:
            self.sliderPosition0.setBackgroundImage(self.sliderImage, forState: .Normal)
            self.sliderPosition1.setBackgroundImage(nil, forState: .Normal)
            self.sliderPosition2.setBackgroundImage(nil, forState: .Normal)

        case 2:
            self.sliderPosition0.setBackgroundImage(nil, forState: .Normal)
            self.sliderPosition1.setBackgroundImage(self.sliderImage, forState: .Normal)
            self.sliderPosition2.setBackgroundImage(nil, forState: .Normal)

        case 3, 4:
            self.sliderPosition0.setBackgroundImage(nil, forState: .Normal)
            self.sliderPosition1.setBackgroundImage(nil, forState: .Normal)
            self.sliderPosition2.setBackgroundImage(self.sliderImage, forState: .Normal)

        default:
            func nothing() {}; nothing()
            
        }
    }
    
}
