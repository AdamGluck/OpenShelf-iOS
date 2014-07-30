

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GPUImage/GPUImage.h>
#import "BlurView.h"
#import "OSVideoBackgroundViewController.h"


@interface OSLoginViewController : OSVideoBackgroundViewController<UIGestureRecognizerDelegate, UITextFieldDelegate>


@property (copy, nonatomic) void (^successfulLoginCompletion)(void);
@property (copy, nonatomic) void (^cancelledLoginCompletion)(void);

@end
