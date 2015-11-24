/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

/// Controller for setting up and showing all Onboarding screens
class OnboardingViewController: UIViewController {

    /// Shared instance of class
    static let SharedInstance: OnboardingViewController = {
        let storyBoard = UIStoryboard(name: "Onboarding", bundle: NSBundle.mainBundle())
        let onboard = storyBoard.instantiateViewControllerWithIdentifier("onboarding") as! OnboardingViewController
        
        onboard.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        return onboard
        }()
    
    /// button for getting started
    @IBOutlet weak var getStartedButton: UIButton!
    
    /// view for holding onboarding content
    @IBOutlet weak var contentView: UIView!
    
    /// page control for displaying current page
    @IBOutlet weak var pageControl: UIPageControl!
    
    /// reference to the UIPageViewController for onboarding
    var pageViewController: UIPageViewController!
    
    /// New window for onboarding
    var newWindow: UIWindow!
    
    /// onboarding storyboard
    var storyBoard = UIStoryboard(name: "Onboarding", bundle: NSBundle.mainBundle())
    
    
    /**
    Method called upon view did load
    */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /**
    Method called upon view will appear and sets up the getting started button
    
    - parameter animated: Bool
    */
    override func viewWillAppear(animated: Bool) {
        setupGetStartedButton()
        pageControl.currentPageIndicatorTintColor = UIColor.travelMainColor()
    }
    
    
    /**
    Method called when we receieve a memory warning
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /**
    Method sets up the gettings started button
    */
    func setupGetStartedButton(){
        self.getStartedButton.backgroundColor = UIColor.travelMainColor()
        self.getStartedButton.hidden = true
        self.getStartedButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
        self.getStartedButton.addTarget(self, action: "finishOnboarding", forControlEvents: .TouchUpInside)
    }
    
    
    /**
    Shows the onboarding vc once if it is the first time opening the application
    */
    func showOnboardingVCOnce() {
        //show first time opening app only
        if !NSUserDefaults.standardUserDefaults().boolForKey("hasShownOnboarding") {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasShownOnboarding")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            setupOnboardingVC()
        }
    }
    
    
    /**
    Method to show the onboarding vc
    */
    func showOnboardingVC() {
        setupOnboardingVC()
    }
    
    
    /**
    Sets up all required elements for onboarding VC
    */
    func setupOnboardingVC() {
        self.newWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.newWindow.windowLevel = UIWindowLevelAlert + 1.0
        self.newWindow.addSubview(self.view)
        self.view.frame = CGRect(x: 0, y: self.newWindow.frame.height, width: self.newWindow.frame.width, height: self.newWindow.frame.height)
        self.newWindow.hidden = false
        
        //animate showing onboarding
        UIView.animateWithDuration(0.5, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.newWindow.frame.width, height: self.newWindow.frame.height)
            
            }, completion: { _ in
                //change button look and feel
             
        })
        setupOnboardingPageVC()
    }
    
    
    /**
    Sets up all required elements for onboarding page vc
    */
    func setupOnboardingPageVC() {
        self.pageViewController = storyBoard.instantiateViewControllerWithIdentifier("onboardingPageVC") as! UIPageViewController
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        
        let first = storyBoard.instantiateViewControllerWithIdentifier("first") as! FirstOnboardingViewController
        let viewControllers: NSArray = [first]
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: false, completion:{ _ in
            dispatch_async(dispatch_get_main_queue(), { _ in
                self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: false, completion: nil)
            })
            
        })
        self.addChildViewController(self.pageViewController)
        self.view.insertSubview(self.pageViewController.view, belowSubview: self.getStartedButton)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    
    /**
    Method to finish onboarding
    */
    func finishOnboarding() {
        //animate hiding onboarding
        self.getStartedButton.userInteractionEnabled = false
        UIView.animateWithDuration(0.5, animations: {
            self.view.frame = CGRect(x: 0, y: self.newWindow.frame.height, width: self.newWindow.frame.width, height: self.newWindow.frame.height)
            
            }, completion: { _ in
                self.reset()
                self.getStartedButton.userInteractionEnabled = true
        })
    }
    
    
    /**
    Method to reset and dismiss onboarding
    */
    func reset() {
        self.pageControl.currentPage = 0
        self.pageViewController.view.removeFromSuperview()
        self.pageViewController.removeFromParentViewController()
        self.view.removeFromSuperview()
        self.newWindow = nil
        self.pageViewController = nil
    }
    
}


// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    
    
    /**
    Method called after user swipes between different onboarding controllers
    
    - parameter pageViewController:      UIPageViewController
    - parameter finished:                Bool
    - parameter previousViewControllers: [UIViewController]
    - parameter completed:               Bool
    */
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            // Method used to keep a pageControl updated with current index
            if let currentVC = pageViewController.viewControllers![0] as? FirstOnboardingViewController {
                if let index = currentVC.pageIndex {
                    self.pageControl.currentPage = index
                }
            } else if let currentVC = pageViewController.viewControllers![0] as? SecondOnboardingViewController {
                if let index = currentVC.pageIndex {
                    self.pageControl.currentPage = index
                }
            } else if let currentVC = pageViewController.viewControllers![0] as? ThirdOnboardingViewController {
                if let index = currentVC.pageIndex {
                    self.pageControl.currentPage = index
                }
            } else if let currentVC = pageViewController.viewControllers![0] as? FourthOnboardingViewController {
                if let index = currentVC.pageIndex {
                    self.getStartedButton.hidden = true
                    self.pageControl.currentPage = index
                }
            }
            else {
                self.getStartedButton.hidden = false
                let currentVC = pageViewController.viewControllers![0] as! FifthOnboardingViewController
                if let index = currentVC.pageIndex {
                    self.pageControl.currentPage = index
                }
            }
            
        }
    }
    
    
    /**
    Method that returns the view controller after the given view controller
    
    - parameter pageViewController: UIPageViewController
    - parameter viewController:     UIViewController
    
    - returns: UIViewController?
    */
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if (viewController.restorationIdentifier == "first") {
            let vc = storyBoard.instantiateViewControllerWithIdentifier("second") as! SecondOnboardingViewController
            return vc
        } else if (viewController.restorationIdentifier == "second") {
            let vc = storyBoard.instantiateViewControllerWithIdentifier("third") as! ThirdOnboardingViewController
            return vc
            
        } else if (viewController.restorationIdentifier == "third") {
            let vc = storyBoard.instantiateViewControllerWithIdentifier("fourth") as! FourthOnboardingViewController
            return vc
            
        } else if (viewController.restorationIdentifier == "fourth") {
            let vc = storyBoard.instantiateViewControllerWithIdentifier("fifth") as! FifthOnboardingViewController
            return vc
            
        }
        else {
            return nil
        }
        
    }
    
    
    
    /**
    Method that returns the view controller before the given view controller
    
    - parameter pageViewController: UIPageViewController
    - parameter viewController:     UIViewController
    
    - returns: UIViewController?
    */
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if (viewController.restorationIdentifier == "second") {
            let vc = storyBoard.instantiateViewControllerWithIdentifier("first") as! FirstOnboardingViewController
            return vc
        }
        else if (viewController.restorationIdentifier == "third") {
            let vc = storyBoard.instantiateViewControllerWithIdentifier("second") as! SecondOnboardingViewController
            return vc
        }
        else if (viewController.restorationIdentifier == "fourth") {
            let vc = storyBoard.instantiateViewControllerWithIdentifier("third") as! ThirdOnboardingViewController
            return vc
        }
        else if (viewController.restorationIdentifier == "fifth") {
            let vc = storyBoard.instantiateViewControllerWithIdentifier("fourth") as! FourthOnboardingViewController
            return vc
        }
        else {
            return nil
        }
    }
    
    
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    
    
}
