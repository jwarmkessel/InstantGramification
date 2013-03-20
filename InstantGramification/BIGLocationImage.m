//
//  BIGLocationImage.m
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/15/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "BIGLocationImage.h"
#import <ASIHTTPRequest.h>

@implementation BIGLocationImage

- (void) dealloc {
    [self.height release], self.height = nil;
    [self.width  release], self.width = nil;
    [self.url release], self.url = nil;
    [self.detailImageURL release], self.detailImageURL = nil;
    [self.detailImage release], self.detailImage = nil;
    
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

- (void)getDetailImage {
    NSLog(@"get detail image");
    NSURL *url = [NSURL URLWithString:self.detailImageURL];
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
    NSError *error = [request error];
    [request startSynchronous];
    
    if (!error) {
        NSMutableData *response = [request rawResponseData];
        NSLog(@"detailImage %@", response);
        self.detailImage = [UIImage imageWithData:response];
    }
}

@end
