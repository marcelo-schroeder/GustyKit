//
// Created by Marcelo Schroeder on 20/08/15.
// Copyright (c) 2015 InfoAccent Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
* Crash reporting related utilities.
*/
@interface IFACrashReportingUtils : NSObject

/**
* Collects useful information to include in crash reports. Example of information included: system locale, current locale and preferred languages.
* @returns Dictionary containing formatted default context information.
*/
+ (NSDictionary *)defaultContextInfo;

/**
* Formats context information to be included in crash reports. It attempts to convert non string types to string.
* @param contextInfo Dictionary containg unformatted context info.
* @param shouldAddDefaultContextInfo Set to YES to include default context information returned by the <defaultContextInfo> method.
* @returns Formatted context information.
*/
+ (NSDictionary *)formatContextInfo:(NSDictionary *)contextInfo
        shouldAddDefaultContextInfo:(BOOL)shouldAddDefaultContextInfo;
@end