/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

/// Trip detail navigation bar view
class TripDetailNavigationBarView: UIView {

    /// back button
    @IBOutlet weak var backButton: UIButton!
    
    /// add button
    @IBOutlet weak var addButton: UIButton!
    
    /// trip title label
    @IBOutlet weak var tripTitleLabel: UILabel!
    
    /// trip detail label
    @IBOutlet weak var tripDetailLabel: UILabel!
    
    /// back image view
    @IBOutlet weak var backImageView: UIImageView!
    
    /// info button
    @IBOutlet weak var infoButton: UIButton!
    
    /// view with blurred background
    var viewWithBlurredBackground : UIView!
    
    /// view with blurred background holder view
    var viewWithBlurredBackgroundHolderView : UIView!
    
    
    /**
    Method returns an instance of TripDetailNavigationBarView from nib
    
    - returns: TripDetailNavigationBarView
    */
    class func instanceFromNib() -> TripDetailNavigationBarView {
        return UINib(nibName: "TripDetailNavigationBarView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! TripDetailNavigationBarView
    }
    
    
    /**
    Method to set buttons hidden and animate them in
    */
    func setButtonsHiddenAndAnimateIn(){
        
        self.backButton.alpha = 0
        
        self.addButton.alpha = 0
        
        self.backImageView.alpha = 0
        
        self.infoButton.alpha = 0
        
        UIView.animateWithDuration(0.8, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.backButton.alpha = 1.0
            
            self.addButton.alpha = 1.0
            
            self.backImageView.alpha = 1.0
            self.infoButton.alpha = 1.0
            
            }, completion: nil)
    }
    
    
    /**
    Method to setup trip duration date label
    */
    func setupTripDurationDateLabel() {
        let startDate = NSDate()
        let tomorrow = NSDate.getDateForNumberDaysAfterDate(startDate, daysAfter: 1)
        let start = NSDate.getDateStringWithDayAndMonth(tomorrow)
        let endDate = NSDate.getDateForNumberDaysAfterDate(tomorrow, daysAfter: 4)
        let end = NSDate.getDateStringWithDayAndMonth(endDate)
        tripDetailLabel.text = NSLocalizedString("\(start) - \(end)", comment: "")
        
    }
    
    
    /**
    Method to setup blurred background view
    */
    func setUpBlurredBackgroundView(){
        
        let effect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        
        self.viewWithBlurredBackground = UIVisualEffectView(effect: effect)
        
        self.viewWithBlurredBackground.frame = CGRectMake(0, 0, self.frame.size.width, Utils.getNavigationBarHeight())
        
        self.viewWithBlurredBackground.alpha = 1.0
        
        
        viewWithBlurredBackgroundHolderView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: Utils.getNavigationBarHeight()))
        viewWithBlurredBackgroundHolderView.backgroundColor = UIColor.clearColor()
        viewWithBlurredBackgroundHolderView.alpha = 0.0
        viewWithBlurredBackgroundHolderView.addSubview(viewWithBlurredBackground)
        
        
        self.addSubview(self.viewWithBlurredBackgroundHolderView)
        
        self.insertSubview(self.viewWithBlurredBackgroundHolderView, belowSubview: self.addButton)
        self.insertSubview(self.viewWithBlurredBackgroundHolderView, belowSubview: self.backButton)
        self.insertSubview(self.viewWithBlurredBackgroundHolderView, belowSubview: self.backImageView)

        self.bringSubviewToFront(tripTitleLabel)
        self.bringSubviewToFront(tripDetailLabel)
        
    }
    
    
    /**
    Method to setup blurred background view alpha
    
    - parameter magicLine:               magic line CGFloat
    - parameter scrollViewContentOffset: content offset CGFloat
    */
    func setBlurredBackgroundViewAlpha(magicLine : CGFloat, scrollViewContentOffset : CGFloat){
        
        let alphaOffset = scrollViewContentOffset - magicLine
        
        let alphaValue = alphaOffset/60
        
        if(alphaValue < 0.7){
            self.viewWithBlurredBackgroundHolderView.alpha = alphaValue
        }
        else{
            self.viewWithBlurredBackgroundHolderView.alpha = 0.7
        }
        
    }
    
    
    /**
    Method to set blurred background view with alpha 0.0
    */
    func setBlurredBackgroundViewAlphaZero(){
        
        self.viewWithBlurredBackgroundHolderView.alpha = 0.0
    }

}
