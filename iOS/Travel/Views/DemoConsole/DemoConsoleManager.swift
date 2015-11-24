/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import Foundation

/**

**DemoConsoleManager**

A dropdown console for demo purposes.

*/
class DemoConsoleManager {
    
    static let SharedInstance = DemoConsoleManager()
    
    
    var viewToAddAlertsTo: UIView { return self.view }
    
    func displayDemoConsole() { self.demoConsoleViewController.display() }
    
    
    // generic window (latest design)
    private var window: UIWindow!
    private var view: UIView!
    
    // viewController
    var demoConsoleViewController: DemoConsoleViewController!
    
    
    init() {
        configureWindow()
        configureView()
        
        configureDemoConsoleViewController()
        configureLinkedComponents()
    }
}


/// MARK: Setup
extension DemoConsoleManager {
    
    /**
    Method to configure the window
    */
    private func configureWindow() {
        self.window = UIWindow(frame: CGRect(origin: CGPointZero, size: CGSizeZero))
        self.window.hidden = false
        self.window.windowLevel = UIWindowLevelStatusBar + 1.0
    }
    
    
    /**
    Method to configure the view
    */
    private func configureView() {
        self.view = UIView(frame: self.window.frame)
    }
    
    
    /**
    Method to configure the demo console view controller
    */
    private func configureDemoConsoleViewController() {
        
        self.demoConsoleViewController = DemoConsoleViewController()
        self.demoConsoleViewController.view = self.view
        self.demoConsoleViewController.window = self.window
        self.window.addSubview(self.demoConsoleViewController.view)
        
    }
    
    
    /**
    Method to configure linkd components
    */
    private func configureLinkedComponents() {
        
        self.window.addSubview(self.demoConsoleViewController.view)
        self.window.rootViewController = self.demoConsoleViewController
        self.window.rootViewController?.viewDidLoad()
        
    }
    
}

