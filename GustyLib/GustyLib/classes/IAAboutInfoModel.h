//
//  IAAboutInfo.h
//  Gusty
//
//  Created by Marcelo Schroeder on 20/09/12.
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

#import <Foundation/Foundation.h>

@interface IAAboutInfoModel : NSObject

@property (strong, nonatomic) NSString *edition;
@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic) NSString *creatorName;
@property (strong, nonatomic) NSString *creatorUrl;
@property (strong, nonatomic) NSString *visualDesignerName;
@property (strong, nonatomic) NSString *visualDesignerUrl;

@end
