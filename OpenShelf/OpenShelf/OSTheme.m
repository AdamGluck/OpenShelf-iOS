//
//  OSTheme.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/29/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSTheme.h"
#import "BZGFormField.h"

static NSString *kLabelFont = @"Montserrat-Regular";
static NSString *kPrimaryFont = @"Montserrat-Regular";
static NSString *kPrimaryFontBold = @"Montserrat-Bold";
static int kLabelFontSize = 30;
static int kButtonFontSize = 20;



@implementation OSTheme

+ (void)applyTheme
{
    [self applyThemeToTableCells];
    [self applyThemeToStatusBar];
    [self applyThemeToNavigationBar];
    [self applyThemeToFormFields];
    [self applyThemeToButtons];
//    [self applyThemeToLabels];
}

+ (void)applyThemeToTableCells
{

}

+ (void)applyThemeToStatusBar
{
    // Apply theme to UIStatusBar
}

+ (void)applyThemeToNavigationBar
{
    
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setBarTintColor:[UIColor colorWithRed:46.0/255.0 green:138.0/255.0 blue:95.0/255.0 alpha:1.0]];
    [navigationBarAppearance setTintColor:[UIColor whiteColor]];
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:kPrimaryFont size:20], NSFontAttributeName, nil];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];

}

+ (void)applyThemeToFormFields{
    
    BZGFormField *formFieldAppearance = [BZGFormField appearance];
    [formFieldAppearance setBackgroundColor:[UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:0.7]];
}

+ (void)applyThemeToButtons{
    UIButton *buttonAppearance = [UIButton appearance];
    [buttonAppearance.titleLabel setFont:[UIFont fontWithName:kPrimaryFont size:kButtonFontSize]];
}

+ (void)applyThemeToLabels{
    UILabel *labelAppearance = [UILabel appearance];
    
    [labelAppearance setFont:[UIFont fontWithName:kLabelFont size:kLabelFontSize]];
}

+ (UIFont *)labelFont
{
    return [self labelFontOfSize:kLabelFontSize];
}

+ (UIFont *)labelFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:kLabelFont size:size];
}

+(UIColor *)primaryColor1{
    return [UIColor colorWithRed:35.0/255.0 green:95.0/255.0 blue:64.0/255.0 alpha:1.0];
}

+(UIColor *)primaryColor2{
   return [UIColor colorWithRed:41.0/255.0 green:149.0/255.0 blue:101.0/255.0 alpha:1.0];
}
@end
