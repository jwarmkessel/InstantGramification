//
//  BIGViewController.m
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/13/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "BIGViewController.h"
//#import "BIGMapViewController.h"
#import "BIGAppDelegate.h"
#import "BIGDrawView.h"
#import <QuartzCore/QuartzCore.h>

@interface BIGViewController ()
- (IBAction)handleInstagramConnect:(id)sender;
@end

@implementation BIGViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect rect = self.view.layer.frame;
    
    //Adding a radial gradient. Not sure how I like doing things this way.
    BIGDrawView* drawableView = [[[BIGDrawView alloc] initWithFrame:CGRectMake(0,0,320,50)] autorelease];
    drawableView.drawBlock = ^(UIView *view,CGContextRef context)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        //Gradient related variables
        CGGradientRef myGradient;
        CGColorSpaceRef myColorSpace;
        size_t locationCount = 2;
        CGFloat locationList[2] = { 0.0, 0.9 };
        CGFloat colorList[8] = {
            1.0, 1.0, 1.0, 1.0,  // Start color
            0.2, 0.32, 0.6, 1.0   // End color
            
        };
        
        myColorSpace = CGColorSpaceCreateDeviceRGB();
        myGradient = CGGradientCreateWithColorComponents(myColorSpace, colorList, locationList, locationCount);
    
        float startPoint = 0.0f;
        float endPoint = rect.size.width;
        
        CGPoint startRadius, endRadius;
        
        //Radia Gradient Rendering
        startRadius.x = rect.size.width/2;
        startRadius.y = rect.size.height/2;
        endRadius.x = rect.size.width/2;
        endRadius.y = rect.size.height/2;
        
        CGContextDrawRadialGradient(ctx, myGradient, startRadius, startPoint, endRadius, endPoint, 0);
        CGGradientRelease(myGradient);
        CGColorSpaceRelease(myColorSpace);


    };


    UILabel *appTitle = (UILabel *)[self.view viewWithTag:1];
    UIButton *button = (UIButton *)[self.view viewWithTag:2];
    self.view = drawableView;
    
    [self.view.layer setMasksToBounds:YES];
    [self.view.layer setCornerRadius:5.0f];
    [self.view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.view.layer setBorderWidth:1.5f];
    [self.view.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    [self.view.layer setShadowColor:[UIColor greenColor].CGColor];
    [self.view.layer setShadowOpacity:0.0];
    [self.view.layer setShadowRadius:3.0];
    
    [self.view addSubview:appTitle];
    [self.view addSubview:button];
    
    
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"View Controller did load");
    BIGAppDelegate* appDelegate = (BIGAppDelegate*)[UIApplication sharedApplication].delegate;
    
    // here i can set accessToken received on previous login
    appDelegate.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    appDelegate.instagram.sessionDelegate = self;
    
    if ([appDelegate.instagram isSessionValid]) {
        [self performSegueWithIdentifier:@"displayLocale" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
- (IBAction)handleInstagramConnect:(id)sender {
    BIGAppDelegate* appDelegate = (BIGAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.instagram authorize:[NSArray arrayWithObjects:@"comments", @"likes", nil]];
}

#pragma - IGSessionDelegate

-(void)igDidLogin {
    NSLog(@"Instagram did login");
    // here i can store accessToken
    BIGAppDelegate* appDelegate = (BIGAppDelegate*)[UIApplication sharedApplication].delegate;
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.instagram.accessToken forKey:@"accessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    [self performSegueWithIdentifier:@"displayLocale" sender:self];
}

-(void)igDidNotLogin:(BOOL)cancelled {
    NSLog(@"Instagram did not login");
    NSString* message = nil;
    if (cancelled) {
        message = @"Access cancelled!";
    } else {
        message = @"Access denied!";
    }
    UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil] autorelease];
    [alertView show];
}

-(void)igDidLogout {
    NSLog(@"Instagram did logout");
    // remove the accessToken
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"accessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)igSessionInvalidated {
    NSLog(@"Instagram session was invalidated");
}
@end
