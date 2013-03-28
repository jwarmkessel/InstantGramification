//
//  BIGImageViewController.h
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/14/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "PSTCollectionView.h"

@class BIGLocationImage;
@class BIGLocation;

@interface BIGImageViewController : PSUICollectionViewController_ {
    int showLoadingMask;
}

@property (retain, nonatomic) NSArray *imageCollection;
@property (retain, nonatomic) BIGLocation *locationObj;
@property (retain, nonatomic) UIView *loadingMask;

- (void)setImageCollectionObj:(BIGLocation *)locationObj;
- (void)setDisplayLoadingMask:(int)display;

@end
