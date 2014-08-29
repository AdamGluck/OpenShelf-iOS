//
//  OSPaymentMethodTableViewController.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/30/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSPaymentMethodTableViewController.h"
#import "CardIO.h"
#import "OSLoginManager.h"
#import "OSUser.h"
#import "OSCreditCard.h"
#import "STPView.h"
#import "PKTextField.h"
static NSString *kCellIdentifier = @"paymentMethodTableviewCell";
@interface OSPaymentMethodTableViewController ()
@property (strong, nonatomic) OSUser *user;

@end

@implementation OSPaymentMethodTableViewController

- (void)commonInit{
    self.user = [OSLoginManager sharedInstance].user;
}

- (id)initWithCoder:(NSCoder*)coder{
    if ((self = [super initWithCoder:coder])) {
        [self commonInit];
    }
    return self;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
            [self commonInit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.user.stripeCardArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    OSCreditCard *card = [self.user.stripeCardArray objectAtIndex:indexPath.row];
    
    UIImage *cardImage = [UIImage imageNamed:[card.brand lowercaseString]];
//    STPView *cardView = [[STPView alloc] initWithFrame:cell.frame];
//    [cardView.paymentView.cardNumberField setText:card.last4];
//    cardView.isUserInteractionEnabled = NO;
    
//    [cell addSubview:cardView];
//
//    switch (cardType) {
//        case PKCardTypeAmex:
//            cardTypeName = @"amex";
//            break;
//        case PKCardTypeDinersClub:
//            cardTypeName = @"diners";
//            break;
//        case PKCardTypeDiscover:
//            cardTypeName = @"discover";
//            break;
//        case PKCardTypeJCB:
//            cardTypeName = @"jcb";
//            break;
//        case PKCardTypeMasterCard:
//            cardTypeName = @"mastercard";
//            break;
//        case PKCardTypeVisa:
//            cardTypeName = @"visa";
//            break;
//        default:
//            break;
//    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ ending in %@", card.brand, card.last4];
    cell.imageView.image = cardImage;
//    [cell addSubview:cardImage];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
