//
//  OSPasswordField.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/24/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSPasswordField.h"

@implementation OSPasswordField


- (void)commonInit{
    self.textField.placeholder = @"Password";
    self.textField.secureTextEntry = YES;
    [self setTextValidationBlock:^BOOL(BZGFormField *field, NSString *text) {
        if (text.length == 0 || [text isEqualToString:@""]) {
            field.alertView.title = @"Must fill in this field";
            return NO;
        }
        else if (text.length < 8) {
            field.alertView.title = @"Password is too short";
            return NO;
        } else {
            return YES;
        }
    }];
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
