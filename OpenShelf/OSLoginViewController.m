
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
#import "SSKeychain.h"

static CGFloat buttonWidth = 250.0f;
static CGFloat buttonHeight = 50.0f;
static CGFloat imageWidth = 50.f;
static CGFloat fieldWidth = 250.0f;
static CGFloat fieldHeight = 50.0f;
static CGFloat columnPadding = 15.0f;
static CGFloat switchWidth = 100.0f;
static CGFloat switchHeight = 50.0f;

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
@property (strong, nonatomic) UISwitch *autoLoginSwitch;
@property (strong, nonatomic) UIImageView *logoImageView;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
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
    [self setupAutoLoginSwitch];
}

-(void)setupCreateAccountView{
    self.createAccountView = [[UIView alloc]initWithFrame:self.view.frame];
    self.createAccountView.backgroundColor = [UIColor clearColor];
    self.createAccountView.hidden = YES;
    
    [self.view addSubview:self.createAccountView];
    
    //Create account button setup
    self.createAccountButton = [self buttonWithTitle:@"Create Account" action:@selector(attemptAccountCreation)];
    
    //Email Form
    self.signupEmailField = [[OSEmailFormField alloc]initWithFrame:CGRectMake(0, 0, fieldWidth, fieldHeight)];
    
    //Password Form
    self.signupPasswordField = [[OSPasswordField alloc]initWithFrame:CGRectMake(0, 0, fieldWidth, fieldHeight)];
    
    //Confirm Password Form
    self.signupPasswordConfirmField = [[OSPasswordConfirmField alloc]initWithFrame:CGRectMake(0, 0, fieldWidth, fieldHeight)];
    [self.signupPasswordConfirmField setPasswordField: self.signupPasswordField];
    
    NSArray *views = @[self.signupEmailField, self.signupPasswordField, self.signupPasswordConfirmField, self.createAccountButton];
    
    [self.createAccountView addMultipleSubviews:views];
    
    [self positionViewColumnStartingAtPoint:CGPointMake(self.view.center.x, self.view.center.y - buttonHeight)  viewArray:views];
    
}


-(void)setupCommonViews{
    [self setupLogo];
    [self setupToggleViewButton];
    [self setupDismissButton];
}

-(void)setupLogo{
    self.logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 110, 110)];
    [self.logoImageView setImage:[UIImage imageNamed:@"logoclubby.png"]];
    self.logoImageView.center = CGPointMake(self.view.frame.size.width/2, 120);
    [self.view addSubview:self.logoImageView];
}

-(void)setupToggleViewButton{
    self.toggleViewButton = [self buttonWithTitle:@"Don't have an Account? Sign up!" action:@selector(toggleViewButtonPressed)];
    self.toggleViewButton.titleLabel.adjustsFontSizeToFitWidth = TRUE;
    
    CGFloat padding = self.toggleViewButton.frame.size.height;
    CGPoint toggleViewButtonPosition = CGPointMake(self.view.center.x, CGRectGetMaxY(self.view.frame) - padding);
    self.toggleViewButton.center = toggleViewButtonPosition;
    [self.view addSubview:self.toggleViewButton];
    
}

-(void)setupAutoLoginSwitch{
    self.autoLoginSwitch = [[UISwitch alloc]init];
    self.autoLoginSwitch.center = CGPointMake(self.emailField.frame.origin.x + self.autoLoginSwitch.frame.size.width / 2, self.emailField.frame.origin.y - self.autoLoginSwitch.frame.size.height /2 - columnPadding);
    [self.autoLoginSwitch setOn:FALSE];
    [self.loginView addSubview:self.autoLoginSwitch];
    
    UILabel *switchLabel = [[UILabel alloc]init];
    [switchLabel setTextColor:[UIColor whiteColor]];
    [switchLabel setText:@"REMEMBER ME"];
    [switchLabel sizeToFit];
    switchLabel.center = CGPointMake(self.view.center.x, self.autoLoginSwitch.center.y);
    [self.loginView addSubview:switchLabel];
}

-(void)toggleViewButtonPressed{
    NSString *newTitle = ([self.toggleViewButton.titleLabel.text isEqualToString:@"Don't have an Account? Sign up!"]) ? @"Already have an account? Sign in!" : @"Don't have an Account? Sign up!";
    [self.toggleViewButton setTitle:newTitle forState:UIControlStateNormal];
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
        
        [[OSNetworking sharedInstance]loginWithEmail:self.emailField.textField.text
                                            password:self.passwordField.textField.text
                                             success:^(NSDictionary *dictionary) {
                                                 NSLog(@"Login successful");
                                                 OSUser *user = [OSUser createFromInfo:dictionary];
                                                 [OSLoginManager sharedInstance].user = user;
                                                 
                                                 //Save auto-login preferences to user defaults
                                                 if ([self.autoLoginSwitch isOn]) {
                                                     NSString *email = self.emailField.textField.text;
                                                     NSString *password = self.passwordField.textField.text;
                                                     NSError *error;
                                                     [SSKeychain setPassword:password forService:[[NSBundle mainBundle] bundleIdentifier] account:email error:&error];
                                                     if (error) {
                                                         NSLog(@"%@", [error localizedDescription]);
                                                     }
                                                 }
                                                 
                                                 
                                                 [self dismissViewControllerAnimated:YES completion:^{
                                                     self.successfulLoginCompletion();
                                                 }];
                                             } failure:^(NSError *error){
                                                 NSLog(@"Failed to login");
                                             }];
    }
    else{
        NSLog(@"Form is invalid");
    }
}

-(void)attemptAccountCreation{
    if (self.signupEmailField.formFieldState == BZGFormFieldStateValid && self.signupPasswordField.formFieldState == BZGFormFieldStateValid && self.signupPasswordConfirmField.formFieldState == BZGFormFieldStateValid) {
        [[OSNetworking sharedInstance]createAccountWithEmail:self.signupEmailField.textField.text
                                                    password:self.signupPasswordField.textField.text
                                        passwordConfirmation:self.signupPasswordConfirmField.textField.text success:^(NSDictionary *dictionary) {
                                            NSLog(@"Account Created Successfully");
                                        } failure:^(NSError *error){
                                            NSLog(@"Account Creation Failed");
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

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    // the keyboard is hiding reset the table's height
    NSTimeInterval animationDuration =
    [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    frame.origin.y += 180;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}


- (void)keyboardWillShow:(NSNotification *)aNotification
{
    // the keyboard is showing so resize the table's height
    NSTimeInterval animationDuration =
    [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    frame.origin.y -= 180;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

@end
