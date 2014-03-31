//
//  IAUISelectionManager.h
//  Gusty
//
//  Created by Marcelo Schroeder on 14/07/11.
//  Copyright 2011 InfoAccent Pty Limited. All rights reserved.
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

@interface IAUISelectionManager : NSObject {
	
    @protected
	id<IAUISelectionManagerDelegate> __weak v_delegate;
    
}

@property (nonatomic, strong) NSMutableArray *p_selectedObjects;
@property (weak, nonatomic, readonly) NSArray *p_selectedIndexPaths;
@property (nonatomic) BOOL p_allowMultipleSelection;

- (void)handleSelectionForIndexPath:(NSIndexPath*)a_indexPath;
- (void)handleSelectionForIndexPath:(NSIndexPath*)a_indexPath userInfo:(NSDictionary*)a_userInfo;
- (void)deselectAll;
- (void)deselectAllWithUserInfo:(NSDictionary*)a_userInfo;

- (id)initWithSelectionManagerDelegate:(id<IAUISelectionManagerDelegate>)a_delegate selectedObjects:(NSArray*)a_selectedObjects;
- (id)initWithSelectionManagerDelegate:(id<IAUISelectionManagerDelegate>)a_delegate;
- (void)notifyDeletionForObject:(id)a_deletedObject;

@end
