//
//  GustyKit - IFAPersistenceManagerTests.m
//  Copyright 2015 InfoAccent Pty Ltd. All rights reserved.
//
//  Created by: Marcelo Schroeder
//

#import "IFACoreUITestCase.h"
#import "GustyKitCoreUI.h"
#import "TestCoreDataEntity1.h"

@interface IFAPersistenceManagerTests : IFACoreUITestCase
@property(nonatomic, strong) IFAPersistenceManager *persistenceManager;
@end

@implementation IFAPersistenceManagerTests{
}

- (void)testCountEntity {
    // given
    [self createObjectsForCountingTests];
    // when
    NSUInteger count = [self.persistenceManager countEntity:[TestCoreDataEntity1 ifa_entityName]];
    // then
    assertThatUnsignedInteger(count, is(equalToUnsignedInteger(5)));
}

- (void)testCountEntityKeysAndValues {
    // given
    [self createObjectsForCountingTests];
    // when
    NSUInteger count = [self.persistenceManager countEntity:[TestCoreDataEntity1 ifa_entityName] keysAndValues:@{@"attribute1" : @"value2"}];
    // then
    assertThatUnsignedInteger(count, is(equalToUnsignedInteger(3)));
}

- (void)testCountEntityWithPredicate {
    // given
    [self createObjectsForCountingTests];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"attribute1 = %@"
                                                argumentArray:@[@"value1"]];
    // when
    NSUInteger count = [self.persistenceManager countEntity:[TestCoreDataEntity1 ifa_entityName] withPredicate:predicate];
    // then
    assertThatUnsignedInteger(count, is(equalToUnsignedInteger(2)));
}

#pragma mark - Overrides

- (void)setUp {
    [super setUp];
    [self createInMemoryTestDatabase];
    self.persistenceManager = [IFAPersistenceManager sharedInstance];
}

#pragma mark - Private

- (void)createObjectsForCountingTests {
    TestCoreDataEntity1 *obj1 = (TestCoreDataEntity1 *) [self.persistenceManager instantiate:[TestCoreDataEntity1 ifa_entityName]];
    obj1.attribute1 = @"value1";
    TestCoreDataEntity1 *obj2 = (TestCoreDataEntity1 *) [self.persistenceManager instantiate:[TestCoreDataEntity1 ifa_entityName]];
    obj2.attribute1 = @"value1";
    TestCoreDataEntity1 *obj3 = (TestCoreDataEntity1 *) [self.persistenceManager instantiate:[TestCoreDataEntity1 ifa_entityName]];
    obj3.attribute1 = @"value2";
    TestCoreDataEntity1 *obj4 = (TestCoreDataEntity1 *) [self.persistenceManager instantiate:[TestCoreDataEntity1 ifa_entityName]];
    obj4.attribute1 = @"value2";
    TestCoreDataEntity1 *obj5 = (TestCoreDataEntity1 *) [self.persistenceManager instantiate:[TestCoreDataEntity1 ifa_entityName]];
    obj5.attribute1 = @"value2";
    [self.persistenceManager save];
}

@end
