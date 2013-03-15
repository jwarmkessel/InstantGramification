//
//  BIGViewController.h
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/13/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BIGMapViewController;

@interface BIGViewController : UIViewController <IGSessionDelegate>
- (IBAction)handleInstagramConnect:(id)sender;

@property(retain, nonatomic) BIGMapViewController *mapViewController;

@end
