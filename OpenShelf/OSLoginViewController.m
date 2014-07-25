
#import "OSLoginViewController.h"
#import "OSLoginManager.h"
#import "OSNetworking.h"
#import "OSUser.h"
#import "NSObject+MappableObject.h"
#import "BZGFormField.h"
#import "OSEmailFormField.h"
#import "OSPasswordField.h"
#import "OSPasswordConfirmField.h"
#import "UIView+Utilities.h"

static CGFloat buttonWidth = 250.0f;
static CGFloat buttonHeight = 50.0f;
static CGFloat imageWidth = 50.f;
static CGFloat fieldWidth = 250.0f;
static CGFloat fieldHeight = 50.0f;
static CGFloat columnPadding = 15.0f;

@interface OSLoginViewController ()
@property (strong, nonatomic) UIButton *dismissButton;
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *createAccountButton;
@property (strong, nonatomic) UIButton *toggleViewButton;
@property (strong, nonatomic) UIView *createAccountView;
@property (strong, nonatomic) UIView *loginView;
@property (strong, nonatomic) BZGFormField *emailField;
@property (strong, nonatomic) BZGFormField *passwordField;
@property (strong, nonatomic) OSEmailFormField *signupEmailField;
@property (strong, nonatomic) OSPasswordField *signupPasswordField;
@property (strong, nonatomic) OSPasswordConfirmField *signupPasswordConfirmField;

@end

@implementation OSLoginViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setupLoginView];
    [self setupCreateAccountView];
    [self setupCommonViews];
    //GESTURE - Dismiss the keyboard when tapped on the controller's view
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
//    [self.loginView addGestureRecognizer:tap];
//    [self.createAccountView addGestureRecognizer:tap];
    tap.delegate = self;
    
    
}


- (void) setupLoginView
{
    self.loginView = [[UIView alloc]initWithFrame:self.view.frame];
    self.loginView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.loginView];
    
    //Email Form
    self.emailField = [[BZGFormField alloc]initWithFrame:CGRectMake(self.view.center.x  - fieldWidth/2, self.view.center.y, fieldWidth, fieldHeight)];
    self.emailField.textField.placeholder = @"EMAIL";
    
    //    BlurView *emailView = [self blurredViewWithImageNamed:@"user" formField:self.passwordField];
    
    //Password Form
    self.passwordField = [[BZGFormField alloc]initWithFrame:CGRectMake(self.emailField.frame.origin.x, self.emailField.frame.origin.y + fieldHeight + columnPadding, fieldWidth, fieldHeight)];
    self.passwordField.textField.placeholder = @"PASSWORD";
//    BlurView *passwordView = [self blurredViewWithImageNamed:@"lock" formField:self.passwordField];

    //BUTTON
    UIButton * loginButton = [self buttonWithTitle:@"LOGIN" action:@selector(attemptLogin)];
    loginButton.center = CGPointMake(self.view.center.x, self.passwordField.center.y + buttonHeight + columnPadding);
    
    [self.loginView addSubview:self.emailField];
    [self.loginView addSubview:self.passwordField];
    [self.loginView addSubview:loginButton];
    
//    [self.loginView addSubview:emailView];
//    [self.loginView addSubview:passwordView];
//    [self.blurViews addObjectsFromArray:@[emailView, passwordView]];
    
//    NSArray *viewsToPosition = @[self.emailField, self.passwordField, loginButton];
//    [self positionViewColumnStartingAtPoint:self.view.center viewArray:viewsToPosition];
    
}



-(void)setupCreateAccountView{
    self.createAccountView = [[UIView alloc]initWithFrame:self.view.frame];
    self.createAccountView.backgroundColor = [UIColor clearColor];
    self.createAccountView.hidden = YES;
    
    [self.view addSubview:self.createAccountView];
    
    //Create account button setup
    self.createAccountButton = [self buttonWithTitle:@"Create Account" action:@selector(attemptLogin)];
    
    //Email Form
    self.signupEmailField = [[OSEmailFormField alloc]initWithFrame:CGRectMake(0, 0, fieldWidth, fieldHeight)];
//    BlurView *signUpEmailView = [self blurredViewWithImageNamed:@"user" formField:self.signupEmailField];
    
    //Password Form
    self.signupPasswordField = [[OSPasswordField alloc]initWithFrame:CGRectMake(0, 0, fieldWidth, fieldHeight)];
    self.passwordField.textField.placeholder = @"PASSWORD";
//    BlurView *signupPasswordView = [self blurredViewWithImageNamed:@"lock" formField:self.signupPasswordField];
    
    
    //Confirm Password Form
    self.signupPasswordConfirmField = [[OSPasswordConfirmField alloc]initWithFrame:CGRectMake(0, 0, fieldWidth, fieldHeight)];
    self.signupPasswordConfirmField.textField.placeholder = @"CONFIRM PASSWORD";
//    BlurView *signUpPasswordConfirmView = [self blurredViewWithImageNamed:@"user" formField:self.signupPasswordConfirmField];
    
    NSArray *views = @[self.signupEmailField, self.signupPasswordField, self.signupPasswordConfirmField, self.createAccountButton];
    
    [self.createAccountView addMultipleSubviews:views];
    
    [self positionViewColumnStartingAtPoint:CGPointMake(self.view.center.x, self.view.center.y - buttonHeight)  viewArray:views];
    
//    [self.blurViews addObjectsFromArray: views];
}


-(void)setupCommonViews{
    [self setupLogo];
    [self setupToggleViewButton];
    [self setupDismissButton];
}

-(void)setupLogo{
    UIImageView * loginImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 110, 110)];
    [loginImage setImage:[UIImage imageNamed:@"logoclubby.png"]];
    loginImage.center = CGPointMake(self.view.frame.size.width/2, 120);
    [self.view addSubview:loginImage];
}

-(void)setupToggleViewButton{
    self.toggleViewButton = [self buttonWithTitle:@"Need an Account?" action:@selector(toggleViewButtonPressed)];
    CGFloat padding = self.toggleViewButton.frame.size.height;
    CGPoint toggleViewButtonPosition = CGPointMake(self.view.center.x, CGRectGetMaxY(self.view.frame) - padding);
    self.toggleViewButton.center = toggleViewButtonPosition;
    [self.view addSubview:self.toggleViewButton];
    
}

-(void)toggleViewButtonPressed{
    UIView *hiddenView = (self.createAccountView.hidden) ? self.createAccountView : self.loginView;
    UIView *visibleView = (self.createAccountView.hidden) ? self.loginView : self.createAccountView;
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         visibleView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         visibleView.hidden = YES;
                         hiddenView.hidden = NO;
                         [UIView animateWithDuration:0.5
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              hiddenView.alpha = 1.0;
                                          }
                                          completion:^(BOOL finished){
                                          }];
                     }];
    
}

-(void)setupDismissButton{
    _dismissButton = [self buttonWithTitle:@"X" action:@selector(dismissButtonPressed)];
    [_dismissButton sizeToFit];
    
    CGPoint dismissButtonPosition = CGPointMake(CGRectGetMaxX(self.view.frame) - _dismissButton.frame.size.width, _dismissButton.frame.size.width);
    _dismissButton.center = dismissButtonPosition;
    [self.view addSubview:_dismissButton];
    
}

-(void)positionViewColumnStartingAtPoint:(CGPoint)point viewArray:(NSArray *)views{
    UIView *firstView = views[0];
    firstView.center = point;
    for (int i = 1; i < views.count; i++) {
        UIView *view = views[i];
        UIView *previousView = views[i-1];
        view.center = CGPointMake(previousView.center.x, previousView.center.y + columnPadding + view.frame.size.height);
        
    }
    
}


//View creation helper methods

-(UIButton *)buttonWithTitle:(NSString *)title action:(SEL)selector{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight)];
    btn.backgroundColor = [UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:0.7];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:0.173 green:0.243 blue:0.314 alpha:1] forState:UIControlStateNormal];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


//-(BlurView *)blurredViewWithImageNamed:(NSString *)imageName formField:(BZGFormField *)formField{
//    BlurView *view = [[BlurView alloc] initWithFrame:CGRectMake(formField.frame.origin.x, formField.frame.origin.y, buttonWidth, buttonHeight)];
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
//    imageView.image = [UIImage imageNamed:imageName];
//    [view addSubview:imageView];
//    [view addSubview:formField];
//    return view;
//}



#pragma mark - Miscellaneous


-(void) dismissKeyboard
{
    [self.view endEditing:YES];

    
}

-(void)attemptLogin{
    if (self.passwordField.formFieldState == BZGFormFieldStateValid) {

        [[OSNetworking sharedInstance]loginWithEmail:self.emailField.textField.text password:self.passwordField.textField.text success:^(NSDictionary *dictionary, NSError *error) {
            NSLog(@"Login successful");
            OSUser *user = [OSUser createFromInfo:dictionary];
            [OSLoginManager sharedInstance].user = user;
            self.successfulLoginCompletion();
        } failure:^{
            NSLog(@"Failed to login");
        }];
    }
    else{
        NSLog(@"Form is invalid");
    }
}

-(void)dismissButtonPressed{
    [self dismissViewControllerAnimated:YES completion:^{
        self.cancelledLoginCompletion();
    }];
}

@end
