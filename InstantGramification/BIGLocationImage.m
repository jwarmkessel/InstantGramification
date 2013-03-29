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
    
    [super dealloc];
}
- (id)initLocationWithUrlString:(NSString *)urlStr height:(NSString *)height width:(NSString *)width {
    self = [super init];
    if (self) {
        self.url = urlStr;
        self.height = height;
        self.width = width;
        
        return self;
    }
    return nil;
}

@end
