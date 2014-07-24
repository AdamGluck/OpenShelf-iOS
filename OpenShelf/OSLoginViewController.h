

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GPUImage/GPUImage.h>
#import "BlurView.h"
#import "OSVideoBackgroundViewController.h"


@interface OSLoginViewController : OSVideoBackgroundViewController<UIGestureRecognizerDelegate>

@property (strong, nonatomic) BlurView *usernameView;
@property (strong, nonatomic) BlurView *passwordView;
@property (strong, nonatomic) UIView *loginButtonView;
@property (strong, nonatomic) UIButton *dismissButton;
@property (copy, nonatomic) void (^successfulLoginCompletion)(void);
@property (copy, nonatomic) void (^cancelledLoginCompletion)(void);

@end
