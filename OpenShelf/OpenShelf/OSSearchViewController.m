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
@property (strong, nonatomic) NSMutableArray *sectionedInventoryList;
@property (nonatomic, strong) NSMutableArray *featuredInventoryList;
@property (strong, nonatomic) NSMutableArray *nonFeaturedInventoryList;
@end

@implementation OSSearchViewController
// static NSString *CellIdentifier = @"itemCell";
static NSString *CellIdentifier = @"OSItemTableViewCell";


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Search";
    self.navigationItem.titleView = self.searchBar;
    [self loadInventoryList];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    [self scrollViewDidScroll:nil];
}


#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
//    if (self.featuredInventoryList.count > 0) {
//        return 2;
//    }
//    else{
//        return 1;
//    }
    return [self.sectionedInventoryList count];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
//    if (self.featuredInventoryList.count > 0 && section == 0) {
//        return [self.featuredInventoryList count];
//    }
//    else{
//        return [self.nonFeaturedInventoryList count];
//    }
    
    return [[self.sectionedInventoryList objectAtIndex:section] count];
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OSItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell populateCellWithItem:[self getItemForIndexPath:indexPath]];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.sectionedInventoryList.count > 0) {
        switch (section) {
            case 0:
                return @"Featured Items";
                break;
            case 1:
                return @"Other Cool Shit";
                break;
                
            default:
                return nil;
                break;
        }
    }
    else return @"Search Results";
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSNumber *height;
    if (!height) {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        height = @(cell.bounds.size.height);
    }
    return [height floatValue];
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
    [_nonFeaturedInventoryList removeAllObjects];
    if (![searchText length] == 0) {
        [[OSNetworking sharedInstance]downloadItemsForSearchTerms:searchText
                                                          success:^(NSDictionary *dictionary, NSError *error){
                                                              //Adds multiple items for testing purposes, remove loop once backend is built
                                                              for (int i = 0; i < 20; i++) {
                                                                  OSItem *item = [OSItem createFromInfo:dictionary];
                                                                  [self.nonFeaturedInventoryList addObject:item];
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
        OSItem *item = [self getItemForIndexPath:indexPath];
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
                [self.nonFeaturedInventoryList addObject:item];
            }
        }
        NSMutableArray *packages = [dictionary objectForKey:@"packages"];
        for (NSDictionary *packageDictionary in packages) {
            OSPackage *package = [OSPackage createFromInfo:packageDictionary];
            if (package.isFeatured) {
                [self.featuredInventoryList addObject:package];
            }
            else {
                [self.nonFeaturedInventoryList addObject:package];
            }
        }
        [self resetSectionedInventoryList];
        [self.tableView reloadData];
        
    } failureBlock:^{
        NSLog(@"Failed to download");
    }];
}

-(void)resetSectionedInventoryList{
    if (!self.sectionedInventoryList) {
        self.sectionedInventoryList = [[NSMutableArray alloc]init];
    }
    [self.sectionedInventoryList removeAllObjects];
    [self.sectionedInventoryList addObject:self.featuredInventoryList];
    [self.sectionedInventoryList addObject:self.nonFeaturedInventoryList];
    
}

-(OSItem *)getItemForIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *sectionItems = [self.sectionedInventoryList objectAtIndex:indexPath.section];
    return [sectionItems objectAtIndex:indexPath.row];
}

#pragma mark - Lazy Getters

- (NSMutableArray *)nonFeaturedInventoryList {
    if (!_nonFeaturedInventoryList) {
        _nonFeaturedInventoryList = [[NSMutableArray alloc] init];
    }
    
    return _nonFeaturedInventoryList;
}
- (NSMutableArray *)featuredInventoryList {
    if (!_featuredInventoryList) {
        _featuredInventoryList = [[NSMutableArray alloc] init];
    }
    
    return _featuredInventoryList;
}
@end
