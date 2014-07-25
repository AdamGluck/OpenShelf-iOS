//
//  OSEmailFormField.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/24/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSEmailFormField.h"

@implementation OSEmailFormField
- (void)commonInit{
    
    self.textField.placeholder = @"EMAIL";
    [self setTextValidationBlock:^BOOL(BZGFormField *field, NSString *text) {
        if (text.length == 0 || [text isEqualToString:@""]) {
            field.alertView.title = @"Must fill in this field";
            return NO;
        }
        
        // from https://github.com/benmcredmond/DHValidation/blob/master/DHValidation.m
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailTest evaluateWithObject:text]) {
            field.alertView.title = @"Invalid email address";
            return NO;
        } else {
            return YES;
        }
    }];
    
    //Add online validation
    [self setAsyncTextValidationBlock:^BOOL(BZGFormField *field, NSString *text) {
        NSError *error;
        NSString *str = [NSString stringWithFormat:@"https://api.mailgun.net/v2/address/validate?address=%@&api_key=%@", [text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"pubkey-5ogiflzbnjrljiky49qxsiozqef5jxp7"];
        NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
        
        if (!responseData) {
            field.alertView.title = @"Cannot validate";
            return NO;
        }
        
        id json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        if (!json || error) {
            field.alertView.title = @"Cannot validate";
            return NO;
        }
        
        BOOL isValid = [json[@"is_valid"] boolValue];
        if (!isValid) {
            field.alertView.title = @"Invalid email address (online)";
        }
        
        return isValid;
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
