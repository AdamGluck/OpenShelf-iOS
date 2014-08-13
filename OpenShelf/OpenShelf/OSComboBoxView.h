//
//  OSComboBoxView.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/30/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OSComboBoxView;



@protocol OSComboBoxDelegate <NSObject>

// Selection contains the user selected option or nil if nothing was selected
- (void)comboBox:(OSComboBoxView *)view didFinishWithSelection:(id)selection;

@optional

// You can use this to disable scrolling on a tableView
- (void)comboBoxWillBecomeActive:(OSComboBoxView *)view;

- (void)comboBoxDidResizeFrame:(OSComboBoxView *)view;
@end



@interface OSComboBoxView : UIView

@property (nonatomic) NSString *title;
@property (nonatomic, weak) id<OSComboBoxDelegate> delegate;
@property (nonatomic) id selection;

//If used with a tableview
@property (strong, nonatomic) NSIndexPath *indexPath;

- (void)setSelectionOptions:(NSArray *)selectionOptions withTitles:(NSArray *)selectionOptionTitles;

@end
