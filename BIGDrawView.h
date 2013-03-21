//
//  BIGDrawView.h
//  InstantGramification
//
//  Created by Justin Warmkessel on 3/21/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DrawView_DrawBlock)(UIView* v,CGContextRef context);

@interface BIGDrawView : UIView

@property (nonatomic,copy) DrawView_DrawBlock drawBlock;

@end
