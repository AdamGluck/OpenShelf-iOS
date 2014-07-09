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
    self.testImageURLs = @[@"http://www.golfersavenue.com/wp-content/uploads/2012/04/golf-club-auctions.jpg",
                           @"http://www.slingshotsports.com/14WakeParts_Tout.jpg",
                           @"http://amazingribs.com/bbq_equipment_reviews_ratings/sites/amazingribs.com/files/weber_jumbo_joe_portable_charcoal_grill_300pix.jpg",
                           @"http://img2-3.timeinc.net/toh/i/g/0107_toolkit/cordless-tool-kits-01.jpg"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self scrollViewDidScroll:nil];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OSItemDetailViewController *vc = [[OSItemDetailViewController alloc]initWithItem:self.data[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
    

}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    OSItemTableViewCell *itemCell = (OSItemTableViewCell *) cell;
    
    // Frame
    CGFloat cellY = itemCell.frame.origin.y;
    CGFloat delta = cellY - tableView.contentOffset.y;
    
    // Get natural
    CGFloat threshold = 200.0f;
    CGFloat percent = delta / tableView.bounds.size.height;
    CGFloat deltaParallax = percent * threshold;
    
    itemCell.itemImageView.frame = CGRectMake(0, -delta  + deltaParallax , tableView.bounds.size.width, tableView.bounds.size.height);
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
    for (OSItemTableViewCell *cell in [self.tableView visibleCells])
    {
        
        // Frame
        CGFloat cellY = cell.frame.origin.y;
        CGFloat delta = cellY - self.tableView.contentOffset.y;
        
        // Get natural
        CGFloat threshold = 200.0f;
        CGFloat percent = delta/ self.tableView.bounds.size.height;
        CGFloat deltaParallax = percent * threshold;
        
        
        cell.itemImageView.frame = CGRectMake(0, -delta + deltaParallax , self.tableView.bounds.size.width, self.tableView.bounds.size.height);
    }
}
//-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if (decelerate)
//    {
//        [self scrollToNearestRow];
//    }
//}
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [self scrollToNearestRow];
//}
//-(void) scrollToNearestRow
//{
//    CGPoint point = self.tableView.contentOffset;
//
//    // Cell
//    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
//    OSItemTableViewCell *cell = (OSItemTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//
//    CGFloat delta = (cell.frame.origin.y + cell.frame.size.height) - point.y;
//    CGFloat percent = delta / (float)cell.frame.size.height;
//
//    if (percent > 0.5)
//    {
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }
//    else
//    {
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }
//
//}



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

#pragma mark - Getters and Setters

- (NSMutableArray *)data {
    if (!_data) {
        _data = [[NSMutableArray alloc] init];
    }
    
    return _data;
}
@end
