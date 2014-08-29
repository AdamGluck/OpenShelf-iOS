//
//  OSPaymentMethodPicker.h
//  OpenShelf
//
//  Created by Brian Strobach on 8/13/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPView.h"

@protocol OSPaymentMethodPickerDelegate <NSObject>

@required
- (void) userDidSavePaymentMethod;
@end
@interface OSPaymentMethodPicker : UIViewController<STPViewDelegate>


@property (strong, nonatomic) STPView *stripeView;
@property (strong, nonatomic) UIBarButtonItem *saveButton;

@property (nonatomic, assign) id<OSPaymentMethodPickerDelegate> delegate;


@end
