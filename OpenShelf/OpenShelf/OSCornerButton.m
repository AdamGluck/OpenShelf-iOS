//
//  OSCornerButton.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/29/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSCornerButton.h"
@interface OSCornerButton()
@property (strong, nonatomic) UIColor *buttonColor;
@end
@implementation OSCornerButton

- (void)commonInit{
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithFrame:(CGRect)aRect{
    if ((self = [super initWithFrame:aRect])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder{
    if ((self = [super initWithCoder:coder])) {
        [self commonInit];
    }
    return self;
}


-(id)initWithFrame:(CGRect)aRect color:(UIColor *)color{
    if ((self = [self initWithFrame:aRect])) {
        [self commonInit];
        self.buttonColor = color;
    }
    return self;
}

-(void)setButtonColor:(UIColor *)buttonColor{
    _buttonColor = buttonColor;
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint   (ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));  // top left
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));  // top right
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));  // bottom right
    
    CGContextClosePath(ctx);
//    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
//    [self.buttonColor getRed:&red green:&green blue:&blue alpha:&alpha];
//    CGContextSetRGBFillColor(ctx, red, green, blue, alpha);
    CGContextSetFillColorWithColor(ctx, [self.buttonColor CGColor]);
    CGContextFillPath(ctx);
}


@end
