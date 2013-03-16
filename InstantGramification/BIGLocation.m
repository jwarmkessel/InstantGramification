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
@synthesize coordinate, title, subtitle, name = _name, latitude = _latitude, longitude = _longitude, identityNum = _identityNum;

-(void)dealloc {
    [self.name release], self.name = nil;
    [self.latitude release], self.latitude = nil;
    [self.longitude release], self.longitude= nil;
    [self.identityNum release], self.identityNum = nil;
    [self.subtitle release], self.subtitle = nil;
    [self.title release], self.title = nil;
    [self.imageCollection release], self.imageCollection = nil;
    
    [super dealloc];
}

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
    //TODO loading mask is loaded here.
    NSLog(@"didReceiveResponse");
}

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError %@", error);
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    NSLog(@"request did Load %@", result);
    //data.images.low_resolution
    NSArray *list = [result objectForKey:@"data"];
    
    int count = 0;
    
    for (NSDictionary *data in list)
    {
        if(count < THUMBNAIL_IMAGES_MAX) {
            NSString *url = [[[data objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"url"];
            NSString *height = [[[data objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"height"];
            NSString *width = [[[data objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"width"];
            NSString *detailImageUrl = [[[data objectForKey:@"images"] objectForKey:@"low_resolution"] objectForKey:@"url"];
            
            BIGLocationImage *locationImageObj = [[[BIGLocationImage alloc] initLocationWithUrlString:url height:height width:width detailImgURL:detailImageUrl] autorelease];
            NSLog(@"%@ %@ %@ %@", locationImageObj.url, locationImageObj.height, locationImageObj.width, locationImageObj.detailImageURL);

            [self.imageCollection addObject:locationImageObj];
            
            count++;
        }
    }
    //Announce that response is done
    [[self delegate] locationImagesDidFinish:self];
}


@end
