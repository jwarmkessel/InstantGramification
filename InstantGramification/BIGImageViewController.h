//
//  BIGImageViewController.h
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/14/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "PSTCollectionView.h"
#import <ASIHTTPRequest.h>

@class BIGLocationImage;
@class BIGLocation;

@interface BIGImageViewController : PSUICollectionViewController_

@property (retain, nonatomic) NSArray *imageCollection;
@property (retain, nonatomic) BIGLocation *locationObj;
- (void)setImageCollectionObj:(BIGLocation *)locationObj;

@end
