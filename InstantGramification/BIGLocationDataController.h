//
//  BIGLocationDataController.h
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/14/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BIGLocation;

@interface BIGLocationDataController : NSObject

@property (retain, nonatomic) NSMutableArray *locationList;

- (NSUInteger)countOfList;
- (BIGLocation *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addLocationWithName:(NSString *)name latitude:(NSString *)latitude longitude:(NSString *)longitude identityNumber:(NSString *)identityNum distanceFromUserInMeters:(float)distance;

@end
