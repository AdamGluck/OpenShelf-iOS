//
//  OSVideoBackgroundViewController.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/24/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GPUImage/GPUImage.h>
#import "BlurView.h"

@interface OSVideoBackgroundViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *blurViews;

@end
