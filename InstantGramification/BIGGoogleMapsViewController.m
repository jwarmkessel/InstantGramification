//
//  BIGGoogleMapsViewController.m
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/25/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "BIGGoogleMapsViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface BIGGoogleMapsViewController ()

@end

@implementation BIGGoogleMapsViewController {
    GMSMapView *mapView_;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization


    }
    return self;
}
// You don't need to modify the default initWithNibName:bundle: method.

- (void)loadView {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.8683
                                                            longitude:151.2086
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    GMSMarkerOptions *options = [[GMSMarkerOptions alloc] init];
    options.position = CLLocationCoordinate2DMake(-33.8683, 151.2086);
    options.title = @"Sydney";
    options.snippet = @"Australia";
    [mapView_ addMarkerWithOptions:options];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
