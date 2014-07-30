//
//  OSExpandableView.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/29/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSExpandableView.h"

@interface OSExpandableView()

@property (strong, nonatomic) UIColor *collapsedButtonColor;
@property (strong, nonatomic) UIColor *expandedButtonColor;
@property (strong, nonatomic) UIView *contentView;
@property (nonatomic) CGPoint collapsedContentCenter;
@property (nonatomic) CGSize expandButtonSize;
@end
@implementation OSExpandableView

-(void)didMoveToSuperview{
    self.frame = self.superview.frame;
    self.backgroundColor = [UIColor clearColor];
    
    
    self.contentView = [[UIView alloc] initWithFrame:self.frame];
    self.collapsedContentCenter = CGPointMake(self.center.x + self.contentView.frame.size.width, self.center.y - self.contentView.frame.size.height);
    self.contentView.center = self.collapsedContentCenter;
    self.contentView.backgroundColor = [OSTheme primaryColor2];

    
    
    self.detailButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0, self.contentView.frame.size.width * .7, self.contentView.frame.size.height/5)];
    self.detailButton.backgroundColor = [UIColor whiteColor];
    [self.detailButton setTitle:@"SHOW DETAILS" forState:UIControlStateNormal];
    [self.detailButton setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
    [self.contentView addSubview:self.detailButton];
    self.detailButton.center = CGPointMake(self.center.x, CGRectGetMaxY(self.frame) - self.detailButton.frame.size.height);
    
    [self addSubview:self.contentView];


    self.expandButton = [[OSCornerButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.frame) - self.expandButtonSize.width, 0, self.expandButtonSize.width, self.expandButtonSize.height) color:self.collapsedButtonColor];

    [self.expandButton addTarget:self action:@selector(toggleExpansion) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.expandButton];
    
    
    //Pass the touches through the detail button to the tableviewcell
    self.detailButton.userInteractionEnabled = NO;
    self.contentView.userInteractionEnabled = NO;

}
- (void)commonInit{
    
    self.expandButtonSize = self.frame.size;
    self.expandedButtonColor = [OSTheme primaryColor1];
    self.collapsedButtonColor = [OSTheme primaryColor2];
    self.isExpanded = NO;
}

- (id)initWithFrame:(CGRect)aRect{
    if ((self = [super initWithFrame:aRect])) {
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

-(void)toggleExpansion{
    if (self.isExpanded) {
        [self collapse];
        self.isExpanded = NO;
    }
    else{
        [self expand];
        self.isExpanded = YES;
    }
}

-(void)expand{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                        
                         self.contentView.center = self.center;
//                         self.expandButton.center = CGPointMake(CGRectGetMaxX(self.frame) - self.expandButton.frame.size.width / 2, self.expandButton.frame.size.height / 2);
                         [self.expandButton setButtonColor:self.expandedButtonColor];

                     }
                     completion:nil];
}

-(void)collapse{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.contentView.center = self.collapsedContentCenter;
//                         self.expandButton.frame = self.expandButtonFrame;
                         [self.expandButton setButtonColor:self.collapsedButtonColor];
                     }
                     completion:^(BOOL finished){
//                         self.backgroundColor = self.collapsedBackgroundColor;
                     }];
}

@end
