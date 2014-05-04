//
//  IFAApplicationDelegate.m
//  Gusty
//
//  Created by Marcelo Schroeder on 21/05/12.
//  Copyright (c) 2012 InfoAccent Pty Limited. All rights reserved.
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

#import "IFACommon.h"

@interface IFAApplicationDelegate ()

@property (nonatomic, strong) id<IFAAppearanceTheme> ifa_appearanceTheme;
@property (nonatomic) BOOL useDeviceAgnosticMainStoryboard;
@property (nonatomic, strong) GADBannerView *ifa_gadBannerView;

@end

@implementation IFAApplicationDelegate


#pragma mark - Private

-(void)ifa_onKeyboardNotification:(NSNotification*)a_notification{
    
    //    NSLog(@"m_onKeyboardNotification");
    
    if([a_notification.name isEqualToString:UIKeyboardDidShowNotification] || [a_notification.name isEqualToString:UIKeyboardDidHideNotification]) {
        
        self.keyboardVisible = [a_notification.name isEqualToString:UIKeyboardDidShowNotification];
        
    }else{
        NSAssert(NO, @"Unexpected notification name: %@", a_notification.name);
    }

    if (self.keyboardVisible) {

        NSDictionary *l_userInfo = [a_notification userInfo];
        self.keyboardFrame = [[l_userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
    }else{

        self.keyboardFrame = CGRectZero;
        
    }
    
}

- (void)ifa_onAdsSuspendRequest:(NSNotification*)aNotification{
    self.adsSuspended = YES;
}

- (void)ifa_onAdsResumeRequest:(NSNotification*)aNotification{
    self.adsSuspended = NO;
}

#pragma mark - Public

// to be overriden by subclasses
-(Class)appearanceThemeClass {
    return nil;
}

// to be overriden by subclasses
-(IFAColorScheme *)colorScheme {
    return nil;
}

// to be overriden by subclasses
- (NSString*)gadUnitId {
    return nil;
}

// to be overriden by subclasses
-(GADAdMobExtras*)gadExtras {
    return nil;
}

-(GADBannerView*)gadBannerView {
    if (!self.ifa_gadBannerView) {
        self.ifa_gadBannerView = [GADBannerView new];
        self.ifa_gadBannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [[self appearanceTheme] setAppearanceForAdBannerView:self.ifa_gadBannerView];
    }
    self.ifa_gadBannerView.adUnitID = [self gadUnitId];
    return self.ifa_gadBannerView;
}

-(id<IFAAppearanceTheme>)appearanceTheme {
    Class l_appearanceThemeClass = [self appearanceThemeClass];
    if (!self.ifa_appearanceTheme || ![self.ifa_appearanceTheme isMemberOfClass:l_appearanceThemeClass]) {
        self.ifa_appearanceTheme = [l_appearanceThemeClass new];
    }
    return self.ifa_appearanceTheme;
}

+(IFAApplicationDelegate *)sharedInstance {
    return (IFAApplicationDelegate *)[UIApplication sharedApplication].delegate;
}

// Note on device specific storyboards:
// The "~" (tilde) as a device modifier works for the initial load, but it has issues when view controllers attempt to access
//  the storyboard via self.storyboard. For some reason the device modifier is not taken into consideration in those cases
// By loading the storyboard using the device modifier explicitly in the name avoids any problems.
-(NSString*)storyboardName {
    return [NSString stringWithFormat:@"%@%@", [self storyboardFileName],
                                      self.useDeviceAgnosticMainStoryboard ? @"" : [IFAUIUtils resourceNameDeviceModifier]];
}

- (NSString *)storyboardFileName {
    return @"MainStoryboard";
}

-(NSString*)storyboardInitialViewControllerId {
    return [NSString stringWithFormat:@"%@InitialController", [IFAUIUtils isIPad]?@"ipad":@"iphone"];
}

-(UIStoryboard*)storyboard {
    return [UIStoryboard storyboardWithName:[self storyboardName] bundle:nil];
}

-(UIViewController*)initialViewController {
    UIStoryboard *l_storyboard = [self storyboard];
    NSString *l_storyboardInitialViewControllerId = [self storyboardInitialViewControllerId];
    UIViewController *l_initialViewController = nil;
    if (l_storyboardInitialViewControllerId) {
        l_initialViewController = [l_storyboard instantiateViewControllerWithIdentifier:l_storyboardInitialViewControllerId];
    }
    if (!l_initialViewController) {
        l_initialViewController = [l_storyboard instantiateInitialViewController];
    }
    return l_initialViewController;
}

-(void)configureWindowRootViewController {
    self.window.rootViewController = [self initialViewController];
}

-(NSString*)formatCrashReportValue:(id)a_value{
    
//    NSLog(@"formatCrashReportValue: %@", [a_value description]);
    
    if (a_value) {
        
        if ([a_value isKindOfClass:[NSDate class]]) {
            
            return [a_value IFA_descriptionWithCurrentLocale];
            
        }else{
            
            id l_displayValue = a_value;
            if ([a_value isKindOfClass:[NSManagedObject class]]) {
                if ([a_value isKindOfClass:[S_SystemEntity class]]) {
                    l_displayValue = ((S_SystemEntity*)a_value).systemEntityId;
                }else{
                    l_displayValue = ((NSManagedObject*)a_value).IFA_stringId;
                }
            }else if ([a_value isKindOfClass:[NSLocale class]]){
                l_displayValue = ((NSLocale*)a_value).localeIdentifier;
            }
            
            // Unformatted string
            NSString *l_unformattedString = [l_displayValue description];
//            NSLog(@"  l_unformattedString: %@", l_unformattedString);
            // Remove new line characters
            NSString *l_formattedString = [l_unformattedString IFA_stringByRemovingNewLineCharacters];
            // Remove double quotes to avoid issues with displaying the values on the Crashlytics web site
            l_formattedString = [l_formattedString stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
//            NSLog(@"  l_formattedString: %@", l_formattedString);
            return l_formattedString;

        }
        
    }else{
//        NSLog(@"  NIL");
        return @"NIL";
    }
    
}

#pragma clang diagnostic push
#pragma ide diagnostic ignored "UnresolvedMessage"
-(BOOL)configureCrashReportingWithUserInfo:(NSDictionary*)a_userInfo{

//    NSLog(@"configureCrashReportingWithUserInfo: %@", [a_userInfo description]);

    Class l_crashlyticsClass = NSClassFromString(@"Crashlytics");
    if (!l_crashlyticsClass) {
        NSLog(@"Crashlytics not available at runtime. Crash reporting configured skipped.");
        return NO;
    }

    NSLog(@"Configuring crash reporting...");
    
    NSString *l_apiKey = [[IFAUtils infoPList] valueForKey:@"IACrashlyticsApiKey"];
    NSAssert(l_apiKey, @"IACrashlyticsApiKey not found");
    
    NSString *l_vendorDeviceId = [UIDevice currentDevice].identifierForVendor.UUIDString;
    
    // Configure crash reporting API
//    [Crashlytics startWithAPIKey:l_apiKey];
    [l_crashlyticsClass performSelector:@selector(startWithAPIKey:) withObject:l_apiKey];
//    [Crashlytics setUserIdentifier:l_vendorDeviceId];
    [l_crashlyticsClass performSelector:@selector(setUserIdentifier:) withObject:l_vendorDeviceId];

    // Bundle version
    // Crashlytics should derive this automatically from the app bundle, but it is not at the moment. I'm adding this info here so it does not get lost.
    NSString *l_bundleVersion = [IFAUtils infoPList][@"CFBundleVersion"];
//    [Crashlytics setObjectValue:l_bundleVersion forKey:@"IA_bundle_version"];
    [l_crashlyticsClass performSelector:@selector(setObjectValue:forKey:) withObject:l_bundleVersion withObject:@"IA_bundle_version"];

    // Locale info
//    [Crashlytics setObjectValue:[self m_formatCrashReportValue:l_vendorDeviceId] forKey:@"IA_vendor_Device_Id"];
    [l_crashlyticsClass performSelector:@selector(setObjectValue:forKey:) withObject:[self formatCrashReportValue:l_vendorDeviceId] withObject:@"IA_vendor_Device_Id"];
//    [Crashlytics setObjectValue:[self formatCrashReportValue:[NSLocale systemLocale]] forKey:@"IA_system_Locale"];
    [l_crashlyticsClass performSelector:@selector(setObjectValue:forKey:) withObject:[self formatCrashReportValue:[NSLocale systemLocale]] withObject:@"IA_system_Locale"];
//    [Crashlytics setObjectValue:[self formatCrashReportValue:[NSLocale currentLocale]] forKey:@"IA_current_Locale"];
    [l_crashlyticsClass performSelector:@selector(setObjectValue:forKey:) withObject:[self formatCrashReportValue:[NSLocale currentLocale]] withObject:@"IA_current_Locale"];
//    [Crashlytics setObjectValue:[self formatCrashReportValue:[NSLocale preferredLanguages]] forKey:@"IA_preferred_Languages"];
    [l_crashlyticsClass performSelector:@selector(setObjectValue:forKey:) withObject:[self formatCrashReportValue:[NSLocale preferredLanguages]] withObject:@"IA_preferred_Languages"];

    // User info
    for (NSString *l_key in a_userInfo.allKeys) {
//        [Crashlytics setObjectValue:a_userInfo[l_key] forKey:l_key];
        [l_crashlyticsClass performSelector:@selector(setObjectValue:forKey:) withObject:a_userInfo[l_key] withObject:l_key];
    }
    
    NSLog(@"Crash reporting configured");

    return YES;
    
}
#pragma clang diagnostic pop

-(void)configureAnalytics {

    NSLog(@"Configuring analytics...");
    
    NSString *l_apiKey = [[IFAUtils infoPList] valueForKey:@"IAAnalyticsApiKey"];
    NSAssert(l_apiKey, @"IAAnalyticsApiKey not found");

    [Flurry startSession:l_apiKey];

    NSLog(@"Analytics configured...");
    
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    // Save some info plist settings
    self.useDeviceAgnosticMainStoryboard = [[[IFAUtils infoPList] objectForKey:@"IAUseDeviceAgnosticMainStoryboard"] boolValue];
    
    // Add observers
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(ifa_onKeyboardNotification:)
                                                 name:UIKeyboardDidShowNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(ifa_onKeyboardNotification:)
                                                 name:UIKeyboardDidHideNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ifa_onAdsSuspendRequest:)
                                                 name:IFA_k_NOTIFICATION_ADS_SUSPEND_REQUEST
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ifa_onAdsResumeRequest:)
                                                 name:IFA_k_NOTIFICATION_ADS_RESUME_REQUEST
                                               object:nil];

    // Configure the app's window
    if (!self.skipWindowSetup) {
        self.window = [[UIWindow alloc] initWithFrame:[IFAUIUtils screenBounds]];
        [self.window makeKeyAndVisible];
    }

    // Make sure to initialise the appearance theme
    [self appearanceTheme];

    // Apply appearance using the appearance manager
    [[IFAAppearanceThemeManager sharedInstance] applyAppearanceTheme];

    // Configure the window's root view controller
    if (!self.skipWindowSetup && !self.skipWindowRootViewControllerSetup) {

        // Configure the window's root view controller
        [self configureWindowRootViewController];

    }
    
    // Configure help
    [IFAHelpManager sharedInstance].helpEnabled = [[[IFAUtils infoPList] objectForKey:@"IAHelpEnabled"] boolValue];
    
    return YES;
	
}

/*
 -(void)applicationWillResignActive:(UIApplication *)application{
 NSLog(@" ");
 //    [IFAUtils appLogWithTitle:@"Life Cycle Event" message:@"applicationWillResignActive"];
 NSLog(@"applicationWillResignActive");
 NSLog(@"applicationState: %u", application.applicationState);
 NSLog(@" ");
 }
 */

/*
 -(void)applicationDidBecomeActive:(UIApplication *)application{
 NSLog(@" ");
 //    [IFAUtils appLogWithTitle:@"Life Cycle Event" message:@"applicationDidBecomeActive"];
 NSLog(@"applicationDidBecomeActive");
 NSLog(@"applicationState: %u", application.applicationState);
 NSLog(@" ");
 }
 */

/*
-(void)applicationDidEnterBackground:(UIApplication *)application{
    NSLog(@" ");
    [IFAUtils appLogWithTitle:@"Life Cycle Event 1/3" message:@"applicationDidEnterBackground"];
    [IFAUtils appLogWithTitle:@"Life Cycle Event 2/3" message:[NSString stringWithFormat:@"applicationState: %u", application.applicationState]];
    [IFAUtils appLogWithTitle:@"Life Cycle Event 3/3" message:[NSString stringWithFormat:@"background time remaining: %f", [UIApplication sharedApplication].backgroundTimeRemaining]];
    NSLog(@" ");
}
 */

/*
-(void)applicationWillEnterForeground:(UIApplication *)application{
    NSLog(@" ");
    [IFAUtils appLogWithTitle:@"Life Cycle Event 1/3" message:@"applicationWillEnterForeground"];
    [IFAUtils appLogWithTitle:@"Life Cycle Event 2/3" message:[NSString stringWithFormat:@"applicationState: %u", application.applicationState]];
    [IFAUtils appLogWithTitle:@"Life Cycle Event 3/3" message:[NSString stringWithFormat:@"background time remaining: %f", [UIApplication sharedApplication].backgroundTimeRemaining]];
    NSLog(@" ");
}
 */

-(void)applicationWillTerminate:(UIApplication *)application{

//    NSLog(@" ");
//    [IFAUtils appLogWithTitle:@"Life Cycle Event 1/3" message:@"applicationWillTerminate"];
//    [IFAUtils appLogWithTitle:@"Life Cycle Event 2/3" message:[NSString stringWithFormat:@"applicationState: %u", application.applicationState]];
//    [IFAUtils appLogWithTitle:@"Life Cycle Event 3/3" message:[NSString stringWithFormat:@"background time remaining: %f", [UIApplication sharedApplication].backgroundTimeRemaining]];
//    NSLog(@" ");
    
    // Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IFA_k_NOTIFICATION_ADS_SUSPEND_REQUEST object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IFA_k_NOTIFICATION_ADS_RESUME_REQUEST object:nil];

}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
	//TODO: review this behaviour - are we making the most of NSCache here? (i.e. by removing everything from the cache)
	//	I did a lot of testing with IFAPurgeableObject and always all entries would get evicted, even with setEvictsObjectsWithDiscardedContent true
	//  And removing the removeAllObjects lines below does not do anything if a memory warning is received (probably because it's hard to test
	//	under normal memory circumstances)
    //	NSLog(@"*** applicationDidReceiveMemoryWarning ***");
	[[IFADynamicCache sharedInstance] removeAllObjects];
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
//    NSLog(@"didChangeAuthorizationStatus: %u", status);
    NSNotification *notification = [NSNotification notificationWithName:IFA_k_NOTIFICATION_LOCATION_AUTHORIZATION_STATUS_CHANGE
                                                                 object:nil userInfo:@{@"status" : @(status)}];
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                               postingStyle:NSPostASAP
                                               coalesceMask:NSNotificationNoCoalescing
                                                   forModes:nil];
}

@end
