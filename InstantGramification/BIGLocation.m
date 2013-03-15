//
//  BIGLocation.m
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/14/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "BIGLocation.h"

@implementation BIGLocation
@synthesize coordinate, title, subtitle;

- (id)initLocationWithName:(NSString *)name latitude:(NSString *)latitude longitude:(NSString *)longitude identityNumber:(NSString *)identityNum {
    self = [super init];
    if (self) {
        self.name = name;
        self.latitude = latitude;
        self.longitude = longitude;
        self.identityNum = identityNum;
        
        return self;
    }
    return nil;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coord = {[self.latitude doubleValue], [self.longitude doubleValue]};
    return coord;
}

- (NSString*) title
{
    return self.name;
}
- (NSString*) subtitle
{
    return [NSString stringWithFormat:@"Longitude: %@, Latitude %@", self.longitude,self.latitude];
}


@end
