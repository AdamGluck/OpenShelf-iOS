//
//  OSContentViewController.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/1/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSContentViewController.h"

@interface OSContentViewController ()

@end

@implementation OSContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(requestMenu)];
    
}

-(void)requestMenu{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"requestMenu" object:self];
}

@end
