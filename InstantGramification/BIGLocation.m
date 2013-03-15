//
//  BIGLocation.m
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/14/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "BIGLocation.h"
#import "BIGAppDelegate.h"

#define LOCATION_MEDIA_REQUEST @"locations/{location-id}/media/recent"

@implementation BIGLocation
@synthesize coordinate, title, subtitle, name = _name, latitude = _latitude, longitude = _longitude, identityNum = _identityNum;

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

-(void) getCollectionImages {
    self.imageCollection = [[NSMutableArray alloc] init];
    BIGAppDelegate* appDelegate = (BIGAppDelegate*)[UIApplication sharedApplication].delegate;
    
    //Interesting global dispatch queue requiring no oversight.
    //dispatch_queue_t getImages = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSString *requestMethodString = LOCATION_MEDIA_REQUEST;

    requestMethodString = [requestMethodString stringByReplacingOccurrencesOfString:@"{location-id}" withString:self.identityNum];
    NSLog(@"The Locations URL Request string %@", requestMethodString);
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [appDelegate.instagram requestWithMethodName:requestMethodString params:params httpMethod:@"GET" delegate:self];// append to array, non-blocking
}
#pragma mark - IGRequestDelegate

- (void)requestLoading:(IGRequest *)request {
    NSLog(@"requestLoading");
}

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(IGRequest *)request didReceiveResponse:(NSURLResponse *)response {
    //TODO loading mask is loaded here.
    NSLog(@"didReceiveResponse");
}

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError %@", error);
}

- (void)request:(IGRequest *)request didLoad:(id)result {
//    NSLog(@"request did Load %@", result);
    //data.images.low_resolution
    NSArray *list = [result objectForKey:@"data"];
    
    for (NSDictionary *data in list)
    {
        NSLog(@"This is data %@", [data objectForKey:@"images"]);
        NSString *lowResUrl = [[data objectForKey:@"images"] objectForKey:@"low_resolution"];
        NSLog(@"Low Res URL %@", lowResUrl);
        
//        self.imageCollection addObject:<#(id)#>
    }
    //TODO loading mask is removed here.
}


@end
