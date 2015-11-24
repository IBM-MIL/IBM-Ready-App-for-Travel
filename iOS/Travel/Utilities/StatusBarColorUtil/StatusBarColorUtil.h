/*
 Licensed Materials - Property of IBM
 © Copyright IBM Corporation 2015. All Rights Reserved.
 This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
 */

#ifndef StatusBarColorUtil_h
#define StatusBarColorUtil_h

/**
 
 [StatusBarColorUtil]
 
 Set the status bar color
 
 
 [Known iOS issue]
 
 http://stackoverflow.com/questions/25869178/status-bar-showing-black-text-only-on-iphone-6-ios-8-simulator
 
 Makes use of deprecated method to circumvent iOS issue.
 
 
 [Prerequisite] In Info.plist
 
 <key>UIViewControllerBasedStatusBarAppearance</key>
 <false/>
 
 */
@interface StatusBarColorUtil: NSObject

+ (void)SetLight;
+ (void)SetDark;

@end

#endif /* StatusBarColorUtil_h */
