/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import Foundation
import UIKit


class TripDetailAnimationManager: NSObject {

    //Constant variable used to set the duration of the animation
    let kAnimationDuration : NSTimeInterval = 0.5
    
    //Constant variable used to animate the label holder view to a certain y coordinate from the viewToTop
    let kLabelHolderViewSpaceFromTop : CGFloat = 10.0
    
    //View that is animated to the top
    var viewToTop : TripView!
    
    /**
    Method used to animate moving the current view to the left out of sight, animate the TripView to the top of the screen, and fade in the TripDetailViewController while performing a segue to the TripDetailViewController
    
    - parameter superView:                The view that holds the TripView
    - parameter realViewToTop:            The actual TripView you don't wanted animated to the top, it will just be hidden during the animation revealing the Fake trip view (viewToTop) you want to actually animate to the top
    - parameter viewToTop:                The fake trip view you want animated to the top
    - parameter tripDetailViewController: The TripDetailViewController we want to segue to and animate in
    - parameter viewToLeft:               The view thats a subview to the superview we want to animate to the left
    - parameter viewToLeftConstraint:     The viewToLeft center horizontally with superview constraint we will modify to animate the viewToLeft to the left
    - parameter fromViewController:       The view controller that holds the trip views and view to left
    */
    func animateIn(superView : UIView, realViewToTop: TripView?, viewToTop : TripView, tripDetailViewController : TripDetailViewController, viewToLeft : UIView, viewToLeftConstraint : NSLayoutConstraint, fromViewController : UIViewController){
        
        //Hide real TripView we dont to be animated to the top, we just hide it
        if realViewToTop != nil{
            realViewToTop!.hidden = true
        }
        
        self.viewToTop = viewToTop
        
        let kViewToTopHeight = tripDetailViewController.kHeaderViewHeight
        
        //grab reference to root view controller to allow us to do animations and add views above the tab bar
        let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController!
    
        //add viewToTop to rootview controller
        rootViewController!.view.addSubview(self.viewToTop)
        

        UIView.animateWithDuration(self.kAnimationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            //animate viewToTop to the top of the screen, layoutIfNeeded to allow the constraints to animate as they change too
            self.viewToTop.frame = CGRectMake(0, 0, rootViewController!.view.frame.size.width, kViewToTopHeight)
            self.viewToTop.layoutIfNeeded()
            
            //animate the labelHolderView to move towards the top of the viewToTop to allign to where the labels should be in the navigation bar
            self.viewToTop.labelHolderView.frame = CGRectMake(self.viewToTop.labelHolderView.frame.origin.x + 1, self.kLabelHolderViewSpaceFromTop + 1, self.viewToTop.labelHolderView.frame.size.width, self.viewToTop.labelHolderView.frame.size.height)
            
            self.viewToTop.blackOverlayView.alpha = 0.0

            //animate the center constraint of viewToLeft to move to the left outside of the screen, layoutIfNeeded to animate the constraint as it changes
            viewToLeftConstraint.constant = -UIScreen.mainScreen().bounds.width
            superView.layoutIfNeeded()
            
            
            }, completion: { _ in

                UIView.animateWithDuration(self.kAnimationDuration, delay: 0, options: [], animations: {
                    
                    //fade in the tripDetailViewController's view
                   tripDetailViewController.view.alpha = 1.0
                    
                    }, completion: { _ in
                        
                        //segue to the tripDetailViewController with no animation so it flashs on the screen quickly
                        fromViewController.navigationController!.pushViewController(tripDetailViewController, animated: false)
                        self.viewToTop.hidden = true
                        
                        //tell fromViewController that the animation is no longer in progress
                        if(fromViewController.isKindOfClass(GoViewController)){
                            (fromViewController as! GoViewController).animationInProgress = false
                        }
                        
                        //re-enable user interation of the tab bar (was disabled during animation so user can't change tabs)
                        (rootViewController as! TabBarViewController).tabBar.userInteractionEnabled = true
                        
                        //set trip detail view controller to alpha 0 so we can animate it to 1.0 in 2 lines below
                        tripDetailViewController.collectionView.alpha = 0.0
                        
                        //hide buttons/alpha 0 and animate them in
                        tripDetailViewController.navigationBar.setButtonsHiddenAndAnimateIn()
                        
                        //animate tripDetailViewController alpha to 1.0
                        UIView.animateWithDuration(0.5, animations: {
                            tripDetailViewController.collectionView.alpha = 1.0
                        })
                })
        })

    }
    
}