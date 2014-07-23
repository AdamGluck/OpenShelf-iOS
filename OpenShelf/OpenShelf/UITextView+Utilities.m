//
//  UITextView+Utilities.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/22/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "UITextView+Utilities.h"

@implementation UITextView (Utilities)
-(void)resizeContentViewAfterSettingText:(NSString *)text{
    [self setScrollEnabled:YES];
    [self setText:text];
    [self sizeToFit];
    [self setScrollEnabled:NO];
}
@end
