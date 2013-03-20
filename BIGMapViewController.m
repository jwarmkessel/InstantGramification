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
#define SEARCH_DIST 26
#define UPDATE_GPS 2
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
    [self.locationManagerTimer release], self.locationManagerTimer = nil;
    [self.loadingMask release], self.loadingMask = nil;
    
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
    _traveledDistance = SEARCH_DIST;
    
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

- (void) viewWillAppear:(BOOL)animated {
    //Enable or re-enable user interaction
    self.view.userInteractionEnabled = YES;

    if(!self.nearbyLocationPoints) {
        self.loadingMask = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.view addSubview:self.loadingMask];
        UILabel *loadingMaskLbl = [[[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)] autorelease];
        
        self.loadingMask.backgroundColor = [UIColor blackColor];
        self.loadingMask.alpha = 0.5;
        
        loadingMaskLbl.alpha = 1.0;
        [self.loadingMask addSubview:loadingMaskLbl];
        loadingMaskLbl.text =@"loading";
        loadingMaskLbl.textColor = [UIColor whiteColor];
        loadingMaskLbl.backgroundColor = [UIColor blackColor];
        [loadingMaskLbl setCenter:self.loadingMask.center];
        loadingMaskLbl.textAlignment = UITextAlignmentCenter;
    }
}
//Start updating the GPS
- (void) startTask {
    self.locationManagerTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_GPS
                                     target:self
                                   selector:@selector(actualTask)
                                   userInfo:nil
                                    repeats:YES];
}

- (void) actualTask {
    NSLog(@"GPS ping");
    [self.locationManager startUpdatingLocation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"displayImageCollection"])
    {
        self.imageCollectionViewController = (BIGImageViewController *)[segue destinationViewController];
        [self.imageCollectionViewController setDisplayLoadingMask:1];
        self.imageCollectionViewController.locationObj = _currentSelectedLocation;
    }
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

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    NSLog(@"didAddAnnotationViews");
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"didSelectAnnotationView");
    self.view.userInteractionEnabled = NO;

    if(view.annotation != mapView.userLocation) {
        BIGLocation *tempLocation = (BIGLocation *)view.annotation;
        tempLocation.delegate = self;
        [tempLocation getCollectionImages];
        
        //TODO need delegate from BIGLocation to indicate when request is done processing
        _currentSelectedLocation = tempLocation;
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"didDeselectAnnotationView");    
}

// mapView:annotationView:calloutAccessoryControlTapped: is called when the user taps on left & right callout accessory UIControls.
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
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
    return pinView;
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
    //TODO Need indicator of GPS health
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    //Check GPS accuracy
    if(manager.location.horizontalAccuracy) {
        if (manager.location.horizontalAccuracy < 0)
        {
            NSLog(@"No GPS %f", manager.location.horizontalAccuracy);
        }
        else if (manager.location.horizontalAccuracy > 163)
        {
            float accuracy = manager.location.horizontalAccuracy;
            NSLog(@"Poor signal %f", accuracy);
        }
        else if (manager.location.horizontalAccuracy > 48)
        {
            NSLog(@"Average signal");
            NSLog(@"Strong signal");
            //If original location was set then set the distance traveled.
            if(self.originalCoordinate != nil) {
                _traveledDistance = [self.originalCoordinate distanceFromLocation:manager.location];
            }
        }
        else
        {
            NSLog(@"Strong signal");
            //If original location was set then set the distance traveled.
            if(self.originalCoordinate != nil) {
                _traveledDistance = [self.originalCoordinate distanceFromLocation:manager.location];
            }
        }
    }
    
    //This is true if gps is accurate and the traveled distance from the original location is greater than the distance required.
    if(_traveledDistance >= SEARCH_DIST) {
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
    
    //TODO this can be improved. 
    
    //Upon receiving the parsed request store locations in a data controller
    NSArray *list = [result objectForKey:@"data"];
    
    for (NSDictionary *data in list)
    {
        //Add to the list of friends
        [self.locationDataController addLocationWithName:[data objectForKey:@"name"] latitude:[data objectForKey:@"latitude"] longitude:[data objectForKey:@"longitude"] identityNumber:[data objectForKey:@"id"]];
    }
    
    //Keep dataController isolated though it's not necessary at this point.
    self.nearbyLocationPoints = [[NSMutableArray alloc] initWithArray:self.locationDataController.locationList];
    
    for(int i = 0; i<self.nearbyLocationPoints.count; i++) {
        BIGLocation *location = [[self.nearbyLocationPoints objectAtIndex:i] autorelease];
        [self.mapView addAnnotation:location];
    }
    
    //remove loading mask
    [UIView animateWithDuration:0.3
                     animations:^(void){
                         self.loadingMask.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [self.loadingMask removeFromSuperview];
                     }
     ];
}

#pragma mark - BIGLocationImgCollDelegate
- (void)locationImagesDidFinish:(BIGLocation *)controller {
    [self performSegueWithIdentifier:@"displayImageCollection" sender:self];
}

@end
