/*
 *  Licensed Materials - Property of IBM
 *  5725-I43 (C) Copyright IBM Corp. 2011, 2013. All Rights Reserved.
 *  US Government Users Restricted Rights - Use, duplication or
 *  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */
//
//  IBMMobileFirstPlatformFoundation.h
//  IBMMobileFirstPlatformFoundation
//
//  Created by C A on 3/11/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for IBMMobileFirstPlatformFoundation.
FOUNDATION_EXPORT double IBMMobileFirstPlatformFoundationVersionNumber;

//! Project version string for IBMMobileFirstPlatformFoundation.
FOUNDATION_EXPORT const unsigned char IBMMobileFirstPlatformFoundationVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <IBMMobileFirstPlatformFoundation/PublicHeader.h>


#import <IBMMobileFirstPlatformFoundation/AbstractAcquisitionError.h>
#import <IBMMobileFirstPlatformFoundation/AbstractGeoAreaTrigger.h>
#import <IBMMobileFirstPlatformFoundation/AbstractGeoDwellTrigger.h>
#import <IBMMobileFirstPlatformFoundation/AbstractPosition.h>
#import <IBMMobileFirstPlatformFoundation/AbstractTrigger.h>
#import <IBMMobileFirstPlatformFoundation/AbstractWifiAreaTrigger.h>
#import <IBMMobileFirstPlatformFoundation/AbstractWifiDwellTrigger.h>
#import <IBMMobileFirstPlatformFoundation/AbstractWifiFilterTrigger.h>
#import <IBMMobileFirstPlatformFoundation/AcquisitionCallback.h>
#import <IBMMobileFirstPlatformFoundation/AcquisitionFailureCallback.h>
#import <IBMMobileFirstPlatformFoundation/BaseChallengeHandler.h>
#import <IBMMobileFirstPlatformFoundation/BaseDeviceAuthChallengeHandler.h>
#import <IBMMobileFirstPlatformFoundation/BaseProvisioningChallengeHandler.h>
#import <IBMMobileFirstPlatformFoundation/ChallengeHandler.h>
#import <IBMMobileFirstPlatformFoundation/JSONStoreQueryOptions.h>
#import <IBMMobileFirstPlatformFoundation/JSONStoreQueryPart.h>
#import <IBMMobileFirstPlatformFoundation/JSONStoreAddOptions.h>
#import <IBMMobileFirstPlatformFoundation/JSONStoreCollection.h>
#import <IBMMobileFirstPlatformFoundation/JSONStoreOpenOptions.h>
#import <IBMMobileFirstPlatformFoundation/JSONStore.h>
#import <IBMMobileFirstPlatformFoundation/OCLogger.h>
#import <IBMMobileFirstPlatformFoundation/OCLogger+Constants.h>
#import <IBMMobileFirstPlatformFoundation/WLAcquisitionFailureCallbacksConfiguration.h>
#import <IBMMobileFirstPlatformFoundation/WLAcquisitionPolicy.h>
#import <IBMMobileFirstPlatformFoundation/WLAnalytics.h>
#import <IBMMobileFirstPlatformFoundation/WLArea.h>
#import <IBMMobileFirstPlatformFoundation/WLAuthorizationManager.h>
#import <IBMMobileFirstPlatformFoundation/WLCallbackFactory.h>
#import <IBMMobileFirstPlatformFoundation/WLChallengeHandler.h>
#import <IBMMobileFirstPlatformFoundation/WLCircle.h>
#import <IBMMobileFirstPlatformFoundation/WLClient.h>
#import <IBMMobileFirstPlatformFoundation/WLConfidenceLevel.h>
#import <IBMMobileFirstPlatformFoundation/WLCookieExtractor.h>
#import <IBMMobileFirstPlatformFoundation/WLCoordinate.h>
#import <IBMMobileFirstPlatformFoundation/WLDelegate.h>
#import <IBMMobileFirstPlatformFoundation/WLDevice.h>
#import <IBMMobileFirstPlatformFoundation/WLDeviceAuthManager.h>
#import <IBMMobileFirstPlatformFoundation/WLDeviceContext.h>
#import <IBMMobileFirstPlatformFoundation/WLEventSourceListener.h>
#import <IBMMobileFirstPlatformFoundation/WLEventTransmissionPolicy.h>
#import <IBMMobileFirstPlatformFoundation/WLFailResponse.h>
#import <IBMMobileFirstPlatformFoundation/WLGeoAcquisitionPolicy.h>
#import <IBMMobileFirstPlatformFoundation/WLGeoCallback.h>
#import <IBMMobileFirstPlatformFoundation/WLGeoDwellInsideTrigger.h>
#import <IBMMobileFirstPlatformFoundation/WLGeoDwellOutsideTrigger.h>
#import <IBMMobileFirstPlatformFoundation/WLGeoEnterTrigger.h>
#import <IBMMobileFirstPlatformFoundation/WLGeoError.h>
#import <IBMMobileFirstPlatformFoundation/WLGeoExitTrigger.h>
#import <IBMMobileFirstPlatformFoundation/WLGeoFailureCallback.h>
#import <IBMMobileFirstPlatformFoundation/WLGeoPosition.h>
#import <IBMMobileFirstPlatformFoundation/WLGeoPositionChangeTrigger.h>
#import <IBMMobileFirstPlatformFoundation/WLGeoTrigger.h>
#import <IBMMobileFirstPlatformFoundation/WLGeoUtils.h>
#import <IBMMobileFirstPlatformFoundation/WLLocationServicesConfiguration.h>
#import <IBMMobileFirstPlatformFoundation/WLOnReadyToSubscribeListener.h>
#import <IBMMobileFirstPlatformFoundation/WLPolygon.h>
#import <IBMMobileFirstPlatformFoundation/WLProcedureInvocationData.h>
#import <IBMMobileFirstPlatformFoundation/WLProcedureInvocationResult.h>
#import <IBMMobileFirstPlatformFoundation/WLPush.h>
#import <IBMMobileFirstPlatformFoundation/WLPushOptions.h>
#import <IBMMobileFirstPlatformFoundation/WLResourceRequest.h>
#import <IBMMobileFirstPlatformFoundation/WLResponse.h>
#import <IBMMobileFirstPlatformFoundation/WLResponseListener.h>
#import <IBMMobileFirstPlatformFoundation/WLSecurityUtils.h>
#import <IBMMobileFirstPlatformFoundation/WLSimpleDataSharing.h>
#import <IBMMobileFirstPlatformFoundation/WLTriggerCallback.h>
#import <IBMMobileFirstPlatformFoundation/WLTriggersConfiguration.h>
#import <IBMMobileFirstPlatformFoundation/WLTrusteer.h>
#import <IBMMobileFirstPlatformFoundation/WLUserCertAuth.h>
#import <IBMMobileFirstPlatformFoundation/WLWifiAccessPoint.h>
#import <IBMMobileFirstPlatformFoundation/WLWifiAccessPointFilter.h>
#import <IBMMobileFirstPlatformFoundation/WLWifiAcquisitionCallback.h>
#import <IBMMobileFirstPlatformFoundation/WLWifiAcquisitionPolicy.h>
#import <IBMMobileFirstPlatformFoundation/WLWifiConnectedCallback.h>
#import <IBMMobileFirstPlatformFoundation/WLWifiConnectTrigger.h>
#import <IBMMobileFirstPlatformFoundation/WLWifiDisconnectTrigger.h>
#import <IBMMobileFirstPlatformFoundation/WLWifiDwellInsideTrigger.h>
#import <IBMMobileFirstPlatformFoundation/WLWifiDwellOutsideTrigger.h>
#import <IBMMobileFirstPlatformFoundation/WLWifiEnterTrigger.h>
#import <IBMMobileFirstPlatformFoundation/WLWifiError.h>
#import <IBMMobileFirstPlatformFoundation/WLWifiExitTrigger.h>
#import <IBMMobileFirstPlatformFoundation/WLWifiFailureCallback.h>
#import <IBMMobileFirstPlatformFoundation/WLWifiLocation.h>
#import <IBMMobileFirstPlatformFoundation/WLWifiTrigger.h>
#import <IBMMobileFirstPlatformFoundation/WLWifiVisibleAccessPointsChangeTrigger.h>
