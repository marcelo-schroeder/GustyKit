//
// Created by Marcelo Schroeder on 22/04/15.
// Copyright (c) 2015 InfoAccent Pty Ltd. All rights reserved.
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

#import "GustyKitFoundation.h"


@implementation NSObject (IFAFoundation)

#pragma mark - Public

// Inspired by http://www.takingnotes.co/blog/2013/01/03/coalescing/
- (void)ifa_coalescedPerformSelector:(SEL)sel {

    // Cancel any previous perform requests to keep calls from piling up.
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:sel object:nil];

    // Schedule the call, it will hit during the next turn of the current run loop
    [self performSelector:sel withObject:nil afterDelay:0.0];

}

+ (NSBundle *)ifa_classBundle {
    return [NSBundle bundleForClass:self];
}

@end