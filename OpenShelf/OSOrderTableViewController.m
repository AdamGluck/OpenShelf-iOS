//
//  OSTransactionTableViewController.m
//  OpenShelf
//
//  Created by Brian Strobach on 8/5/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSOrderTableViewController.h"
#import "OSLoginManager.h"
#import "OSDeliveryLocation.h"
#import "OSCreditCard.h"
#import "OSOrder.h"
#import "OSNetworking.h"
#import "OSPaymentMethodPicker.h"
static NSString *CellIdentifier = @"transactionTableViewCell";
static CGFloat headerHeight = 50;
@interface OSOrderTableViewController ()
@property (strong, nonatomic) NSIndexPath *selectedRowIndex;
@property (nonatomic) CGFloat selectedRowHeight;
@property (strong, nonatomic) UIButton *placeOrderButton;
@property (strong, nonatomic) OSOrder *order;
@property (strong, nonatomic) OSAddress *deliveryAddress;
@property (strong, nonatomic) OSUser *user;
@property (strong, nonatomic) OSComboBoxView *deliveryLocationComboBox;
@property (strong, nonatomic) OSComboBoxView *paymentMethodComboBox;
@end

@implementation OSOrderTableViewController

- (void)commonInit{
    self.user = [OSLoginManager sharedInstance].user;
}

-(id)initWithStyle:(UITableViewStyle)style{
    if ((self = [super initWithStyle:style])) {
        [self commonInit];
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.order.isPackage = ([self.item.class isEqual:OSItem.class]) ? [NSNumber numberWithBool:FALSE] : [NSNumber numberWithBool:TRUE];
    self.order.objectId = self.item.id;
    self.order.userId = self.user.id;
    
    self.placeOrderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.placeOrderButton.frame = CGRectMake(0, 0, self.view.frame.size.width, UNIVERSAL_BUTTON_HEIGHT);
    [self.placeOrderButton setTitle:@"PLACE ORDER" forState:UIControlStateNormal];
    self.placeOrderButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [self.placeOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.placeOrderButton setBackgroundColor:[OSTheme primaryColor2]];
    [self.placeOrderButton addTarget:self action:@selector(placeOrder) forControlEvents:UIControlEventTouchUpInside];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.section == tableView.numberOfSections - 1) {
        [cell addSubview:self.placeOrderButton];
        [cell sizeToFit];
        return cell;
    }
    // Configure the cell...
    OSComboBoxView *comboBox = [[OSComboBoxView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
    comboBox.delegate = self;
    comboBox.indexPath = indexPath;
    NSMutableArray *options = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    OSUser *user = [OSLoginManager sharedInstance].user;
    switch (indexPath.section) {
        case 0:
            comboBox.title = @"Select a delivery location";
            options = user.deliveryLocations;
            for (OSDeliveryLocation *location in options) {
                [titles addObject:[NSString stringWithFormat:@"%@ - %@",location.title, location.address.streetNumber]];
            }
            self.deliveryLocationComboBox = comboBox;
            break;
        case 1:
            comboBox.title = @"Select a payment method";
            options = user.stripeCardArray;
            for (OSCreditCard *card in options) {
                [titles addObject:[NSString stringWithFormat:@"%@ ending in %@", card.brand, card.last4]];
            }
            self.paymentMethodComboBox = comboBox;
            break;
            
        default:
            break;
    }
    [comboBox setSelectionOptions:options withTitles:titles];
    [cell.contentView addSubview:comboBox];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, headerHeight)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, tableView.frame.size.width, headerHeight)];
    [label setFont:[UIFont systemFontOfSize:20]];
    label.center = CGPointMake(label.center.x, view.center.y);
    NSString *title;
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    addButton.center = CGPointMake(CGRectGetMaxX(view.frame) - addButton.frame.size.width, view.center.y);
    switch (section) {
        case 0:
            title = @"DELIVERY LOCATION";
            [addButton addTarget:self action:@selector(launchLocationPicker) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 1:
            title = @"PAYMENT METHOD";
            [addButton addTarget:self action:@selector(launchPaymentMethodPicker) forControlEvents:UIControlEventTouchUpInside];
            break;
            
        default:
            //No header for place order button row
            return nil;
            break;
    }
    
    [label setText:title];
    [view addSubview:label];
    

    [view addSubview:addButton];
//    [view setBackgroundColor:tableView.backgroundColor];
    return view;

    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return headerHeight;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([indexPath isEqual: self.selectedRowIndex]) {
        return self.selectedRowHeight;
    }
    else if(indexPath.section == self.tableView.numberOfSections - 1){
        return UNIVERSAL_BUTTON_HEIGHT;
    }
    else{
        return tableView.rowHeight;
    }
}
#pragma mark - Drop Down Selector Delegate

- (void)comboBoxWillBecomeActive:(OSComboBoxView *)comboBox  {
    self.tableView.scrollEnabled = NO;
     NSLog(@"WILL BECOME ACTIVE HEIGHT%@", NSStringFromCGSize(comboBox.frame.size));

}

- (void)comboBox:(OSComboBoxView *)comboBox didFinishWithSelection:(id)selection {
         NSLog(@"DID FINISH WITH SELECTION HEIGHT%@", NSStringFromCGSize(comboBox.frame.size));
    self.tableView.scrollEnabled = YES;

}


-(void)comboBoxDidResizeFrame:(OSComboBoxView *)comboBox{
    NSLog(@"DID RESIZE FRAME HEIGHT%@", NSStringFromCGSize(comboBox.frame.size));
    self.selectedRowIndex = comboBox.indexPath;
    self.selectedRowHeight = comboBox.frame.size.height;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];

}

#pragma Button Handlers

-(void)launchLocationPicker{
    OSLocationPicker *locPicker = [self.storyboard instantiateViewControllerWithIdentifier:@"locationPickerController"];
    locPicker.delegate = self;
    [self presentViewController:locPicker animated:YES completion:nil];
}

-(void)launchPaymentMethodPicker{
    OSPaymentMethodPicker *paymentPicker = [[OSPaymentMethodPicker alloc]init];
    paymentPicker.delegate = self;
    [self.navigationController pushViewController:paymentPicker animated:YES];
}

-(void)placeOrder{
    self.order.addressId = ((OSAddress *)self.deliveryLocationComboBox.selection).id;
    self.order.cardId = ((OSCreditCard *)self.paymentMethodComboBox.selection).id;
    //TODO: record selected payment method to order
    
    if (self.order.isValid) {
        [OSProgressHUD showGlobalProgressHUDWithTitle:@"Placing Order"];
        [[OSNetworking sharedInstance] placeOrder:self.order success:^(NSDictionary *dictionary) {
             NSLog(@"ORDER PLACEMENT SUCCESS");
            [OSProgressHUD dismissGlobalHUD];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Thanks"
                                                         message:@"Your order has been placed."
                                                        delegate:nil
                                               cancelButtonTitle:@"Awesome!"
                                               otherButtonTitles:nil];
            [av show];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error){
             NSLog(@"FAILED TO PLACE ORDER");
            [OSProgressHUD dismissGlobalHUD];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                         message:[NSString stringWithFormat:@"There was an issue with your order. Error: %@", error.localizedDescription]
                                                        delegate:nil
                                               cancelButtonTitle:@"Dang!"
                                               otherButtonTitles:nil];
            [av show];
        }];
    }

}

#pragma Location Picker delegate methods

-(void)userDidSaveAddress:(OSAddress *)address{
    OSDeliveryLocation *location = [[OSDeliveryLocation alloc]initWithAddress:address userID: [OSLoginManager sharedInstance].user.id title:@"TESTTITLE"];
    [[OSNetworking sharedInstance] addAddressToDatabase:location success:^(NSDictionary *dictionary) {
        [[OSLoginManager sharedInstance] refreshUserInfoWithSuccess:^(void) {
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"Failed to reload user data");
        }];
        NSLog(@"Successfully Save Address to DB");
    } failure:^(NSError *error){
        NSLog(@"Failed to save address to DB");
    }];

}


-(void)userDidSavePaymentMethod{
    [self refreshUserInfo];
}

-(void)refreshUserInfo{
    [[OSLoginManager sharedInstance]refreshUserInfoWithSuccess:^(void) {
        [self.tableView reloadData];
    } failure:^(NSError *error) {
         NSLog(@"Failed to reload user data.");
    }];
}

#pragma lazy getters

-(OSOrder *)order{
    if (!_order) {
        _order = [[OSOrder alloc]init];
    }
    return _order;
}

-(OSUser *)user {
    if(!_user){
        _user = [OSLoginManager sharedInstance].user;
    }
    return _user;
}
    





@end
