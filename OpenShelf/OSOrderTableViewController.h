//
//  OSTransactionTableViewController.h
//  OpenShelf
//
//  Created by Brian Strobach on 8/5/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSComboBoxView.h"
#import "OSItem.h"
#import "OSLocationPicker.h"
#import "OSPaymentMethodPicker.h"

@interface OSOrderTableViewController : UITableViewController<OSComboBoxDelegate, OSLocationPickerDelegate, OSPaymentMethodPickerDelegate>

@property (strong, nonatomic) OSItem *item;
@end
