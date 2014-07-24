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
#import "OSPackage.h"
#import "OSItemDetailViewController.h"

@interface OSSearchViewController ()
@property (nonatomic, strong) NSMutableArray *featuredInventoryList;
@property (strong, nonatomic) NSMutableArray *inventoryList;

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
    [self loadInventoryList];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    [self scrollViewDidScroll:nil];
}


#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    if (self.featuredInventoryList.count > 0) {
        return 2;
    }
    else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    if (self.featuredInventoryList.count > 0 && section == 1) {
        return [self.featuredInventoryList count];
    }
    else{
        return [self.inventoryList count];
    }
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OSItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (self.featuredInventoryList.count > 0 && indexPath.section == 1) {
        [cell populateCellWithItem:[self.featuredInventoryList objectAtIndex:indexPath.row]];
    }
    else{
        [cell populateCellWithItem:[self.inventoryList objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.featuredInventoryList.count > 0) {
        switch (section) {
            case 1:
                return @"Featured Items";
                break;
            case 2:
                return @"Other Cool Shit";
                break;
                
            default:
                return nil;
                break;
        }
    }
    return nil;
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
    [_inventoryList removeAllObjects];
    if (![searchText length] == 0) {
        [[OSNetworking sharedInstance]downloadItemsForSearchTerms:searchText
                                                          success:^(NSDictionary *dictionary, NSError *error){
                                                              //Adds multiple items for testing purposes, remove loop once backend is built
                                                              for (int i = 0; i < 20; i++) {
                                                                  OSItem *item = [OSItem createFromInfo:dictionary];
                                                                  item.imageUrls = self.testImageURLs;
                                                                  [self.inventoryList addObject:item];
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
        OSItem *item = [_inventoryList objectAtIndex:indexPath.row];
        ((OSItemDetailViewController *)segue.destinationViewController).item = item;
    }
}



-(void)loadInventoryList{
    [[OSNetworking sharedInstance]downloadInventoryListWithSuccessBlock:^(NSDictionary *dictionary, NSError *error) {
        NSMutableArray *items = [dictionary objectForKey:@"items"];
        for (NSDictionary *itemDictionary in items) {
            OSItem *item = [OSItem createFromInfo:itemDictionary];
            if (item.isFeatured) {
                [self.featuredInventoryList addObject:item];
            }
            else {
                [self.inventoryList addObject:item];
            }
        }
        NSMutableArray *packages = [dictionary objectForKey:@"packages"];
        for (NSDictionary *packageDictionary in packages) {
            OSPackage *package = [OSPackage createFromInfo:packageDictionary];
            if (package.isFeatured) {
                [self.featuredInventoryList addObject:package];
            }
            else {
                [self.inventoryList addObject:package];
            }
        }
        [self.tableView reloadData];
        
    } failureBlock:^{
        NSLog(@"Failed to download");
    }];
}

#pragma mark - Lazy Getters

- (NSMutableArray *)inventoryList {
    if (!_inventoryList) {
        _inventoryList = [[NSMutableArray alloc] init];
    }
    
    return _inventoryList;
}
- (NSMutableArray *)featuredInventoryList {
    if (!_featuredInventoryList) {
        _featuredInventoryList = [[NSMutableArray alloc] init];
    }
    
    return _featuredInventoryList;
}
@end
