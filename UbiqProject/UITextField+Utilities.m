#import "UITextField+Utilities.h"
#import "FormTextField.h"
#import "LoginFormViewController.h"

@implementation UITextField (Utilities)

+ (FormTextField *)createGenericTextFieldWithPlaceholder:(NSString*)placeholder {
    FormTextField *newGenericTextField = [[FormTextField alloc] initWithFrame:[UITextField getDefaultTextFieldSize]];
    newGenericTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    newGenericTextField.borderStyle = UITextBorderStyleRoundedRect;
    newGenericTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    newGenericTextField.font = [UIFont systemFontOfSize:15];
    newGenericTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    newGenericTextField.delegate = (id <UITextFieldDelegate>) self;
    newGenericTextField.placeholder = placeholder;
    return newGenericTextField;
}

+ (FormTextField *)createEmailAddressTextField {
    FormTextField *newEmailAddressTextField = [self createGenericTextFieldWithPlaceholder:@"Email Address"];
    newEmailAddressTextField.keyboardType = UIKeyboardTypeEmailAddress;
    newEmailAddressTextField.validationRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$" options:NSRegularExpressionCaseInsensitive error:NULL];
    newEmailAddressTextField.returnKeyType = UIReturnKeyNext;
    newEmailAddressTextField.delegate = (id <UITextFieldDelegate>) self;
    
    return newEmailAddressTextField;
}

+ (FormTextField *)createPasswordTextField:(NSString *)passwordField {
    FormTextField *newPasswordTextField = [self createGenericTextFieldWithPlaceholder:passwordField];
    newPasswordTextField.keyboardType = UIKeyboardTypeDefault;
    newPasswordTextField.returnKeyType = UIReturnKeyDone;
    newPasswordTextField.secureTextEntry = YES;
    newPasswordTextField.delegate = (id <UITextFieldDelegate>) self;
    
    if([passwordField isEqualToString:@"Password"]) {
        newPasswordTextField.validationType = FormValidatingTextFieldTypePassword;
    }
    else {
        newPasswordTextField.validationType = FormValidatingTextFieldTypeNothing;
    }
    
    return newPasswordTextField;
}

+ (FormTextField *)createNameTextField:(NSString*)name {
    FormTextField *nameTextField = [self createGenericTextFieldWithPlaceholder:name];
    nameTextField.keyboardType = UIKeyboardTypeDefault;
    nameTextField.placeholder = name;
    nameTextField.returnKeyType = UIReturnKeyNext;
    nameTextField.validationType = FormValidatingTextFieldTypeName;
    nameTextField.delegate = (id <UITextFieldDelegate>) self;
    
    return nameTextField;
}

+ (FormTextField *)createAddressTextField {
    FormTextField *newEmailAddressTextField = [self createGenericTextFieldWithPlaceholder:@"Your Address"];
    newEmailAddressTextField.keyboardType = UIKeyboardTypeEmailAddress;
    newEmailAddressTextField.validationType = //FormValidatingTextFieldTypePassword;
    newEmailAddressTextField.returnKeyType = UIReturnKeyNext;
    newEmailAddressTextField.delegate = (id <UITextFieldDelegate>) self;
    
    return newEmailAddressTextField;
}


+ (CGRect)getDefaultTextFieldSize {
    return CGRectMake(10, 200, 500, 150);
}



@end
