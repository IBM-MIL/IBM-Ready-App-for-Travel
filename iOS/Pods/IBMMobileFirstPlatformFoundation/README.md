IBM MobileFirst Platform Foundation iOS SDK
===

This package contains the required native components for your application to interact with IBM
MobileFirst Platform Foundation or IBM MobileFirst Platform Foundation for iOS. IBM MobileFirst Platform Foundation and IBM MobileFirst Platform Foundation for iOS provide an on-premises backend server and infrastructure
for managing MobileFirst applications. The SDK manages all of the communication and security integration between your iOS mobile app and IBM MobileFirst Platform Foundation or IBM MobileFirst Platform Foundation for iOS.

In addition, this SDK offers a compatibility layer, which enables you to migrate client applications that were developed for IBM MobileFirst Platform for iOS on IBM Bluemix to an on-premises IBM
MobileFirst server without requiring major changes to existing code. 


###Installing and using the SDK
Install the SDK with [CocoaPods](http://cocoapods.org/).  To install CocoaPods, see [CocoaPods Getting Started](http://guides.cocoapods.org/using/getting-started.html#getting-started). 
The SDK is downloaded when you run the pod install command, after you specify the SDK source path in your podfile.
For more information, see:
- (MobileFirst Platform Foundation) [Developing a new iOS native application with CocoaPods ](http://www.ibm.com/support/knowledgecenter/SSHS8R_7.1.0/com.ibm.worklight.dev.doc/dev/t_dev_new_w_cocoapods.html)

- (MobileFirst Platform Foundation for iOS) [Developing a new iOS native application with CocoaPods ](http://www.ibm.com/support/knowledgecenter/SSHSCD_7.1.0/com.ibm.worklight.dev.doc/dev/t_dev_new_w_cocoapods.html)

###SDK contents
The IBM MobileFirst Platform Foundation iOS SDK consists of a collection of pods, available through CocoaPods, that you can add to your project.
The pods correspond to core and additional functions that are exposed by IBM MobileFirst Platform Foundation or 
IBM MobileFirst Platform Foundation for iOS.  The SDK contains the following pods:

- **IBMMobileFirstPlatformFoundation**: This module is the core of the system. It implements client-server connections, and handles security, calling adapters, and other required functions.
- **IBMMobileFirstPlatformFoundationJSONStore**: This enables the JSONStore feature in iOS native mobilefirst apps. It contains JSONStore native apis. 
- **IMFCompatibility**: Simplifies migration from IBM Bluemix. Specify this pod in your podfile if you are migrating client applications that were developed for IBM MobileFirst Platform for iOS on Bluemix to IBM MobileFirst Platform Foundation or IBM MobileFirst Platform Foundation for iOS. 
- **IMFDataLocal**:  Provides security integration between IBM MobileFirst Platform Foundation or IBM MobileFirst Platform Foundation for iOS and the Cloudant(R) Toolkit. Specify this pod in your podfile if you intend to add OAuth security integration when accessing Cloudant in your app.
- **CloudantToolkitLocal**: Enables interaction with Cloudant data stores. Specify this pod in your podfile if you intend to use Cloudant in your app for local and remote database storage. 

All of the pods depend on the IBMMobileFirstPlatformFoundation pod, so specifying it or any of the other pods will cause IBMMobileFirstPlatformFoundation to be included. IMFDataLocal is dependent on CloudantToolkitLocal, 
so specifying IMFDataLocal will cause CloudantToolkit to be included.


###Supported iOS levels
- iOS 6
- iOS 7
- iOS 8

###Getting started 

Get started with the following tutorials: 

- [Quick Start demonstration](https://developer.ibm.com/mobilefirstplatform/documentation/getting-started-7-1/foundation/native-ios/quick-start-demonstration/)

- [Configuring a native iOS application with the MobileFirst Platform Foundation iOS SDK](https://developer.ibm.com/mobilefirstplatform/documentation/getting-started-7-1/foundation/hello-world/configuring-a-native-ios-with-the-mfp-sdk/)


###Learning More
   * Visit the [MobileFirst Developers Center](https://developer.ibm.com/mobilefirstplatform/).
   * Visit [IBM MobileFirst Platform Foundation, version 7.1.0 in IBM Knowledge Center](http://www.ibm.com/support/knowledgecenter/SSHS8R_7.1.0/wl_welcome.html).
   * Visit the [IBM MobileFirst Platform Foundation for iOS, version 7.1.0 in IBM Knowledge Center](http://www.ibm.com/support/knowledgecenter/SSHSCD_7.1.0/wl_welcome.html).

###Connect with IBM MobileFirst
[Web](http://www.ibm.com/mobilefirst) |
[Twitter](http://twitter.com/ibmmobile/) |
[Blog](http://asmarterplanet.com/mobile-enterprise) |
[Facebook](http://www.facebook.com/ibmMobile/) |
[Linkedin](http://www.linkedin.com/groups/IBM-Mobile-4579117/about)


Copyright 2015 IBM Corp.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

[Terms of Use](web link to License.txt)
