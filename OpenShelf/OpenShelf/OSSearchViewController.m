//
//  OSSearchViewController.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/1/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSSearchViewController.h"
#import "OSMainNavigationController.h"
#import "OSItemTableViewCell.h"
#import "OSNetworking.h"
#import "NSObject+MappableObject.h"
#import "OSItem.h"
#import "OSItemDetailViewController.h"

@interface OSSearchViewController ()
@property (strong, nonatomic) NSMutableArray *data;
@property (nonatomic, strong) NSArray *tableItems;
@property (strong, nonatomic) NSArray *testImageURLs;
@end

@implementation OSSearchViewController
// static NSString *CellIdentifier = @"itemCell";
static NSString *CellIdentifier = @"OSItemTableViewCell";


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Search";
    self.navigationItem.titleView = self.searchBar;

    self.testImageURLs = @[@"http://www.golfersavenue.com/wp-content/uploads/2012/04/golf-club-auctions.jpg",
                           @"http://www.slingshotsports.com/14WakeParts_Tout.jpg",
                           @"http://amazingribs.com/bbq_equipment_reviews_ratings/sites/amazingribs.com/files/weber_jumbo_joe_portable_charcoal_grill_300pix.jpg",
                           @"http://img2-3.timeinc.net/toh/i/g/0107_toolkit/cordless-tool-kits-01.jpg"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self scrollViewDidScroll:nil];
}


#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OSItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell populateCellWithItem:[_data objectAtIndex:indexPath.row]];
    
    
    
    return cell;
}


-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
    [super scrollViewDidScroll:scrollView];
}

#pragma mark - UISearchDisplayDelegate methods
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [_data removeAllObjects];
    if (![searchText length] == 0) {
        [[OSNetworking sharedInstance]downloadItemsForSearchTerms:searchText
                                                          success:^(NSDictionary *dictionary, NSError *error){
                                                              //Adds multiple items for testing purposes, remove loop once backend is built
                                                              for (int i = 0; i < 20; i++) {
                                                                  OSItem *item = [OSItem createFromInfo:dictionary];
                                                                  item.imageUrls = self.testImageURLs;
                                                                  [self.data addObject:item];
                                                              }
                                                              
                                                              [self.tableView reloadData];
                                                              
                                                              //            if ([dictionary respondsToSelector:@selector(allKeys)]) {
                                                              //                for (id key in [dictionary allKeys]) {
                                                              //                    [self.data addObject: [dictionary valueForKey:key]];
                                                              //                    [self.tableView reloadData];
                                                              //                }
                                                              //            }
                                                              //            else{
                                                              //                for (id object in dictionary) {
                                                              //                    [self.data addObject:object];
                                                              //                    [self.tableView reloadData];
                                                              //
                                                              //                }
                                                              //            }
                                                              
                                                              
                                                          } failure:nil];
    }
    else{
        [self.tableView reloadData];
    }
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

#pragma mark - Segue Handlers

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString: @"toItemDetailController"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    OSItem *item = [_data objectAtIndex:indexPath.row];
        ((OSItemDetailViewController *)segue.destinationViewController).item = item;
    }
}

#pragma mark - Getters and Setters

- (NSMutableArray *)data {
    if (!_data) {
        _data = [[NSMutableArray alloc] init];
    }
    
    return _data;
}
@end
