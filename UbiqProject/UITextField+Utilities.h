//
//  UITextField+Utilities.h
//  UbiqProject
//
//  Created by Robert Vo on 11/26/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Utilities) <UITextFieldDelegate>

+ (UITextField *)createGenericTextFieldWithPlaceholder:(NSString*)placeholder;

+ (UITextField *)createEmailAddressTextField;

+ (UITextField *)createPasswordTextField:(NSString *)passwordField;

+ (UITextField*)getNameTextField:(NSString*)name;

@end
