

#import "OSMainNavigationController.h"
#import "OSSideMenuViewController.h"

@interface OSMainNavigationController ()

@property (strong, readwrite, nonatomic) OSSideMenuViewController *menuViewController;

@end

@implementation OSMainNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenu) name:@"requestMenu" object:nil];
}

- (void)showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController panGestureRecognized:sender];
}

@end
