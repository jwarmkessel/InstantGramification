//
//  BIGLocationDataController.m
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/14/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "BIGLocationDataController.h"
#import "BIGLocation.h"

@interface BIGLocationDataController()
- (void)initializeDefaultDataList;
@end

@implementation BIGLocationDataController
@synthesize locationList = _locationList;

-(void) dealloc {
    [self.locationList release], self.locationList = nil;
    [super dealloc];
}

- (id)init {
    if (self = [super init]) {
        [self initializeDefaultDataList];
        return self;
    }
    return nil;
}

- (void)initializeDefaultDataList {
    self.locationList= [[NSMutableArray alloc] init];
}

- (BIGLocation *)objectInListAtIndex:(NSUInteger)theIndex
{
    return [self.locationList objectAtIndex:theIndex];
}

- (void)setStayingFriendsList:(NSMutableArray *)newList {
    if (self.locationList != newList) {
        self.locationList = [newList mutableCopy];
    }
}

- (NSUInteger)countOfList
{
    return [self.locationList count];
}

- (void)addLocationWithName:(NSString *)name latitude:(NSString *)latitude longitude:(NSString *)longitude identityNumber:(NSString *)identityNum distanceFromUserInMeters:(float)distance {
    
    BIGLocation *newLocation= [[[BIGLocation alloc] initLocationWithName:name latitude:latitude longitude:longitude identityNumber:identityNum distanceFromUserInMeters:distance] autorelease];

    [self.locationList addObject:newLocation];
}
@end
