//
// Licensed Materials - Property of IBM
// © Copyright IBM Corporation 2015. All Rights Reserved.
//   This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer
// (a) for its own instruction and study,
// (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for
// redistribution by customer, as part of such an application, in customer's own products.
//
//  AppDelegate.swift
//  Travel
//


import UIKit
import Foundation
import CoreSpotlight
import MobileCoreServices


/**

MARK: Debugging

*/
extension AppDelegate {

    var DEBUG: Bool { return true }
    
    func DEBUG(input: AnyObject) {
        
        if DEBUG { Utils.printMQA(input as! String) }
        
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // deep linking search identifiers
    let identifier1 = "Berlin"
    
    var window: UIWindow? {
        willSet {
            self.mainWindow = newValue
        }
    }
    
    // weak to avoid excessive retain
    weak var mainWindow: UIWindow?
    
    
    /**
    Method sets up deeplinking, MFP, MQA, GoogleAnalytics, status bar, and OCLogger
    
    - parameter application:   UIApplication
    - parameter launchOptions: [NSObject:AnyObject]?
    
    - returns: Bool
    */
    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
            
            // iOS 9 Core Spotlight aka Deep Linking
            AddItemsToCoreSpotlight()
            
            MFP.Connect()
            MQA.initialize()
            GoogleAnalytics.initialize()
            
            configureStatusBarTint()
            configureOCLogger()
            
            return true
            
    }
    
    /**
    Method called when a user selects an item in the iOS 9 search, we then segue to the tripDetailViewController
    
    - parameter application:        UIApplication
    - parameter userActivity:       NSUserActivity
    - parameter restorationHandler: [AnyObject]?
    
    - returns: Bool
    */
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        if userActivity.activityType == CSSearchableItemActionType {
            if let _ = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
                
                if let tabVC = Utils.rootViewController() as? TabBarViewController {
            
                let tripDetailVC = Utils.vcWithNameFromStoryboardWithName("TripDetailViewController", storyboardName: "MyTrips") as! TripDetailViewController
                //  Use identifier to display the correct content (trip detail/itinerary) for this search result
                    tabVC.selectedIndex = 0
                   
                let navVC = tabVC.viewControllers!.first as! UINavigationController
                navVC.pushViewController(tripDetailVC, animated: true)
            }
        }
        
        
    }
        return true
    }
    
    
    /**
    Methid adds items to the core spotlight search for iOS 9 deep linking
    */
    func AddItemsToCoreSpotlight() {
        //search term 1
        let attributeSet1 = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet1.title = NSLocalizedString("Berlin Itinerary", comment: "")
        attributeSet1.contentDescription = NSLocalizedString("Berlin, Germany - Trip Itinerary", comment: "")
        
        let item1 = CSSearchableItem(uniqueIdentifier: identifier1, domainIdentifier: "com.ibm.com", attributeSet: attributeSet1)
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([item1]) { (error: NSError?) -> Void in
            if let error =  error {
                Utils.printMQA("Indexing error: \(error.localizedDescription)")
            }
        }
    }
    
    
    /**
    Method removes items from core spotlight for iOS 9 deep linking
    */
    func RemoveItemFromCoreSpotlight() {
        CSSearchableIndex.defaultSearchableIndex().deleteSearchableItemsWithIdentifiers([identifier1])
            { (error: NSError?) -> Void in
                if let error = error {
                    Utils.printMQA("Remove error: \(error.localizedDescription)")
                }
        }
    }
    
    
    /**
    Method sets the status bar tint to light
    */
    private func configureStatusBarTint() { StatusBarColorUtil.SetLight()  }
    
    /**
    Method decreases quantity of OCLogger's logs
    */
    private func configureOCLogger() {
        
        OCLogger.setLevel(OCLogger_FATAL)
        
    }
    
    func applicationWillResignActive(application: UIApplication) { }
    func applicationDidEnterBackground(application: UIApplication) { }
    func applicationWillEnterForeground(application: UIApplication) { }
    func applicationDidBecomeActive(application: UIApplication) { }
    func applicationWillTerminate(application: UIApplication) { }
    
}


// MARK: - MFP Extension
extension AppDelegate {
    
    private class MFP {
        
        /**
        Method tells the TravelDataManager to connect to MFP and fetch travel data
        */
        static func Connect() {
            
            // 1s = 10^9 nanoseconds, 5*10^7 ns = .005 seconds = 5 milliseconds, enough time for classes to be initialized
            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(50000000))
            dispatch_after(delay, dispatch_get_main_queue()) {
                
                TravelDataManager.SharedInstance.connectToMFP()
                TravelDataManager.SharedInstance.fetchTravelData(){ }
                
            }
        }
    }
}

/**

MARK: Notification Handlers

*/
extension AppDelegate {
    
    func application(application: UIApplication,
        didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
        fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
            
            self.DEBUG("Received push notification")
            
            //UserInfo dictionary will contain data sent from the server
            self.DEBUG(userInfo)
            
    }
    
}


/// MARK: MQA Setup
extension AppDelegate {
    
    private class MQA {
        
        /**
        Method initialized MQA
        
        - returns:
        */
        class func initialize(){
            #if Debug
                MQALogger.settings().mode = MQAMode.QA
            #else
                MQALogger.settings().mode = MQAMode.Market
            #endif
            
            let mqaAppKey = Utils.getMQAAppKey()
            MQALogger.startNewSessionWithApplicationKey(mqaAppKey)
            
            
            // Enables the quality assurance application crash reporting
            NSSetUncaughtExceptionHandler(exceptionHandlerPointer)
        }
        
    }
    
}

// MARK: - Google Analytics Extension
extension AppDelegate {

    private class GoogleAnalytics {
        
        /**
        Method initilized Google Analytics
        
        - returns:
        */
        class func initialize() {
            
            var configureError:NSError?
            GGLContext.sharedInstance().configureWithError(&configureError)
            assert(configureError == nil, "Error configuring Google services: \(configureError)")
            
            let gai = GAI.sharedInstance()
            gai.trackUncaughtExceptions = true
    
        }
    }
}


// MARK: - WLDelegate Extension
extension AppDelegate: WLDelegate {
    
    
    /**
    Method is called upon onSuccess following WLDelegate protocol
    
    - parameter response: WLRespone!
    */
    func onSuccess(response: WLResponse!) {
        Utils.printMQA("*****inside onsuccess.")
    }
    
    
    /**
    Method is called upon onFailure following WLDelegate protocol
    
    - parameter response: WLFailResponse!
    */
    func onFailure(response: WLFailResponse!) {
        var resultText : String = "Invocation Failure"
        if(response.responseText != nil) {
            resultText = "\(resultText): \(response.responseText)"
        }
        Utils.printMQA("****" + resultText)
    }
    
}
