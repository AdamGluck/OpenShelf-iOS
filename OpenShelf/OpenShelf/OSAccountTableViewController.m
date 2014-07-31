//
//  OSAccountViewController.m
//
//  Created by Brian Strobach on 7/1/14
//  Copyright (c) 2014 Open Shelf. All rights reserved.
//

#import "OSAccountTableViewController.h"
#import "OSMainNavigationController.h"
#import "OSLoginManager.h"
@interface OSAccountTableViewController ()
@property (strong ,nonatomic) NSArray *rowTitles;
@property (strong, nonatomic) NSArray *segueNames;
@end

@implementation OSAccountTableViewController
static NSString *CellIdentifier = @"OSAccountTableViewCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"MY ACCOUNT";
    self.rowTitles = @[@"Account Info",@"Payment Methods",@"Delivery Locations"];
    self.segueNames = @[@"toAccountInfoController",@"toPaymentMethodsController",@"toDeliveryLocationsController"];
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
    return self.rowTitles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
 
 // Configure the cell...
     cell.textLabel.text = [self.rowTitles objectAtIndex:indexPath.row];
 
 return cell;
 }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:[self.segueNames objectAtIndex:indexPath.row] sender:nil];
}
 

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
//    /* Create custom view to display section header... */
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
//    [label setFont:[UIFont boldSystemFontOfSize:12]];
//    [label setText:[OSLoginManager sharedInstance].user.email];
//    [view addSubview:label];
//    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
//    return view;
//}



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


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 
     
 }

- (IBAction)logoutButtonPressed:(id)sender {
    [[OSLoginManager sharedInstance]logout];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoggedOutNotification object:self];
}


@end
