//
//  BIGLocation.h
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/14/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol BIGLocationImgCollDelegate;

@interface BIGLocation : NSObject <MKAnnotation, IGRequestDelegate> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

@property(retain, nonatomic) NSString *name;
@property(retain, nonatomic) NSString *latitude;
@property(retain, nonatomic) NSString *longitude;
@property(retain, nonatomic) NSString *identityNum;
@property(readonly, nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *title;
@property (retain, nonatomic) NSMutableArray *imageCollection;

@property (assign, nonatomic) id <BIGLocationImgCollDelegate> delegate;

- (id)initLocationWithName:(NSString *)name latitude:(NSString *)latitude longitude:(NSString *)longitude identityNumber:(NSString *)identityNum;
- (void) getCollectionImages;
@end

@protocol BIGLocationImgCollDelegate <NSObject>

- (void)locationImagesDidFinish:(BIGLocation *)controller;

@end