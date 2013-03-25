//
//  BIGAppDelegate.m
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/13/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "BIGAppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>

#define APP_ID @"9ad8f1c815c449608c430b892dca3eb9"
#define GOOGLE_API_ACESS @"AIzaSyDCCbgIbdgtniEDORfBguz8t6qHl7pRJ9c"
#define TESTFLIGHT_TOKEN @"f15f4800-3595-4280-a98d-39bf3f89fae2"

@implementation BIGAppDelegate

- (void)dealloc
{
    [self.instagram release], self.instagram = nil;
    [_window release];
    [super dealloc];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self.instagram handleOpenURL:url];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.instagram handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TestFlight takeOff:TESTFLIGHT_TOKEN];
    self.instagram = [[Instagram alloc] initWithClientId:APP_ID
                                                delegate:nil];
    
    [GMSServices provideAPIKey:GOOGLE_API_ACESS];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    

    //iOS pauses core location when it enters the background.  

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
