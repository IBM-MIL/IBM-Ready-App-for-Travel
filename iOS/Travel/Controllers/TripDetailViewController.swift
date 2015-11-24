/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

class TripDetailViewController: UIViewController {

    //collection view that displays all the itinerary events
    @IBOutlet weak var collectionView: UICollectionView!
    
    //viewModel that contains on the logic and state for the view controller (following MVVM patterns)
    var viewModel: TripDetailViewModel!
    
    //Navigation bar that it shown at the top of the view
    var navigationBar : TripDetailNavigationBarView!
    
    //Image that is shown in the nav bar once the scrollView content offset is past the magic line
    var navImageView : UIImageView!
    
    //Image that is shown above the itinerary if the scrollView content offset is below the magic line
    var underneathImageView : UIImageView!
    
    //State related properties
    var isCurrentlyVisible = false
    
    //State variable used to determine if the last VC the user was at was recommended detail, if it was, then we show the event added alert
    var comingFromRecommendedDetail = false
    
    //State variable used to keep track of if we have already shown the inclement weather alert so we don't try to shown it twice.
    var inclementWeatherAlertCurrentlyShown = false
    
    //Constant Properties
    let kNavigationBarHeight : CGFloat = 88
    let kToolBarHeight : CGFloat = 45
    let kHeaderViewHeight : CGFloat = 195.0
    let kSectionHeaderHeight : CGFloat = 52
    let kMinimumInterItemSpacingForSectionAtIndex : CGFloat = 0
    
    //Collection view cell height constants
    let kMeetingCollectionViewCellHeight : CGFloat = 129
    let kRestaurantCollectionViewCellHeight : CGFloat = 129
    let kRestaurantAffectedByWeatherCollectionViewCellHeight : CGFloat = 189
    let kFlightCollectionViewCellHeight : CGFloat = 179
    let kLodgingStayCollectionViewCellHeight : CGFloat = 140
    let kLodgingCollectionViewCellHeight : CGFloat = 183
    let kRecommendationsCollectionViewCellHeight : CGFloat = 85
    

    /**
    Method called when we receive a memory warning
    */
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    
    /**
    Method when the view loads, to setup the view model, collection view, navigation bar, and image view behind the collectionview's viewForSupplementaryElementOfKind
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupCollectionView()
        setupNavigationBar()
        setupImageView()
    }
    
    
    /**
    Method is called upon view will appear that sends data to Google Analytics about what view controller is currently being viewed by the user. It also setups the status bar color, and tell the go view controller that the itinerary has been viewed once.
    
    - parameter animated:
    */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupStatusBar()
        setItinerarySeen()
        
        setupGoogleAnalyticsTracking()
    }
    
    
    /**
    Method when the view did appear, to check if the previous view controller seen was the recommended detail view controller. If it is, we'll want to show the event added alert. Also when the view did appear, we will try to show the inclement weather alert if an alert is queue up.
    
    - parameter animated:
    */
    override func viewDidAppear(animated: Bool) {
        isCurrentlyVisible = true

        if(comingFromRecommendedDetail == true){
            comingFromRecommendedDetail = false
            showEventAddedAlert()
        }
        
        tryToShowInclementWeatherAlert()
    }
    
    
    /**
    Method when the view did disappear to keep state of weather the view of this view controller is visible or not.
    
    - parameter animated:
    */
    override func viewDidDisappear(animated: Bool) {
        isCurrentlyVisible = false
    }

    
    /**
    Method when the view will disappear to dismiss the shared instance of the MILAlertViewManager.
    
    - parameter animated: Bool
    */
    override func viewWillDisappear(animated: Bool) {
        MILAlertViewManager.SharedInstance.dismissAlert()
    }
    
    
    /**
    Method is called upon view will appear that sends data to Google Analytics about what view controller is currently being viewed by the userg
    */
    func setupGoogleAnalyticsTracking(){
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Trip Itinerary Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    
    /**
    Method sets the status bar to be light color
    
    - returns: UIStatusBarStyle
    */
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
 
    /**
    Method to setup the TripDetailViewModel and to observe any changes to the viewModel's dataDataArray. When there are changes to the dateDataArray , we will queue a weather alert, and then try to show the weather alert if the viewcontroller is currently visible.
    */
    private func setupViewModel() {
        
        viewModel = TripDetailViewModel.sharedInstance
        
        viewModel.dateDataArray.producer.start({
            _ in
            
            self.collectionView.reloadData()
            self.viewModel.tryToQueueWeatherAlert()
            if(self.isCurrentlyVisible == true){
                self.tryToShowInclementWeatherAlert()
            }
        })
    }
    
    
    /**
    Method to set the status bar to be white
    */
    func setupStatusBar() {
        StatusBarColorUtil.SetLight()
    }
    
    
    /**
    Method to setup the collection view delegate and data source to self, as well as register any collection view cell nibs and set the back ground of the collection view and the view controller
    */
    func setupCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self

        Utils.registerSupplementaryElementOfKindNibWithCollectionView("TripDetailSupplementaryView", kind: UICollectionElementKindSectionHeader, collectionView: collectionView)
        
        Utils.registerNibWithCollectionView("FlightCollectionViewCell", collectionView: collectionView)
        Utils.registerNibWithCollectionView("MeetingCollectionViewCell", collectionView: collectionView)
        Utils.registerNibWithCollectionView("RecommendationCollectionViewCell", collectionView: collectionView)
        
        Utils.registerNibWithCollectionView("POICollectionViewCell", collectionView: collectionView)
        
        Utils.registerNibWithCollectionView("MixedTransitCollectionViewCell", collectionView: collectionView)
        
        Utils.registerNibWithCollectionView("HotelCollectionViewCell", collectionView: collectionView)
        
        collectionView.backgroundColor = UIColor.clearColor()
        view.backgroundColor = UIColor.travelItineraryCellBackgroundColor()
    }
    
    
    /**
    Method to setup the navigation bar's view, including its labels, adding a blur effect, and adding targets to the back and info buttons.
    */
    func setupNavigationBar() {
        
        navigationBar = TripDetailNavigationBarView.instanceFromNib()
        
        navigationBar.frame = CGRectMake(0, 0, view.frame.size.width, Utils.getNavigationBarHeight() + 50)
        navigationBar.setUpBlurredBackgroundView()
        
        navigationBar.setupTripDurationDateLabel()
        
        view.addSubview(navigationBar)
        
        if let tabVC = Utils.rootViewController() as? TabBarViewController {
        
            if (tabVC.selectedIndex == 0) {
                if (UIScreen.mainScreen().nativeBounds.size.height <= 1136) { //make smaller font if iphone 5/5s size
                    navigationBar.backButton.titleLabel?.font = UIFont.travelRegular(15)
                    navigationBar.backButton.setTitle(NSLocalizedString("Booking", comment: ""), forState: UIControlState.Normal)
                } else {
                    navigationBar.backButton.setTitle(NSLocalizedString("    Booking", comment: ""), forState: UIControlState.Normal)
                }
            
            } else {
                navigationBar.backButton.setTitle(NSLocalizedString("Trips", comment: ""), forState: UIControlState.Normal)
            }
        }
        
        navigationBar.backButton.addTarget(self, action: Selector("backButtonAction"), forControlEvents: .TouchUpInside)
        navigationBar.addButton.hidden = true
        
        navigationBar.infoButton.addTarget(self, action: "infoButtonTapped", forControlEvents: .TouchUpInside)
    }
    

    /**
    Method to set up the image view on the the navigation bar as well as the image view below the collection view. There are two image views to help with the magic behind having the image view lock on the top of the navigation bar as well as stretch when the user scrolls down. More of this magic can be explained better by looking at the updateImageViewFrameWithScrollViewDidScroll in the UIScrollViewDelegate extension of the TripDetailViewController found at the bottom of this swift file.
    */
    func setupImageView() {
        
        let image = UIImage(named: "Trips-berlin")
        
        navImageView = UIImageView(image: image)
        navImageView.frame = CGRectMake(0, 0, view.frame.width, kHeaderViewHeight)
        navImageView.contentMode = UIViewContentMode.ScaleAspectFill
        navigationBar.addSubview(navImageView)
        navigationBar.insertSubview(navImageView, belowSubview: navigationBar.viewWithBlurredBackgroundHolderView)
        navImageView.clipsToBounds = true
        navImageView.hidden = true

        let image2 = UIImage(named: "Trips-berlin")
        underneathImageView = UIImageView(image: image2)
        underneathImageView.frame = CGRectMake(0, 0, view.frame.width, kHeaderViewHeight)
        underneathImageView.contentMode = UIViewContentMode.ScaleAspectFill
        underneathImageView.clipsToBounds = true
        
        view.addSubview(underneathImageView)
        view.insertSubview(underneathImageView, belowSubview: collectionView)
     
    }
    
    
    /**
    Method to define the action fired when the back button is pressed. If the selected index of the tab bar is 0, then it will pop back to the go view controller - Else it will just pop back to the previous view controller on the navigation controller stack
    */
    func backButtonAction() {
        
        if (tabBarController!.selectedIndex == 0) {
            let goVC = navigationController!.viewControllers.first as! GoViewController
            navigationController?.popToViewController(goVC, animated: true)
          
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
 
    }

    
    /**
    Method that is called in viewWillAppear that tells the goViewController that the itinerary has been seen, thus triggering the berlin itinerary banner at the bottom of the go view controller
    */
    func setItinerarySeen(){
        if let preGoVC = tabBarController?.viewControllers?.first as? PreGoViewController {
            if let goVC = preGoVC.viewControllers.first as? GoViewController {
                goVC.itinerarySeen = true
            }
        }
    }
    
    
    /**
    Method that defines the action fired when the info button is tapped. In this cass the demo console is triggered to be shown.
    */
    func infoButtonTapped() {
        DemoConsoleManager.SharedInstance.displayDemoConsole()
    }
    
    
    /**
    Method that is called in viewDidAppear if the previous view controller last seen was the recommendedDetailViewController. This method will show an alert saying the event as been added to the itinerary. When the user pressed the done button, it will scroll and highlight to the event cell just added to the itinerary
    */
    func showEventAddedAlert(){
        let alertText = viewModel.getAddedEventAlertText()
        
        MILAlertViewManager.SharedInstance.showRemyAlert(alertText, dismissButtonText: NSLocalizedString("DONE", comment: ""), milAlertViewType: .CHECKMARK, callbackOnReviewPress: scrollAndHighlightAddedEventCell)
    }
    
    
    /**
    Method that prepares the segue's destination view controller by creating and setting its view model.
    
    - parameter segue:
    - parameter sender:
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "eventDetail"{
            let eventDetailVC = segue.destinationViewController as! EventDetailViewController
            eventDetailVC.viewModel = viewModel.getEventDetailViewModel()
            
        }
        else if segue.identifier == "recommendations"{
            let recommendationsVC = segue.destinationViewController as! RecommendationsViewController
            recommendationsVC.viewModel = viewModel.getRecommendationsViewModel()
        }
    }
}



// MARK: - InclementWeatherAlert 
//This Extension has all the methods that have to do with the inclement weather alert showing and the actions taken from the user taking action
extension TripDetailViewController {
    
    
    /**
    Method is called in the viewDidAppear method as well as the call back called when the viewModel's dateDataArray changes. It will show the inclemented weather alert if a weather alert is queued up and the view controller is currently visible.
    */
    func tryToShowInclementWeatherAlert(){
        if(viewModel.isWeatherAlertQueuedUp() == true && isCurrentlyVisible){
            showInclementAlertView()
        }
    }
    
    
    /**
    Method will show the inclement weather alert if the view controller is currently visible and the inclement weather alert isn't current shown. When the review button is pressed, it will segue to the event detail view controller. It also sets the inclementWeatherAlertCurrentlyShown property to true
    */
    func showInclementAlertView() {
        if (isCurrentlyVisible == true && inclementWeatherAlertCurrentlyShown == false) {
            inclementWeatherAlertCurrentlyShown = true
            let alertText = NSLocalizedString("Inclement weather may affect your Regroup with audio/visual team at Pfau Cafe.", comment: "")
            
            MILAlertViewManager.SharedInstance.showInclementWeatherAlert(alertText, dismissText: NSLocalizedString("DISMISS", comment: ""), reviewText: NSLocalizedString("REVIEW", comment: ""), milAlertViewType: MILAlertViewType.EXCLAMATION_MARK, callbackOnReviewPress: showEventDetail, callbackOnDismissPress: inclemenentWeatherDismissed)
            
            showNotificationTabBadge()
        }
    }
    
    
    /**
    Method will make the notification tab have a badge with the number 1 on it.
    */
    func showNotificationTabBadge() {
        let tabArray = tabBarController?.tabBar.items as NSArray!
        
        if let array = tabArray {
            let tabItem = array.objectAtIndex(2) as! UITabBarItem
            tabItem.badgeValue = "1"
        }
    }
    
    /**
    Method is called when the dismiss button of the inclemented weather alert is called. It sets the inclemented we inclementWeatherAlertCurrentlyShown state property to false
    */
    func inclemenentWeatherDismissed(){
        inclementWeatherAlertCurrentlyShown = false
    }
    
    
    /**
    Method that shows the eventDetailViewController. Also sets the viewModel's isWeatherAlertSegue state property to true and the inclementWeatherAlertCurrentShown property to false
    */
    func showEventDetail(){
        inclementWeatherAlertCurrentlyShown = false
        viewModel.isWeatherAlertSegue = true
        performSegueWithIdentifier("eventDetail", sender: self)
    }
    
    
}




// MARK: - UICollectionViewDelegate
//This extension holds all the methods associated with being a  UICollectionViewDelegate
extension TripDetailViewController: UICollectionViewDelegate {
    
    /**
    Method that sets the minimumInterItemSpacingForSectionAtIndex to 0
    
    - parameter collectionView:
    - parameter collectionViewLayout:
    - parameter section:
    
    - returns:
    */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kMinimumInterItemSpacingForSectionAtIndex
    }
    
    
    /**
    Method that tells the viewModel which event indexPath was selected in the interary. Baded on the event subtype of the selected event cell, we will perform the correct type of segue to either the eventDetailViewController or the recommendations view controller
    
    - parameter collectionView:
    - parameter indexPath:
    */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        viewModel.setTheSelectedEventIndexPath(indexPath)
        let eventSubType = viewModel.getTypeOfCellForIndexPath(indexPath)
        
        if(eventSubType == "meeting"){}
        else if(eventSubType == "restaurant"){
            performSegueWithIdentifier("eventDetail", sender: self)
        }
        else if(eventSubType == "flight"){}
        else if(eventSubType == "lodging"){
            performSegueWithIdentifier("eventDetail", sender: self)
        }
        else if(eventSubType == "transit"){
            performSegueWithIdentifier("eventDetail", sender: self)
        }
        else if(eventSubType == "recommendations"){
            performSegueWithIdentifier("recommendations", sender: self)
        }
    }
}





// MARK: - UICollectionViewDataSource 
//This extension holds all the methods associated with being a UICollectionViewDataSource
extension TripDetailViewController: UICollectionViewDataSource {
    
    
    /**
    Method setups the cellForItemAtIndexPath by asking the viewModel to setup the cell
    
    - parameter collectionView:
    - parameter indexPath:
    
    - returns:
    */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
       return viewModel.setUpCollectionViewCell(indexPath, collectionView : collectionView)
    }
    
    /**
    Method sets the numberOfSectionInCollectionView by asking the viewModel how many sections there are
    
    - parameter collectionView:
    
    - returns:
    */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSectionsInCollectionView()
    }
    
    
    /**
    Method sets the numberOfItemsInSection by asking the viewModel how many items are in the particular section
    
    - parameter collectionView:
    - parameter section:
    
    - returns:
    */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    
    
    /**
    Method setups up the viewForSupplementaryElementOfKind by asking the viewModel to set it up. This specifically sets up a header view on the top of the collection view to be clear so you can see the image view at the top of the collection view that is actually below the collection view.
    
    - parameter collectionView:
    - parameter kind:
    - parameter indexPath:
    
    - returns:
    */
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return viewModel.setUpSectionHeaderViewForIndexPath(
            indexPath,
            kind: kind,
            collectionView: collectionView
        )
    }
}



// MARK: - UICollectoinViewDelegateFlowLayout
//This extension holds everything associated with being a UICollectionViewDelegateFlowLayout, mostly related to formatting the header in section and sizeForItemAtIndexPath
extension TripDetailViewController: UICollectionViewDelegateFlowLayout {
    
    
    /**
    Method sets the size of the section header at indexpath depending on what section it is.
    
    - parameter collectionView:
    - parameter collectionViewLayout:
    - parameter section:
    
    - returns:
    */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        let collectionWidth = collectionView.frame.size.width
      
        if(section == 0){
            return CGSizeMake(collectionWidth, kHeaderViewHeight + kSectionHeaderHeight)
        }
        else{
            return CGSizeMake(collectionWidth, kSectionHeaderHeight)
        }
        
    }
    
    
    /**
    Method determines the the size for item at indexpath for each collection view cell.
    
    - parameter collectionView:
    - parameter collectionViewLayout:
    - parameter indexPath:
    
    - returns:
    */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var height : CGFloat = 176
        let eventSubType = viewModel.getTypeOfCellForIndexPath(indexPath)
        if(eventSubType == "meeting"){
            height = kMeetingCollectionViewCellHeight
        }
        else if(eventSubType == "restaurant"){
           let isAffected = viewModel.isAffectedByWeather(indexPath)
            if let affected = isAffected {
                if(affected == true){
                    height = kRestaurantAffectedByWeatherCollectionViewCellHeight
                }
                else{
                    height = kRestaurantCollectionViewCellHeight
                }
            }
            else{
                height = kRestaurantCollectionViewCellHeight
            }
            
        }
        else if(eventSubType == "flight"){
            height = kFlightCollectionViewCellHeight
        }
        else if(eventSubType == "lodging"){
        
            let displayType = viewModel.getHotelDisplayType(indexPath)
            
            if let dType = displayType{
                if dType == "stay"
                {
                    height = kLodgingStayCollectionViewCellHeight
                } else {
                    height = kLodgingCollectionViewCellHeight
                }
            }
        }

        else if(eventSubType == "recommendations"){
            height = kRecommendationsCollectionViewCellHeight
        }
        
        return CGSize(
            width: collectionView.frame.size.width,
            height: height
        )
    }
}


// MARK: - UIScrollViewDelegate
//This extension holds all the methods associated with UIScrollViewDelegate and methods that are associated with scrolling and Highlighting
extension TripDetailViewController : UIScrollViewDelegate {
    
    
    
    /**
    Method that is called when the scrollView scrolls. When the scrollView scrolls we call the updateImageViewFrameWithScrollViewDidScroll method
    
    - parameter scrollView:
    */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updateImageViewFrameWithScrollViewDidScroll(scrollView.contentOffset.y)
    }
    
    /**
    Method is called in the scrollViewDidScroll method. This method is the secret sauce to getting the image at the top to lock to the navigation bar or to get the image to stretch.
    
    - parameter scrollViewContentOffset:
    */
    func updateImageViewFrameWithScrollViewDidScroll(scrollViewContentOffset : CGFloat) {
        
        if scrollViewContentOffset >= 0 {
            
            //magic line is the point where the bottom of the imageView is at the same y coordinate as the bottom of the navigation bar.
            let magicLine = kHeaderViewHeight - Utils.getNavigationBarHeight()
            
            if scrollViewContentOffset >= magicLine {
                navImageView.hidden = false
                navImageView.frame = CGRectMake(0, -magicLine, navImageView.frame.size.width, kHeaderViewHeight)
                underneathImageView.frame = CGRectMake(0, -magicLine, underneathImageView.frame.size.width, kHeaderViewHeight)
                navigationBar.setBlurredBackgroundViewAlpha(magicLine, scrollViewContentOffset: scrollViewContentOffset)
                
            } else {
                navigationBar.setBlurredBackgroundViewAlphaZero()
                navImageView.hidden = true
                navImageView.frame = CGRectMake(0, -scrollViewContentOffset, navImageView.frame.size.width, navImageView.frame.size.height)
                underneathImageView.frame = CGRectMake(0, -scrollViewContentOffset, underneathImageView.frame.size.width, underneathImageView.frame.size.height)
            }
            
        } else {
            
            navImageView.frame = CGRectMake(0, 0, navImageView.frame.size.width, kHeaderViewHeight - scrollViewContentOffset)
            underneathImageView.frame = CGRectMake(0, 0, underneathImageView.frame.size.width, kHeaderViewHeight - scrollViewContentOffset)
            
        }
    }
    
    
    
    /**
    Method is called after the event added alert is dismissed and the collection view scrolls to the event that was just added to the itinerary. The main purpose of this method is to highlight the cell that was just added to the itinerary but calling the cell's flash method.
    
    - parameter scrollView:
    */
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if let indexPath = viewModel.getAddedCellIndexPath() {
            let eventSubType = viewModel.getTypeOfCellForIndexPath(indexPath)
            Utils.printMQA("indexPath \(indexPath.row) \(indexPath.section)")
            
            if(eventSubType == "lodging"){
                let cell = collectionView.cellForItemAtIndexPath(indexPath)
                if(cell!.isKindOfClass(HotelCollectionViewCell) == true){
                    (cell as! HotelCollectionViewCell).flash()
                }
            }
            else if(eventSubType == "restaurant"){
                let cell = collectionView.cellForItemAtIndexPath(indexPath)
                
                if(cell!.isKindOfClass(MeetingCollectionViewCell) == true){
                    (cell as! MeetingCollectionViewCell).flash()
                }
            }
            else if(eventSubType == "transit")
            {
                let cell = collectionView.cellForItemAtIndexPath(indexPath)
                if(cell!.isKindOfClass(MixedTransitCollectionViewCell) == true){
                    (cell as! MixedTransitCollectionViewCell).flash()
                }
            }
        }
    }
    
    
    
    /**
    Method is called when the the event added alert is dismissed. It scrolls to the cell that was just added to the itinerary. It gets this indexPath by asking the viewModel
    */
    func scrollAndHighlightAddedEventCell(){
        dispatch_async(dispatch_get_main_queue()) {
            if let indexPath = self.viewModel.indexPathToScrollTo() {
                self.collectionView.layoutIfNeeded()
                
                self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredVertically, animated: true)
            }
        }
    }
    
}
