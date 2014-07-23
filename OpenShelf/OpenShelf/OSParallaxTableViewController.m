//
//  OSParallaxTableViewController.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/21/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSParallaxTableViewController.h"
#import "OSItemTableViewCell.h"

@implementation OSParallaxTableViewController

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
@end
