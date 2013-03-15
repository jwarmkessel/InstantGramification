//
//  BIGMapViewController.m
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/13/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "BIGMapViewController.h"
#import "BIGAppDelegate.h"
#import "BIGLocationDataController.h"
#import "BIGLocation.h"
#import "BIGImageViewController.h"

#define M_PI   3.14159265358979323846264338327950288   /* pi */
#define METERS_PER_MILE 1609.344
#define METERS_TO_MILE_CONVERSION 0.00062137
#define SEARCH_DIST 2
#define UPDATE_GPS 15
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)
#define MILES_TO_METERS(miles) (miles /METERS_PER_MILE)

@interface BIGMapViewController ()

@end

@implementation BIGMapViewController

- (void)dealloc {
    [self.locationManager release], self.locationManager = nil;
    [self.originalCoordinate release], self.originalCoordinate = nil;
    [self.mapView release], self.mapView = nil;
    [self.locationDataController release], self.locationDataController = nil;
    
    [super dealloc];
}

- (void)viewDidUnload {
    [self setLocationManager:nil];
    [self setOriginalCoordinate:nil];
    [self setMapView:nil];
    [self setLocationDataController:nil];
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Initalize data controller for locations
    self.locationDataController = [[BIGLocationDataController alloc]init];
    
    //Disable the back button because we've already been granted an access token from Insatgram
    self.navigationItem.hidesBackButton = YES;
    
    //Set initial distance flag as true
    traveledDistance = SEARCH_DIST;
    
    //Enable seeing the users current location.
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setDelegate:self];
    
    //Init CLLocationanager and set desired properties.
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 5;

    [self.locationManager startUpdatingLocation];
    
    [self startTask];

}

- (void) startTask {
    [NSTimer scheduledTimerWithTimeInterval:UPDATE_GPS
                                     target:self
                                   selector:@selector(actualTask)
                                   userInfo:nil
                                    repeats:YES];
}

- (void) actualTask {
    NSLog(@"Starting location service...");
    [self.locationManager startUpdatingLocation];
}

#pragma mark - mapkit delegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
    
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
    
}

// mapView:viewForAnnotation: provides the view for each annotation.
// This method may be called for all or some of the added annotations.
// For MapKit provided annotations (eg. MKUserLocation) return nil to use the MapKit provided annotation view.
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    NSLog(@"viewForAnnotation is called");
    MKPinAnnotationView *pinView = nil;
    if(annotation != mapView.userLocation)
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil ) pinView = [[[MKPinAnnotationView alloc]
                                          initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
        
        pinView.pinColor = MKPinAnnotationColorPurple;
        
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
    }
    else {
        [mapView.userLocation setTitle:@"I am here"];
    }
    return pinView;}

// mapView:didAddAnnotationViews: is called after the annotation views have been added and positioned in the map.
// The delegate can implement this method to animate the adding of the annotations views.
// Use the current positions of the annotation views as the destinations of the animation.
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    NSLog(@"didAddAnnotationViews");
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"didSelectAnnotationView");
    
    BIGLocation *tempLocation = (BIGLocation *)view.annotation;

    [tempLocation getCollectionImages];
    
    [self performSegueWithIdentifier:@"displayImageCollection" sender:tempLocation];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"didDeselectAnnotationView");    
}

// mapView:annotationView:calloutAccessoryControlTapped: is called when the user taps on left & right callout accessory UIControls.
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
}

#pragma mark -MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"MV didUpdateUserLocation");
    
    MKCoordinateRegion rgn = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude), 100, 100);
    
    [self.mapView setRegion:rgn animated:NO];
}

#pragma mark -CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"didEnterRegion");
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"didExitRegion");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //If original location was set then set the distance traveled.
    if(self.originalCoordinate != nil) {
        traveledDistance = [self.originalCoordinate distanceFromLocation:manager.location];
    }
    
    
    //This is true if gps is accurate and the traveled distance from the original location is greater than the distance required.
    if(manager.location.horizontalAccuracy < 15 && traveledDistance >= SEARCH_DIST) {
        NSLog(@"GPS Appears to be accurate down to 15 meters let's make Instagram Request");
        BIGAppDelegate* appDelegate = (BIGAppDelegate*)[UIApplication sharedApplication].delegate;
 
        NSString *latString = [[[NSString alloc] initWithFormat:@"%g", manager.location.coordinate.latitude] autorelease];
        NSString *lonString = [[[NSString alloc] initWithFormat:@"%g", manager.location.coordinate.longitude] autorelease];
        NSString *searchDistance = [[[NSString alloc] initWithFormat:@"%d", SEARCH_DIST] autorelease];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:latString forKey:@"lat"];
        [params setObject:lonString forKey:@"lng"];
        [params setObject:searchDistance forKey:@"distance"]; //Instagram search distance in meters.
        
        if ([appDelegate.instagram isSessionValid]) {
            NSLog(@"Session appears to be valid so make a request");
            [appDelegate.instagram requestWithMethodName:@"locations/search" params:params httpMethod:@"get" delegate:self];
            
            self.originalCoordinate = manager.location;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"CLLocation is working didUpdateToLocation: %@", newLocation);
    [self.mapView setCenterCoordinate:newLocation.coordinate];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"monitoringDidFailForRegion");
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    NSLog(@"locationManagerShouldDisplayHeadingCalibration");
    return YES;
}

#pragma mark - IGRequestDelegate

- (void)requestLoading:(IGRequest *)request {
    NSLog(@"requestLoading");
}

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(IGRequest *)request didReceiveResponse:(NSURLResponse *)response {
    //TODO loading mask is loaded here.
    NSLog(@"didReceiveResponse");
}

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError %@", error);
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    NSLog(@"request did Load");
    //Upon receiving the parsed request store locations in a data controller
    NSArray *list = [result objectForKey:@"data"];
    
    for (NSDictionary *data in list)
    {
        //Add to the list of friends
        [self.locationDataController addLocationWithName:[data objectForKey:@"name"] latitude:[data objectForKey:@"latitude"] longitude:[data objectForKey:@"longitude"] identityNumber:[data objectForKey:@"id"]];
    }
    
    //Keep dataController isolated though it's not necessary at this point.
    self.locationPts = [[NSMutableArray alloc] initWithArray:self.locationDataController.locationList];
    
    for(int i = 0; i<self.locationPts.count; i++) {
        BIGLocation *location = [self.locationPts objectAtIndex:i];
        NSLog(@"an Identity %@ and %@", location.identityNum, location.name);
        [self.mapView addAnnotation:location];
    }

    
    //TODO loading mask is removed here.
}

@end
