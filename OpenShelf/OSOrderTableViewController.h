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

@interface OSOrderTableViewController : UITableViewController<OSComboBoxDelegate, OSLocationPickerDelegate>

@property (strong, nonatomic) OSItem *item;
@end
