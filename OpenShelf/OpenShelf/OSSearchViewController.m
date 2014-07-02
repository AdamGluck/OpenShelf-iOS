//
//  OSSearchViewController.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/1/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSSearchViewController.h"
#import "OSMainNavigationController.h"
#import "OSNetworking.h"

@interface OSSearchViewController ()
@property (strong, nonatomic) NSMutableArray *data;
@end

@implementation OSSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Search";
    self.view.backgroundColor = [UIColor redColor];
    self.searchDisplayController.searchBar.placeholder = @"Search here";
//    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;

}


#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.
    cell.textLabel.text = [NSString stringWithFormat:@"Row %ld: %@", (long)indexPath.row, [_data objectAtIndex:indexPath.row]];
    return cell;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return self.searchDisplayController.searchBar;
//    }
//    else return  nil;
//}


#pragma mark - UISearchDisplayDelegate methods

-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
}
-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{

}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [_data removeAllObjects];
    [[OSNetworking sharedInstance]downloadItemsForSearchTerms:searchString success:^(NSDictionary *dictionary, NSError *error) {
        for (id key in [dictionary allKeys]) {
            [self.data addObject: [dictionary valueForKey:key]];
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    } failure:nil];
    
    return NO;
}

#pragma mark - Getters and Setters

- (NSMutableArray *)data {
    if (!_data) {
        _data = [[NSMutableArray alloc] init];
    }
    
    return _data;
}
@end
