//
//  UIView+Utilities.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/22/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "UIView+Utilities.h"

@implementation UIView (Utilities)



-(void)resizeToFitSubviews
{
    float w = 0;
    float h = 0;
    
    for (UIView *v in [self subviews]) {
        float fw = v.frame.origin.x + v.frame.size.width;
        float fh = v.frame.origin.y + v.frame.size.height;
        w = MAX(fw, w);
        h = MAX(fh, h);
    }
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, w, h)];
}

-(void)resizeHeightToFitSubviewsHeight
{
    float h = 0;    
    for (UIView *v in [self subviews]) {
        float fh = v.frame.origin.y + v.frame.size.height;
        h = MAX(fh, h);
    }
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, h)];
}

-(void)addMultipleSubviews:(NSArray *)views{
    for (UIView *view in views) {
        [self addSubview:view];
    }
}
@end
