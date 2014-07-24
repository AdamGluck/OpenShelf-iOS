
#import "OSLoginViewController.h"
#import "OSLoginManager.h"
#import "OSNetworking.h"
#import "OSUser.h"
#import "NSObject+MappableObject.h"
static CGFloat buttonWidth = 250.0f;
static CGFloat buttonHeight = 50.0f;
static CGFloat fieldWidth = 150.0f;
static CGFloat fieldHeight = 30.0f;

@interface OSLoginViewController ()
@property (strong, nonatomic) UIView *createAccountView;
@property (strong, nonatomic) UIView *loginView;
@property (strong, nonatomic) UITextField *usernameTf;
@property (strong, nonatomic) UITextField *passwordTf;
@end

@implementation OSLoginViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setupLoginView];
    [self setupCreateAccountView];
    //GESTURE - Dismiss the keyboard when tapped on the controller's view
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    
    
}


- (void) setupLoginView
{
    self.loginView = [[UIView alloc]initWithFrame:self.view.frame];
    self.loginView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.loginView];
    UIImageView * loginImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 110, 110)];
    [loginImage setImage:[UIImage imageNamed:@"logoclubby.png"]];
    loginImage.center = CGPointMake(self.view.frame.size.width/2, 120);
    [self.loginView addSubview:loginImage];
    

    _passwordView = [[BlurView alloc] initWithFrame:CGRectMake(35, 300, buttonWidth, buttonHeight)];
    
    //BUTTON
    UIButton * loginButton = [self buttonWithTitle:@"LOGIN" action:@selector(attemptLogin)];
    [self.loginView addSubview:loginButton];
    
    
    //USERNAME Text Field
    _usernameView = [[BlurView alloc] initWithFrame:CGRectMake(35, 245, buttonWidth, buttonHeight)];
    UIImageView * userImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 61, 50)];
    [userImage setImage:[UIImage imageNamed:@"user.png"]];
    
    [_usernameView addSubview:userImage];
    
    
    _usernameTf = [[UITextField alloc]initWithFrame:CGRectMake(60, 10, fieldWidth, fieldHeight)];
    _usernameTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"USERNAME" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    _usernameTf.textColor = [UIColor whiteColor];
    [_usernameView addSubview:_usernameTf];
    
    
    //PASSWORD Text Field
    UIImageView * lockImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 61, 50)];
    [lockImage setImage:[UIImage imageNamed:@"lock.png"]];
    [_passwordView addSubview:lockImage];
    
    _passwordTf = [[UITextField alloc]initWithFrame:CGRectMake(60, 10, fieldWidth, fieldHeight)];
    _passwordTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PASSWORD" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    _passwordTf.textColor = [UIColor whiteColor];
    [_passwordView addSubview:_passwordTf];
    [self.loginView addSubview:_usernameView];
    [self.loginView addSubview:_passwordView];
    [self.loginView addSubview:loginButton];
    
    [self.blurViews addObjectsFromArray:@[_usernameView, _passwordView]];
    
}

-(void)setupCreateAccountView{
    self.createAccountView = [[UIView alloc]initWithFrame:self.view.frame];
    self.createAccountView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.createAccountView];
    
    
    //Create account button setup
    UIButton * createAccountButton = [self buttonWithTitle:@"Create Account" action:@selector(attemptLogin)];
    [self.createAccountView addSubview:createAccountButton];
    self.createAccountView.hidden = YES;
    
}

-(void)setupDismissButton{
    //Dismiss button
    
    _dismissButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _dismissButton.backgroundColor = [UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:0.7];
    [_dismissButton setTitle:@"X" forState:UIControlStateNormal];
    [_dismissButton setTitleColor:[UIColor colorWithRed:0.173 green:0.243 blue:0.314 alpha:1] forState:UIControlStateNormal];
    CGFloat padding = self.dismissButton.frame.size.width;
    CGPoint dismissButtonPosition = CGPointMake(CGRectGetMaxX(self.view.frame) - padding, padding);
    _dismissButton.center = dismissButtonPosition;
    
    [_dismissButton addTarget:self action:@selector(dismissButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dismissButton];
    
}

-(UIButton *)buttonWithTitle:(NSString *)title action:(SEL)selector{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight)];
    btn.backgroundColor = [UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:0.7];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:0.173 green:0.243 blue:0.314 alpha:1] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(selector) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


#pragma mark - Miscellaneous


-(void) dismissKeyboard
{
    [self.usernameTf resignFirstResponder];
    [self.passwordTf resignFirstResponder];
}

-(void)attemptLogin{
    [[OSNetworking sharedInstance]loginWithUsername:self.usernameTf.text password:self.passwordTf.text success:^(NSDictionary *dictionary, NSError *error) {
        OSUser *user = [OSUser createFromInfo:dictionary];
        [OSLoginManager sharedInstance].user = user;
        self.successfulLoginCompletion();
    } failure:^{
        NSLog(@"Failed to login");
    }];
}

-(void)dismissButtonPressed{
    [self dismissViewControllerAnimated:YES completion:^{
        self.cancelledLoginCompletion();
    }];
}

@end
