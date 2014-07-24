//
//  OSPasswordConfirmField.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/24/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSFormField.h"
#import "OSPasswordField.h"

@interface OSPasswordConfirmField : OSFormField
@property (weak, nonatomic) OSPasswordField *passwordField;
@end
