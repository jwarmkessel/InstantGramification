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
#import "BIGMapMediaReferenceloader.h"
#import "BIGCustomAnnotationView.h"

#define M_PI   3.14159265358979323846264338327950288   /* pi */
#define METERS_PER_MILE 1609.344
#define METERS_TO_MILE_CONVERSION 0.00062137
#define SEARCH_DIST 5
#define UPDATE_GPS 2
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)
#define MILES_TO_METERS(miles) (miles /METERS_PER_MILE)

@interface BIGMapViewController ()

@end

@implementation BIGMapViewController

- (void)dealloc {
    self.locationManager.delegate = nil;
    self.mrloader.delegate = nil;
    self.tabBarController.delegate = nil;

    [_locationManager release], _locationManager = nil;
    [_originalCoordinate release], _originalCoordinate = nil;
    [_mapView release], self.mapView = nil;
    [_locationDataController release], _locationDataController = nil;
    [_locationManagerTimer release], _locationManagerTimer = nil;
    [_loadingMask release], _loadingMask = nil;
    [_mrloader release], _mrloader = nil;
    
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

    if (self.isViewLoaded && !self.view.window)
    {
        // If view already loaded but not displayed on screen at this time (not attached to any window) then unload it
        self.view = nil;
        
        // Then do here what you used to do in viewDidUnload

    }
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
    self.locationDataController = [[[BIGLocationDataController alloc]init] autorelease];
    
    //Disable the back button because we've already been granted an access token from Insatgram
    self.navigationItem.hidesBackButton = YES;

        
//    self.tabBarController.navigationItem.hidesBackButton = YES;
    self.tabBarController.delegate = self;
    
    //Set initial distance flag as true
    _traveledDistance = SEARCH_DIST;
    
    //Enable seeing the users current location.
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setDelegate:self];
    
    //Init CLLocationanager and set desired properties.
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 5;

    [_locationManager startUpdatingLocation];
    
    [self startTask];
}

- (void) viewWillAppear:(BOOL)animated {
    //Enable or re-enable user interaction
    self.view.userInteractionEnabled = YES;

    if(!self.nearbyLocationPoints) {
        _loadingMask = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];

        [self.view addSubview:_loadingMask];
        UILabel *loadingMaskLbl = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
        
        _loadingMask.backgroundColor = [UIColor blackColor];
        _loadingMask.alpha = 0.5;
        
        loadingMaskLbl.alpha = 1.0;
        loadingMaskLbl.text =@"loading";
        loadingMaskLbl.textColor = [UIColor whiteColor];
        loadingMaskLbl.backgroundColor = [UIColor blackColor];
        [loadingMaskLbl setCenter:self.loadingMask.center];
        loadingMaskLbl.textAlignment = NSTextAlignmentCenter;
        [_loadingMask addSubview:loadingMaskLbl];
        [loadingMaskLbl release];
    } else {
        NSLog(@"Returning 3D view");
        [UIView animateWithDuration:0.2
                         animations:^ {
                             CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
                             rotationAndPerspectiveTransform.m34 = 1.0 / -500;
                             rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
                             self.view.layer.transform = rotationAndPerspectiveTransform;
                         }
                         completion:^(BOOL finished) {
                             
                         }
         ];
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
    if ([[segue identifier] isEqualToString:@"displayImageCollection"])
    {
        self.imageCollectionViewController = (BIGImageViewController *)[segue destinationViewController];
        [self.imageCollectionViewController setDisplayLoadingMask:1];
        self.imageCollectionViewController.locationObj = _currentSelectedLocation;
    }
}
#pragma mark - mapkit delegate

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
    NSLog(@"mapViewDidFailLoadingMap %@", error);
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if(view.annotation != mapView.userLocation) {

        BIGLocation *tempLocation = (BIGLocation *)view.annotation;
        _currentSelectedLocation = tempLocation;
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"didDeselectAnnotationView");
}

// mapView:annotationView:calloutAccessoryControlTapped: is called when the user taps on left & right callout accessory UIControls.
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"calloutAccessoryControlTapped");
    self.view.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.2
                     animations:^ {
                         CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
                         rotationAndPerspectiveTransform.m34 = 1.0 / -500;
                         rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 45.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
                         self.view.layer.transform = rotationAndPerspectiveTransform;
                         [self performSegueWithIdentifier:@"displayImageCollection" sender:self];
                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    BIGCustomAnnotationView *annotationView;

    for (annotationView in views) {
        
        CGRect endFrame = annotationView.frame;
        
        annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y - 230.0, annotationView.frame.size.width, annotationView.frame.size.height);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.45];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [annotationView setFrame:endFrame];
        [UIView commitAnimations];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    BIGCustomAnnotationView *pinView = nil;

    if(annotation != mapView.userLocation)
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
//        pinView = (BIGCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        pinView = [[[BIGCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
//        UIButton *annotationBtn = [[[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f)] autorelease];
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    else {
        [mapView.userLocation setTitle:@"I am here"];
    }
    return pinView;
}

#pragma mark -MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{    
    MKCoordinateRegion rgn = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude), 100, 100);
    
    [self.mapView setRegion:rgn animated:NO];
}

#pragma mark -CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    //TODO Need indicator of GPS health
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
        BIGAppDelegate* appDelegate = (BIGAppDelegate*)[UIApplication sharedApplication].delegate;
 
        NSString *latString = [[[NSString alloc] initWithFormat:@"%g", manager.location.coordinate.latitude] autorelease];
        NSString *lonString = [[[NSString alloc] initWithFormat:@"%g", manager.location.coordinate.longitude] autorelease];
        NSString *searchDistance = [[[NSString alloc] initWithFormat:@"%d", SEARCH_DIST] autorelease];
        
        NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
        [params setObject:latString forKey:@"lat"];
        [params setObject:lonString forKey:@"lng"];
        [params setObject:searchDistance forKey:@"distance"]; //Instagram search distance in meters.
        
        if ([appDelegate.instagram isSessionValid]) {
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

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError %@", error);
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    NSLog(@"request did Load");
    
    //TODO this can be improved.
    //First I want to sort the list by distance from the user. So I need a single location, pause updating where the user is
    
    //Upon receiving the parsed request store locations in a data controller
    NSArray *list = [result objectForKey:@"data"];
    
    for (NSDictionary *data in list)
    {
        CLLocation *nearbyLocation = [[[CLLocation alloc] initWithLatitude:[[data objectForKey:@"latitude"] doubleValue] longitude:[[data objectForKey:@"longitude"] doubleValue]] autorelease];

        CGFloat distanceFromUser = [self.locationManager.location distanceFromLocation:nearbyLocation];

        //Add to the list of friends
        [self.locationDataController addLocationWithName:[data objectForKey:@"name"] latitude:[data objectForKey:@"latitude"] longitude:[data objectForKey:@"longitude"] identityNumber:[data objectForKey:@"id"] distanceFromUserInMeters:distanceFromUser];
    }
    
    //Prototyping*********************************************
    
    self.nearbyLocationPoints = [[[NSMutableArray alloc] initWithArray:[self.locationDataController locationList]] autorelease];
    
    self.mrloader = [[[BIGMapMediaReferenceloader alloc]initWithArray:self.nearbyLocationPoints] autorelease];
    [self.mrloader setDelegate:self];
    [self.mrloader startMediaReferenceRequest];
    
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

#pragma mark - BIGMapMediaReferenceLoaderDelegate
- (void)didCompleteBatchDownload:(BIGLocation *)newLocation {
    [self.mapView addAnnotation:newLocation];
    
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

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    NSArray *tabViewControllers = tabBarController.viewControllers;
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = viewController.view;
    if (fromView == toView)
        return NO;
    NSUInteger fromIndex = [tabViewControllers indexOfObject:tabBarController.selectedViewController];
    NSUInteger toIndex = [tabViewControllers indexOfObject:viewController];
    
    
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.3
                       options: toIndex > fromIndex ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                        if (finished) {
                            tabBarController.selectedIndex = toIndex;
                        }
                    }];
    return true;
}

@end
