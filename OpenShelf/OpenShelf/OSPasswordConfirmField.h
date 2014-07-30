//
//  OSPasswordConfirmField.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/24/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "BZGFormField.h"
#import "OSPasswordField.h"

@interface OSPasswordConfirmField : BZGFormField
//@property (weak, nonatomic) OSPasswordField *passwordField;

-(void)setPasswordField:(OSPasswordField *)passwordField;

@end
