//
//  UIImage+Utilities.m
//  OpenShelf
//
//  Created by Brian Strobach on 8/5/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "UIImage+Utilities.h"

@implementation UIImage (Utilities)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
