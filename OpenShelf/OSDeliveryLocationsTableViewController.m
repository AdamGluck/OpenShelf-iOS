//
//  OSDeliveryLocationsController.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/30/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSDeliveryLocationsTableViewController.h"
#import "OSLocationPicker.h"
#import "OSNetworking.h"
#import "OSDeliveryLocation.h"
#import "OSLoginManager.h"

static NSString *kCellIdentifier = @"deliveryLocationTableviewCell";
@interface OSDeliveryLocationsTableViewController ()
@property (strong, nonatomic) NSMutableArray *locations;
@end

@implementation OSDeliveryLocationsTableViewController

- (void)commonInit{
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];
	self.navigationItem.rightBarButtonItem = addButton;
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
    
    [self downloadLocations];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Handling

-(void)addButtonPressed{
    OSLocationPicker *locPicker = [self.storyboard instantiateViewControllerWithIdentifier:@"locationPickerController"];
    locPicker.delegate = self;
    [self presentViewController:locPicker animated:YES completion:nil];
//    [self.navigationController pushViewController:locPicker animated:YES];
}

#pragma mark - Location Picker Delegate Methods

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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [OSLoginManager sharedInstance].user.deliveryLocations.count;
}

-(void)downloadLocations{
    //TODO: networking code for downloading locations and refreshing table
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    

    // Configure the cell...
    OSDeliveryLocation *location = [[OSLoginManager sharedInstance].user.deliveryLocations objectAtIndex:indexPath.row];
    cell.textLabel.text = location.title;
    cell.detailTextLabel.text = location.address.streetNumber;
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
