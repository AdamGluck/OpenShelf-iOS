//
//  OSSearchViewController.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/1/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSSearchViewController.h"
#import "OSMainNavigationController.h"
#import "OSItemCell.h"
#import "OSNetworking.h"
#import "NSObject+MappableObject.h"
#import "OSItem.h"

@interface OSSearchViewController ()
@property (strong, nonatomic) NSMutableArray *data;
@end

@implementation OSSearchViewController
 static NSString *CellIdentifier = @"itemCell";
- (void)viewDidLoad
{
    [super viewDidLoad];
    OSItem *testItem = [[OSItem alloc]init];
    testItem.title = @"testingNewTitle";
    [_data addObject:testItem];
	self.title = @"Search";
    self.view.backgroundColor = [UIColor redColor];
    self.searchDisplayController.searchBar.placeholder = @"Search here";
//    [self.tableView registerClass:[OSItemCell class] forCellReuseIdentifier:CellIdentifier];
//    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;

}


#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
//    return [_data count];
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    OSItemCell *cell = (OSItemCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    cell.itemTitleLabel.text = @"TEST";

    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    OSItemDetailViewController *vc = [[OSItemDetailViewController alloc]initWithItem:
}



#pragma mark - UISearchDisplayDelegate methods

-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
}
-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{

}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
//    if (![searchString length] == 0) {
//        [_data removeAllObjects];
//        [[OSNetworking sharedInstance]downloadItemsForSearchTerms:searchString success:^(NSDictionary *dictionary, NSError *error) {
//            [self.data addObject:dictionary];
//            [self.tableView reloadData];
        
            
            
//            if ([dictionary respondsToSelector:@selector(allKeys)]) {
//                for (id key in [dictionary allKeys]) {
//                    [self.data addObject: [dictionary valueForKey:key]];
//                    [self.searchDisplayController.searchResultsTableView reloadData];
//                }
//            }
//            else{
//                for (id object in dictionary) {
//                    [self.data addObject:object];
//                    [self.searchDisplayController.searchResultsTableView reloadData];
//
//                }
//            }
//            
//          
//        } failure:nil];
//    }
    
    
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