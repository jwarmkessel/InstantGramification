//
//  BIGGoogleMapsViewController.m
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/25/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "BIGGoogleMapsViewController.h"

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

    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.35
                                                            longitude:-122.0
                                                                 zoom:6
                                                                bearing:30 viewingAngle:45.0];
    
    
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    //mapView_.myLocationEnabled = YES;
    mapView_.settings.tiltGestures = YES;

    
/*
 scrollGestures — controls whether scroll gestures are enabled or disabled. If enabled, users may swipe to pan the camera.
 zoomGestures — controls whether zoom gestures are enabled or disabled. If enabled, users may double tap, two-finger tap, or pinch to zoom the camera. Note that double tapping may pan the camera to the specified point.
 tiltGestures — controls whether tilt gestures are enabled or disabled. If enabled, users may use a two-finger vertical down or up swipe to tilt the camera.
 rotateGestures — controls whether rotate gestures are enabled or disabled. If enabled, users may use a two-finger rotate gesture to rotate the camera.

*/
    mapView_.delegate = self;
    self.view = mapView_;
    
    self.tabBarController.delegate = self;
    
    GMSMarkerOptions *optionMarks = [[[GMSMarkerOptions alloc] init] autorelease];
    optionMarks.position = CLLocationCoordinate2DMake(-33.85, 151.20);
    optionMarks.title = @"Justin Warmkessel";
    optionMarks.snippet = @"this is your location";
    [mapView_ addMarkerWithOptions:optionMarks];
    
    mapView_.myLocationEnabled = YES;
}

- (void)viewDidLoad
{
    self.navigationItem.hidesBackButton = YES;
    self.tabBarController.navigationItem.hidesBackButton = YES;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSLog(@"Did switch maps");
    
    [UIView animateWithDuration:0.2
                     animations:^ {
                         CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
                         rotationAndPerspectiveTransform.m34 = 1.0 / -500;
                         rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -45.0 *M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
                         self.view.layer.transform = rotationAndPerspectiveTransform;
                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];
}

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
