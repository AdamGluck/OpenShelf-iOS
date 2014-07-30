//
//  OSCornerButton.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/29/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSCornerButton : UIButton
-(id)initWithFrame:(CGRect)aRect color:(UIColor *)color;
-(void)setButtonColor:(UIColor *)buttonColor;
@end
