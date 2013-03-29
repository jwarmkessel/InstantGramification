//
//  BIGMapMediaReferenceloader.h
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/20/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BIGLocation.h"

@protocol BIGMapMediaRefrenceLoaderDelegate;

@interface BIGMapMediaReferenceloader : NSObject <BIGLocationImgCollDelegate>

@property(retain, nonatomic) NSMutableArray *batchlist;
@property(retain, nonatomic) NSArray *locationList;
@property(assign, nonatomic) id <BIGMapMediaRefrenceLoaderDelegate> delegate;
@property(retain, nonatomic) BIGLocation *location;

-(id) initWithArray:(NSArray *)nearbyLocations;
-(void) startMediaReferenceRequest;
@end

@protocol BIGMapMediaRefrenceLoaderDelegate <NSObject>

- (void)didCompleteBatchDownload:(BIGLocation *)newAnnotations;

@end
