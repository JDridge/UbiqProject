#import "UITextField+Utilities.h"
#import "LoginFormViewController.h"

@implementation UITextField (Utilities)

+ (UITextField *)createGenericTextFieldWithPlaceholder:(NSString*)placeholder {
    UITextField *newGenericTextField = [[UITextField alloc] initWithFrame:[LoginFormViewController getDefaultRectangleSize]];
    newGenericTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    newGenericTextField.borderStyle = UITextBorderStyleRoundedRect;
    newGenericTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    newGenericTextField.font = [UIFont systemFontOfSize:15];
    newGenericTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    newGenericTextField.delegate = (id <UITextFieldDelegate>) self;
    newGenericTextField.placeholder = placeholder;
    
    return newGenericTextField;
}

+ (UITextField *)createEmailAddressTextField {
    UITextField *newEmailAddressTextField = [self createGenericTextFieldWithPlaceholder:@"Email Address"];
    newEmailAddressTextField.keyboardType = UIKeyboardTypeEmailAddress;
    
    return newEmailAddressTextField;
}

+ (UITextField *)createPasswordTextField:(NSString *)passwordField {
    UITextField *newPasswordTextField = [self createGenericTextFieldWithPlaceholder:passwordField];
    newPasswordTextField.keyboardType = UIKeyboardTypeDefault;
    newPasswordTextField.returnKeyType = UIReturnKeyDone;
    newPasswordTextField.secureTextEntry = YES;
    
    return newPasswordTextField;
}

+ (UITextField *)getNameTextField:(NSString*)name {
    UITextField *nameTextField = [self createGenericTextFieldWithPlaceholder:name];
    nameTextField.keyboardType = UIKeyboardTypeDefault;
    nameTextField.placeholder = name;
    nameTextField.returnKeyType = UIReturnKeyDone;
    
    return nameTextField;
}


@end
