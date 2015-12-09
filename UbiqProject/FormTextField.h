//
//  FormTextField.h
//  UbiqProject
//
//  Created by Robert Vo on 11/27/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FormTextField;

typedef NS_ENUM(NSInteger, FormTextFieldStatus) {
    FormValidatingTextFieldStatusIndeterminate = -1,
    FormValidatingTextFieldStatusInvalid,
    FormValidatingTextFieldStatusValid
};

typedef NS_ENUM(NSUInteger, FormTextFieldValidatingType) {
    FormValidatingTextFieldTypeNothing,
    FormValidatingTextFieldTypeEmail,
    FormValidatingTextFieldTypeName,
    FormValidatingTextFieldTypePassword,
    FormValidatingTextFieldTypeAddress
};

@protocol FormValidatingTextFieldValidationDelegate <NSObject>
@optional
    -(FormTextFieldStatus)textFieldStatus:(FormTextField *)textField;
@end

@interface FormTextField : UITextField

@property (nonatomic, readonly) FormTextFieldStatus validationStatus;
@property (nonatomic) FormTextFieldValidatingType validationType;
@property (nonatomic, getter = isRequired) BOOL required;
@property (nonatomic) UIColor *indeterminateColor;
@property (nonatomic) UIColor *invalidColor;
@property (nonatomic) UIColor *validColor;
@property (nonatomic, copy) FormTextFieldStatus (^validationBlock)(void);
@property (nonatomic) NSRegularExpression *validationRegularExpression;
@property (nonatomic, weak) id <FormValidatingTextFieldValidationDelegate> validationDelegate;

- (UIImageView *)imageViewForValidStatus;
- (UIImageView *)imageViewForInvalidStatus;
- (UIImageView *)imageViewForIndeterminateStatus;
- (void)setValidationStatus:(FormTextFieldStatus)status;

@end




