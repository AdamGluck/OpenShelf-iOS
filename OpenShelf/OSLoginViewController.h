

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GPUImage/GPUImage.h>
#import "BlurView.h"


@interface OSLoginViewController : UIViewController<UIGestureRecognizerDelegate>

@property (strong, nonatomic) BlurView *usernameView;
@property (strong, nonatomic) BlurView *passwordView;
@property (strong, nonatomic) UIView *sendButtonView;
@property (strong, nonatomic) UIButton *dismissButton;
@property (copy, nonatomic) void (^successfulLoginCompletion)(void);
@property (copy, nonatomic) void (^cancelledLoginCompletion)(void);

@end
