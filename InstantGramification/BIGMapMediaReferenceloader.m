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
 
    [self.batchlist release], self.batchlist = nil;
    [self.locationList release], self.locationList = nil;
    
    [super dealloc];
}
-(id) initWithArray:(NSArray *)nearbyLocations {

    self = [super init];
    if(self) {
        self.locationList = nearbyLocations;
    }
    return self;
}

-(void) sortArrayByDistanceFromUser:(NSArray *)locations {
    
}

-(void) startMediaReferenceRequest {
    NSLog(@"startMediaReferenceRequest");
    for(int i=0; i<self.locationList.count; i++) {
        BIGLocation * location = [self.locationList objectAtIndex:i];
        [location setDelegate:self];
        [location getCollectionImages];
    }
    
    [[self delegate] didCompleteDownload];
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
