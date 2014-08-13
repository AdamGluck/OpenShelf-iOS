//
//  OSComboBoxView.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/30/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSComboBoxView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Utilities.h"
#define kOptionHeight 20
#define kOptionSpacing 1
#define kAnimationDuration 0.2

@implementation OSComboBoxView {
    CGRect mBaseFrame;
    
    // Configuration
    NSArray *mSelectionOptions, *mSelectionTitles;

    // Subviews
    UILabel *mTitleLabel;
    UIImage *mBgImage;
    NSMutableArray *mSelectionCells;
    
    // Control state
    BOOL mControlIsActive;
    NSInteger mSelectionIndex;
    NSInteger mPreviousSelectionIndex;
}


#pragma mark - Object Life Cycle
- (void)commonInit{
    
    // Title
    mTitleLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 5, 0)];
    mTitleLabel.textAlignment = NSTextAlignmentCenter;
    mTitleLabel.textColor = [UIColor blackColor];
    mTitleLabel.backgroundColor = [UIColor whiteColor];
    mTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:mTitleLabel];
}

- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        mBaseFrame = frame;
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



#pragma mark - Accessors

- (void)setTitle:(NSString *)title {
    _title = title;
    mTitleLabel.text = title;
}


#pragma mark - Configuration

- (void)setSelectionOptions:(NSArray *)selectionOptions withTitles:(NSArray *)selectionOptionTitles {
    if ([selectionOptions count] != [selectionOptionTitles count]) {
        [NSException raise:NSInternalInconsistencyException format:@"selectionOptions and selectionOptionTitles must contain the same number of objects"];
    }
    mSelectionOptions = selectionOptions;
    mSelectionTitles = selectionOptionTitles;
    mSelectionCells = nil;
}


#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] != 1)
        return;
    
    UITouch *touch = [touches anyObject];
    if (CGRectContainsPoint(self.bounds, [touch locationInView:self])) {
        [self activateControl];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] != 1)
        return;
    
    UITouch *touch = [touches anyObject];
    
    // Calculate the selection index
    CGPoint location = [touch locationInView:self];
    if ((CGRectContainsPoint(self.bounds, location)) && (location.y > mBaseFrame.size.height)) {
        mSelectionIndex = (location.y - mBaseFrame.size.height - kOptionSpacing) / (kOptionHeight + kOptionSpacing);
    } else {
        mSelectionIndex = NSNotFound;
    }
    
    if (mSelectionIndex == mPreviousSelectionIndex) 
        return;
    
    // Selection animation
    if (mSelectionIndex != NSNotFound) {
        UIView *cell = [mSelectionCells objectAtIndex:mSelectionIndex];
        [UIView animateWithDuration:kAnimationDuration animations:^{
            cell.frame = CGRectInset(cell.frame, -6, 0);
        }];
    }
    if (mPreviousSelectionIndex != NSNotFound) {
        UIView *cell = [mSelectionCells objectAtIndex:mPreviousSelectionIndex];
        [UIView animateWithDuration:kAnimationDuration animations:^{
            cell.frame = CGRectInset(cell.frame, 6, 0);
        }];
    }
    mPreviousSelectionIndex = mSelectionIndex;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (mControlIsActive) {
        [self inactivateControl];
        id selection = nil;
        if (mSelectionIndex < [mSelectionOptions count]) {
            selection = [mSelectionOptions objectAtIndex:mSelectionIndex];
            [self.delegate comboBox:self didFinishWithSelection:selection];
            [self setSelection:selection];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (mControlIsActive) {
        [self inactivateControl];
    }
}

#pragma mark - View Transformation

- (CATransform3D)contractedTransorm {
    CATransform3D t = CATransform3DIdentity;
    t = CATransform3DRotate(t, M_PI / 2, 1, 0, 0);
    t.m34 = -1.0/50;
    return t;
}

#pragma mark - Control Activation / Deactivation

- (void)activateControl {
    mControlIsActive = YES;
    
    mSelectionIndex = NSNotFound;
    mPreviousSelectionIndex = NSNotFound;
    
    if ([self.delegate respondsToSelector:@selector(comboBoxWillBecomeActive:)]) {
        [self.delegate comboBoxWillBecomeActive:self];
    }
    
    // Prepare the selection cells
    if (mSelectionCells == nil) {
        mSelectionCells = [NSMutableArray arrayWithCapacity:0];
        for (int i=0; i < [mSelectionTitles count]; i++) {
            UIImage *image = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(mBaseFrame.size.width, kOptionHeight)];
            UIImageView *newCell = [[UIImageView alloc] initWithImage:image];
            newCell.frame = CGRectMake(0, mBaseFrame.size.height + (i * kOptionHeight + kOptionSpacing) + kOptionSpacing, mBaseFrame.size.width, kOptionHeight);
            newCell.layer.anchorPoint = CGPointMake(0.5, 0.0);
            newCell.layer.transform = [self contractedTransorm];
            //newCell.alpha = 0;
            
            UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectInset(newCell.bounds, 10, 0)];
            newLabel.font = [UIFont systemFontOfSize:14];
            newLabel.backgroundColor = mTitleLabel.backgroundColor;
            newLabel.textColor = [UIColor blackColor];
            newLabel.text = [mSelectionTitles objectAtIndex:i];
            [newCell addSubview:newLabel];
            
            [self addSubview:newCell];
            [mSelectionCells addObject:newCell];
        }
    }
    
    // Expand our frame
    CGRect newFrame = mBaseFrame;
    newFrame.size.height += [mSelectionOptions count] * (kOptionHeight + kOptionSpacing);
    self.frame = newFrame;

    // Show selection cells animated
    int count = [mSelectionCells count];
    for (int i = 0; i < count; i++) {
        UIView *cell = [mSelectionCells objectAtIndex:i];
        cell.alpha = 1.0;
        [UIView animateWithDuration:kAnimationDuration delay:(i * kAnimationDuration / count) options:0 animations:^{
            CGRect destinationFrame = CGRectMake(0, mBaseFrame.size.height + i * (kOptionHeight + kOptionSpacing) + kOptionSpacing, mBaseFrame.size.width, kOptionHeight);
            cell.frame = destinationFrame;
            cell.layer.transform = CATransform3DIdentity;
        } completion:nil];
    }
}

- (void)inactivateControl {
    mControlIsActive = NO;
    
    [self.delegate comboBox:self didFinishWithSelection:nil];
    
    int count = [mSelectionCells count];
    for (int i = count - 1; i >= 0; i--) {
        UIView *cell = [mSelectionCells objectAtIndex:i];
        [UIView animateWithDuration:kAnimationDuration delay:((count - 1 - i) * kAnimationDuration / count) options:0 animations:^{
            cell.frame = CGRectMake(0, mBaseFrame.size.height + (i * kOptionHeight + kOptionSpacing) + kOptionSpacing, mBaseFrame.size.width, mBaseFrame.size.height);
            cell.layer.transform = [self contractedTransorm];
        } completion:^(BOOL completed){
            cell.alpha = 0;
            if (i == 0) {
                self.frame = mBaseFrame;
            }
    }];
    }
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.delegate comboBoxDidResizeFrame:self];
}

-(void)setSelection:(id)selection{
    
    [self setTitle: [mSelectionTitles objectAtIndex:mSelectionIndex]];
    
    _selection = selection;
}

@end
