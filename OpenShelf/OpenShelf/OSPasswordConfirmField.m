//
//  OSPasswordConfirmField.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/24/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSPasswordConfirmField.h"

@implementation OSPasswordConfirmField

- (void)commonInit{
    self.textField.placeholder = @"CONFIRM PASSWORD";
    self.textField.secureTextEntry = YES;
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

-(void)setPasswordField:(OSPasswordField *)passwordField{
//    self.passwordField = passwordField;
//    __unsafe_unretained typeof(self) weakSelf = self;
    [self setTextValidationBlock:^BOOL(BZGFormField *field, NSString *text) {
        if (text.length == 0 || [text isEqualToString:@""]) {
            field.alertView.title = @"Must fill in this field";
            return NO;
        }
        else if (![text isEqualToString:passwordField.textField.text]) {
            field.alertView.title = @"Password confirmion doesn't match password";
            return NO;
        } else {
            return YES;
        }
    }];
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
