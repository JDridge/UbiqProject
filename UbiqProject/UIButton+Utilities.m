//
//  UIButton+Utilities.m
//  UbiqProject
//
//  Created by Robert Vo on 11/26/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import "UIButton+Utilities.h"
#import "LoginFormViewController.h"

@implementation UIButton (Utilities)

+ (UIButton *)getGenericButton:(NSString *)title selectorActionName:(NSString *)selectorMethod {
    UIButton *newButton = [[UIButton alloc] initWithFrame:[self getDefaultButtonSize]];
    [newButton setTitle:title forState:UIControlStateNormal];
    newButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    newButton.layer.borderWidth = 2.0f;
    newButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [newButton setTintColor:[UIColor whiteColor]];
    
    SEL method = NSSelectorFromString(selectorMethod);
    [newButton addTarget:[[LoginFormViewController alloc] init] action:method forControlEvents:UIControlEventTouchUpInside];
    
    return newButton;
}

+ (CGRect)getDefaultButtonSize {
    return CGRectMake(10, 200, 500, 150);
}


@end
