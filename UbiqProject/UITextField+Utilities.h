#import <UIKit/UIKit.h>
#import "FormTextField.h"

@interface UITextField (Utilities) <UITextFieldDelegate>

+ (FormTextField *)createGenericTextFieldWithPlaceholder:(NSString*)placeholder;
+ (FormTextField *)createEmailAddressTextField;
+ (FormTextField *)createPasswordTextField:(NSString *)passwordField;
+ (FormTextField *)createNameTextField:(NSString*)name;
+ (FormTextField *)createAddressTextField;

@end
