//
//  OSSideMenuViewController.m
//
//  Created by Brian Strobach on 7/1/14
//  Copyright (c) 2014 Open Shelf. All rights reserved.
//

#import "OSSideMenuViewController.h"
#import "OSLoginManager.h"

@implementation OSSideMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"avatar.jpg"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = @"Open Shelf";
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoggedOut) name:kUserLoggedOutNotification object:nil];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
//{
//    if (sectionIndex == 0)
//        return nil;
//
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
//    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
//
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
//    label.text = @"Friends Online";
//    label.font = [UIFont systemFontOfSize:15];
//    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor clearColor];
//    [label sizeToFit];
//    [view addSubview:label];
//
//    return view;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vcToPresent;
    switch (indexPath.row) {
        case 0:
            vcToPresent = self.accountViewController;
            break;
        case 1:
            vcToPresent = self.searchViewController;
            break;
        default:
            break;
    }
    //Checks if user is logged in before presenting account page
    if (vcToPresent == self.accountViewController && ![OSLoginManager sharedInstance].user) {
        [[OSLoginManager sharedInstance]presentLoginPage:self
                                        successfullLogin:^{
                                            [self switchContentVCToVC:vcToPresent];
                                        }
                                            canceldLogin:^{
                                                [self presentFailedLoginAlert];
                                            }];
    }
    else{
        [self switchContentVCToVC:vcToPresent];
    }
    
    
}

-(void)switchContentVCToVC:(UIViewController*)viewController{

    [self.navigationController setViewControllers:@[viewController]];
    
    self.frostedViewController.contentViewController = self.navigationController;
    
    [self.frostedViewController hideMenuViewController];
}

-(void)userLoggedOut{
    [self switchContentVCToVC:self.searchViewController];
}

-(void)presentFailedLoginAlert{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Failed to login"
                                                 message:@"You must login to view your account page, ASSHOLE."
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [av show];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MenuCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSArray *titles = @[@"Account", @"Search"];
    cell.textLabel.text = titles[indexPath.row];
    
    
    return cell;
}

#pragma mark - Custom Getters/Setters

- (OSSearchViewController *)searchViewController {
    if (!_searchViewController) {
        _searchViewController = [[UIStoryboard storyboardWithName:@"iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"searchController"];
    }
    
    return _searchViewController;
}

- (OSAccountTableViewController *)accountViewController {
    if (!_accountViewController) {
        _accountViewController = [[UIStoryboard storyboardWithName:@"iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"accountController"];
    }
    
    return _accountViewController;
}

//- (OSExploreViewController *)exploreViewController {
//    if (!_exploreViewController) {
//        _exploreViewController =  [[UIStoryboard storyboardWithName:@"iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"exploreController"];
//    }
//    
//    return _exploreViewController;
//}

- (OSMainNavigationController *)navigationController {
    if (!_navigationController) {
        _navigationController = [[OSMainNavigationController alloc] initWithRootViewController:self.accountViewController];
    }
    
    return _navigationController;
}

@end
