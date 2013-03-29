//
//  BIGLocation.m
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/14/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "BIGLocation.h"
#import "BIGLocationImage.h"
#import "BIGAppDelegate.h"

#define LOCATION_MEDIA_REQUEST @"locations/{location-id}/media/recent"
#define THUMBNAIL_IMAGES_MAX 5

@implementation BIGLocation
@synthesize title, subtitle;

-(void)dealloc {
    [_name release], self.name = nil;
    [_latitude release], self.latitude = nil;
    [_longitude release], self.longitude= nil;
    [_identityNum release], self.identityNum = nil;
    [subtitle release], self.subtitle = nil;
    [title release], self.title = nil;
    [_imageCollection release], self.imageCollection = nil;

    [super dealloc];
}

- (id)initLocationWithName:(NSString *)name latitude:(NSString *)latitude longitude:(NSString *)longitude identityNumber:(NSString *)identityNum  distanceFromUserInMeters:(float)distance{
    self = [super init];
    if (self) {
        self.name = name;
        self.latitude = latitude;
        self.longitude = longitude;
        self.identityNum = identityNum;
        self.distanceFromUser = distance;
        
        return self;
    }
    return nil;
}


//Conforms to MKAnnotation protocol
- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coord = {[self.latitude doubleValue], [self.longitude doubleValue]};
    return coord;
}

//Conforms to MKAnnotation protocol
- (NSString*) title
{
    return self.name;
}

//Conforms to MKAnnotation protocol
- (NSString*) subtitle
{
    return [NSString stringWithFormat:@"Longitude: %@, Latitude %@", self.longitude,self.latitude];
}

-(void) getCollectionImages {
    self.imageCollection = [[[NSMutableArray alloc] init] autorelease];
    
    //Request media info based on location id
    BIGAppDelegate* appDelegate = (BIGAppDelegate*)[UIApplication sharedApplication].delegate;
    NSString *requestMethodString = LOCATION_MEDIA_REQUEST;
    requestMethodString = [requestMethodString stringByReplacingOccurrencesOfString:@"{location-id}" withString:self.identityNum];

    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
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
//    NSLog(@"BIGLocation didReceiveResponse %@", response);
}

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error {
//    NSLog(@"didFailWithError %@", error);
    //Handle failed request
}

- (void)request:(IGRequest *)request didLoad:(id)result {
//    NSLog(@"request did Load %@", result);

    NSArray *list = [result objectForKey:@"data"];
    
    int count = 0;
    
    for (NSDictionary *data in list)
    {
        NSString *url = [[[data objectForKey:@"images"] objectForKey:@"low_resolution"] objectForKey:@"url"];
        NSString *height = [[[data objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"height"];
        NSString *width = [[[data objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"width"];
        
        BIGLocationImage *locationImageObj = [[[BIGLocationImage alloc] initLocationWithUrlString:url height:height width:width] autorelease];

        [self.imageCollection addObject:locationImageObj];
        count++;
        
        //We're done when we get all the images we want.
        if (count >= THUMBNAIL_IMAGES_MAX) break;
    }

    //Announce that response is done
    NSLog(@"location Images did finish");
    [[self delegate] locationImagesDidFinish:self];
}


@end
