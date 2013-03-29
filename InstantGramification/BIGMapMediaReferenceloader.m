//
//  BIGMapMediaReferenceloader.m
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/20/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "BIGMapMediaReferenceloader.h"

@implementation BIGMapMediaReferenceloader

-(void) dealloc {
    self.location.delegate = nil;
    [_batchlist release], _batchlist = nil;
    [_locationList release], _locationList = nil;
    
    [super dealloc];
}
-(id) initWithArray:(NSArray *)nearbyLocations {

    self = [super init];
    if(self) {
        self.locationList = nearbyLocations;
    }
    return self;
}

-(void) startMediaReferenceRequest {
    NSLog(@"startMediaReferenceRequest");
    for(int i=0; i<self.locationList.count; i++) {
        self.location = [self.locationList objectAtIndex:i];
        [self.location setDelegate:self];
        [self.location getCollectionImages];
    }
}

//Returns media reference for a single location
- (void)locationImagesDidFinish:(BIGLocation *)controller {
    NSLog(@"Return the annotation to the map");
    //Get the media reference for a location
    [self.batchlist addObject:controller];
    //Load them up in an array and pass to map view to be injected as an annotation
    if(controller.imageCollection.count > 0)
        [[self delegate] didCompleteBatchDownload:controller];
}

@end
