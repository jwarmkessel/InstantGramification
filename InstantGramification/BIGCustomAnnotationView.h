//
//  BIGCustomAnnotationView.h
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/21/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "BIGLocation.h"

@interface BIGCustomAnnotationView : MKAnnotationView

@property (retain, nonatomic) BIGLocation *location;
@end
