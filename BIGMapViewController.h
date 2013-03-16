//
//  BIGMapViewController.h
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/13/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BIGLocation.h"

@class BIGImageViewController;
@class BIGLocationDataController;

@interface BIGMapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, IGRequestDelegate, BIGLocationImgCollDelegate> {
    float _traveledDistance;
    BIGLocation *_currentSelectedLocation;
}

@property (retain, nonatomic) CLLocationManager *locationManager;
@property (retain, nonatomic) CLLocation *originalCoordinate;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) NSMutableArray *locationPts;
@property (retain, nonatomic) BIGLocationDataController *locationDataController;
@property (retain, nonatomic) BIGImageViewController *imageCollectionViewController; //TODO rename file to more appropriate name

@end
