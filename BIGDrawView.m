//
//  BIGDrawView.m
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/21/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "BIGDrawView.h"

@implementation BIGDrawView
@synthesize drawBlock = _drawBlock;

- (void)dealloc
{
    [self.drawBlock release], self.drawBlock = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if(self.drawBlock)
        self.drawBlock(self,context);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
