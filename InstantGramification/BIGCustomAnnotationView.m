//
//  BIGCustomAnnotationView.m
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/21/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "BIGCustomAnnotationView.h"
#import <QuartzCore/QuartzCore.h>

@interface BIGCustomAnnotationView()
-(void)animateDrop;
@end

@implementation BIGCustomAnnotationView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.canShowCallout = YES;
        self.backgroundColor = [UIColor clearColor];
        // Position the frame so that the bottom of it touches the annotation position
        self.frame = CGRectMake(0, 0, 44.0, 44.0);
        
        self.location = (BIGLocation *)annotation;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f)];

    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor blueColor];
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%d", self.location.imageCollection.count];
    [self addSubview:label];
    
    [label release];
}

-(void)animateDrop {    
    CGPoint finalPos = self.center;
    CGPoint startPos = CGPointMake(self.center.x, self.center.y-480.0);
    self.layer.position = startPos;
    
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    theAnimation.fromValue=[NSValue valueWithCGPoint:startPos];
    theAnimation.toValue=[NSValue valueWithCGPoint:finalPos];
    theAnimation.removedOnCompletion = NO;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.delegate = self;
    theAnimation.beginTime = 5.0 * (self.center.x/320.0);
    theAnimation.duration = 1.0;
    [self.layer addAnimation:theAnimation forKey:@""];
}

-(void)dealloc {
    [_location release], _location = nil;
    
    [super dealloc];
}
@end
