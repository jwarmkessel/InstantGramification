//
//  BIGLocationImage.h
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/15/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BIGLocationImage : NSObject

@property (retain, strong)NSString *height;
@property (retain, strong)NSString *width;
@property (retain, strong)NSString *url;
@property (retain, strong)NSString *detailImageURL;
@property (retain, strong)UIImage *detailImage;

- (id)initLocationWithUrlString:(NSString *)urlStr height:(NSString *)height width:(NSString *)width detailImgURL:(NSString *)detailImgURL;
- (void)getDetailImage;

@end
