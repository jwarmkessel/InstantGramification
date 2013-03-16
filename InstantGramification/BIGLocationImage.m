//
//  BIGLocationImage.m
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/15/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "BIGLocationImage.h"

@implementation BIGLocationImage

- (void) dealloc {
    [self.height release], self.height = nil;
    [self.width  release], self.width = nil;
    [self.url release], self.url = nil;
    [self.detailImageURL release], self.detailImageURL = nil;
    
    [super dealloc];
}
- (id)initLocationWithUrlString:(NSString *)urlStr height:(NSString *)height width:(NSString *)width detailImgURL:(NSString *)detailImgURL {
    self = [super init];
    if (self) {
        self.url = urlStr;
        self.height = height;
        self.width = width;
        self.detailImageURL = detailImgURL;
        
        return self;
    }
    return nil;
}

@end
