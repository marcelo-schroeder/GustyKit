//
// Created by Marcelo Schroeder on 9/09/2014.
// Copyright (c) 2014 InfoAccent Pty Ltd. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
* Convenience wrapper around CLLocationManager. Once instantiated, it also becomes the delegate for CLLocationManager;
* As a convenience, the IFANotificationLocationAuthorizationStatusChange notification will be sent out so that the app can track location authorization status changes.
* This class can be extended to provide extra functionality.
* This class is designed to be used as a singleton. Please use the sharedInstance method to obtain an instance.
*/
@interface IFALocationManager : NSObject <CLLocationManagerDelegate>

@property(nonatomic, strong, readonly) CLLocationManager *underlyingLocationManager;

/**
* Checks if the the location manager's authorisation status is in order. If it is not in order, it conveniently handles the various statuses providing the appropriate messages to the user.
* @returns YES if the location manager's authorisation status is in order (i.e. either kCLAuthorizationStatusNotDetermined or kCLAuthorizationStatusAuthorized). Otherwise it returns NO.
*/
+ (BOOL)performLocationServicesChecks;

/**
* Shows an alert with a standard message for when the user's location cannot be obtained.
*/
+ (void)showLocationServicesAlert;

/**
* Shows an alert with a standard message for when the user's location cannot be obtained. The suffix for the message can be provided.
* @param a_messageSuffix String to be appended to the standard message.
*/
+ (void)showLocationServicesAlertWithMessageSuffix:(NSString *)a_messageSuffix;

+ (instancetype)sharedInstance;

@end