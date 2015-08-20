//
// Created by Marcelo Schroeder on 20/08/15.
// Copyright (c) 2015 InfoAccent Pty Ltd. All rights reserved.
//

#import "GustyKitCoreUI.h"


@implementation IFACrashReportingUtils {

}

#pragma mark - Public

+ (NSDictionary *)defaultContextInfo {
    NSMutableDictionary *defaultContextInfo = [NSMutableDictionary new];
    defaultContextInfo[@"IFA_system_Locale"] = [NSLocale systemLocale];
    defaultContextInfo[@"IFA_current_Locale"] = [NSLocale currentLocale];
    defaultContextInfo[@"IFA_preferred_Languages"] = [NSLocale preferredLanguages];
    return [self formatContextInfo:defaultContextInfo
       shouldAddDefaultContextInfo:NO];
}

+ (NSDictionary *)formatContextInfo:(NSDictionary *)contextInfo
        shouldAddDefaultContextInfo:(BOOL)shouldAddDefaultContextInfo {
    NSMutableDictionary *formattedContextInfo = [NSMutableDictionary new];
    for (NSString *key in contextInfo.allKeys) {
        formattedContextInfo[key] = [self IFA_formatCrashReportValue:contextInfo[key]];
    }
    if (shouldAddDefaultContextInfo) {
        [formattedContextInfo addEntriesFromDictionary:[self defaultContextInfo]];
    }
    return formattedContextInfo;
}

#pragma mark - Private

+ (NSString*)IFA_formatCrashReportValue:(id)value {

//    NSLog(@"IFA_formatCrashReportValue: %@", [value description]);

    if (value) {

        if ([value isKindOfClass:[NSDate class]]) {

            return [value ifa_descriptionWithCurrentLocale];

        }else{

            id displayValue = value;
            if ([value isKindOfClass:[NSManagedObject class]]) {
                if ([value isKindOfClass:[IFASystemEntity class]]) {
                    displayValue = ((IFASystemEntity *) value).systemEntityId;
                }else{
                    displayValue = ((NSManagedObject*) value).ifa_stringId;
                }
            }else if ([value isKindOfClass:[NSLocale class]]){
                displayValue = ((NSLocale*) value).localeIdentifier;
            }

            // Unformatted string
            NSString *unformattedString = [displayValue description];
//            NSLog(@"  unformattedString: %@", unformattedString);
            // Remove new line characters
            NSString *l_formattedString = [unformattedString ifa_stringByRemovingNewLineCharacters];
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

@end