//
//  FormTextField.m
//  UbiqProject
//
//  Created by Robert Vo on 11/27/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import "FormTextField.h"
#import <MapKit/MapKit.h>


@interface FormTextField ()

@property (nonatomic, readwrite) FormTextFieldStatus validationStatus;
@property FormTextField* passwordField;
@property FormTextField* verifyPasswordField;
@end

@implementation FormTextField

static const CGFloat kStandardTextFieldHeight = 30;
static const CGFloat kIndicatorStrokeWidth = 2;
static const CGFloat kTextEdgeInset = 6;

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame;
{
    if (!(self = [super initWithFrame:frame])) return nil;
    return [self initialize];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder;
{
    if (!(self = [super initWithCoder:aDecoder])) return nil;
    return [self initialize];
}

- (instancetype)initialize;
{
    self.borderStyle = UITextBorderStyleNone;
    
    self.validColor = [UIColor colorWithHue:0.333 saturation:1 brightness:0.75 alpha:1];
    self.invalidColor = [UIColor colorWithHue:0 saturation:1 brightness:1 alpha:1];
    self.indeterminateColor = [UIColor colorWithWhite:0.75 alpha:1.0];
    
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    
    [self addTarget:self action:@selector(validate) forControlEvents:UIControlEventAllEditingEvents];
    
    self.validationStatus = FormValidatingTextFieldStatusIndeterminate;
    return self;
}

#pragma mark - Setters
- (void)setRequired:(BOOL)required
{
    _required = required;
    [self validate];
}

- (void)setValidationStatus:(FormTextFieldStatus)status;
{
    _validationStatus = status;
    switch (status) {
        case FormValidatingTextFieldStatusIndeterminate:
            self.layer.borderColor = self.indeterminateColor.CGColor;
            self.rightView = self.imageViewForIndeterminateStatus;
            break;
        case FormValidatingTextFieldStatusInvalid:
            self.layer.borderColor = self.invalidColor.CGColor;
            self.rightView = self.imageViewForInvalidStatus;
            break;
        case FormValidatingTextFieldStatusValid:
            self.layer.borderColor = self.validColor.CGColor;
            self.rightView = self.imageViewForValidStatus;
            break;
    }
    self.rightViewMode = UITextFieldViewModeAlways;
}

- (void)setValidationType:(FormTextFieldValidatingType)validationType;
{
    _validationType = validationType;
    
    switch (validationType) {
        case FormValidatingTextFieldTypeEmail:
            [self applyEmailValidation];
            break;
        case FormValidatingTextFieldTypeName:
            [self applyNameValidation];
            break;
        case FormValidatingTextFieldTypePassword:
            [self applyPasswordLengthValidation];
            break;
        case FormValidatingTextFieldTypeAddress:
            [self applyAddressValidation];
            break;
        default:
            [self clearAllValidationMethods];
            break;
    }
}

- (void)setValidationDelegate:(id<FormValidatingTextFieldValidationDelegate>)validationDelegate;
{
    [self clearAllValidationMethods];
    _validationDelegate = validationDelegate;
    [self validate];
}

- (void)setValidationBlock:(FormTextFieldStatus (^)(void))validationBlock;
{
    [self clearAllValidationMethods];
    _validationBlock = validationBlock;
    [self validate];
}

- (void)setValidationRegularExpression:(NSRegularExpression *)validationRegularExpression;
{
    [self clearAllValidationMethods];
    _validationRegularExpression = validationRegularExpression;
    [self validate];
}

#pragma mark - Setting built-in validation types
- (void)applyEmailValidation;
{
    [self clearAllValidationMethods];
    __weak FormTextField *weakSelf = self;
    self.validationBlock = ^{
        if (weakSelf.text.length < 4 && !weakSelf.isRequired) {
            return FormValidatingTextFieldStatusIndeterminate;
        }
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:NULL];
        NSArray *matches = [detector matchesInString:weakSelf.text options:0 range:NSMakeRange(0, weakSelf.text.length)];
        for (NSTextCheckingResult *match in matches) {
            if (match.resultType == NSTextCheckingTypeLink &&
                [match.URL.absoluteString rangeOfString:@"mailto:"].location != NSNotFound) {
                return FormValidatingTextFieldStatusValid;
            }
        }
        return FormValidatingTextFieldStatusInvalid;
    };
    [self validate];
}

- (void)applyNameValidation;
{
    [self clearAllValidationMethods];
    __weak FormTextField *weakSelf = self;
    self.validationBlock = ^{
        if (weakSelf.text.length == 0 && !weakSelf.isRequired) {
            return FormValidatingTextFieldStatusIndeterminate;
        }
        NSCharacterSet *onlyCharacters = [[NSCharacterSet letterCharacterSet] invertedSet];
        NSRange range = [weakSelf.text rangeOfCharacterFromSet:onlyCharacters];
        if (NSNotFound != range.location) {
            return FormValidatingTextFieldStatusInvalid;
        }
        return FormValidatingTextFieldStatusValid;
    };
    [self validate];
}


- (void)applyPasswordLengthValidation {
    [self clearAllValidationMethods];
    __weak FormTextField *weakSelf = self;
    self.validationBlock = ^{
        if (weakSelf.text.length < 6 && !weakSelf.isRequired) {
            return FormValidatingTextFieldStatusIndeterminate;
        }
        NSCharacterSet *illegalCharacters = [NSCharacterSet illegalCharacterSet];
        NSRange range = [weakSelf.text rangeOfCharacterFromSet:illegalCharacters];
        if (weakSelf.text.length < 6 || NSNotFound != range.location) {
            return FormValidatingTextFieldStatusInvalid;
        }
        return FormValidatingTextFieldStatusValid;
    };
    [self validate];
}

- (void)applyAddressValidation {
    [self clearAllValidationMethods];
    __weak FormTextField *weakSelf = self;
    self.validationBlock = ^{
        if (weakSelf.text.length < 2 && !weakSelf.isRequired) {
            return FormValidatingTextFieldStatusIndeterminate;
        }
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        __block BOOL found = NO;
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
        [geocoder geocodeAddressString:weakSelf.text completionHandler:^(NSArray* placemarks, NSError* error) {
            NSLog(@"start block");
            if([placemarks count] > 0) {
                MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:placemarks[0]];

                found = YES;
                NSLog(@"%f, %f", placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
            }
            else {
                found = NO;
            }
            dispatch_semaphore_signal(sema);
        }];
        while (dispatch_semaphore_wait(sema, DISPATCH_TIME_NOW)) { [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.5]]; }
        
        if(found) {
            return FormValidatingTextFieldStatusValid;
        }
        else {
            return FormValidatingTextFieldStatusInvalid;
        }
    };
    [self validate];
}



- (void)clearAllValidationMethods;
{
    _validationRegularExpression = nil;
    _validationDelegate = nil;
    _validationBlock = nil;
    _validationType = FormValidatingTextFieldTypeNothing;
}

#pragma mark - Validation
- (void)validate;
{
    if (self.validationDelegate) {
        self.validationStatus = [self.validationDelegate textFieldStatus:self];
    }
    else if (self.validationBlock) {
        self.validationStatus = self.validationBlock();
    }
    else if (self.validationRegularExpression) {
        [self validateWithRegularExpression];
    }
}

- (void)validateWithRegularExpression
{
    if (self.text.length == 0 && !self.isRequired) {
        self.validationStatus = FormValidatingTextFieldStatusIndeterminate;
    }
    else if ([self.validationRegularExpression numberOfMatchesInString:self.text
                                                               options:0
                                                                 range:NSMakeRange(0, self.text.length)]) {
        self.validationStatus = FormValidatingTextFieldStatusValid;
    }
    else {
        self.validationStatus = FormValidatingTextFieldStatusInvalid;
    }
}

#pragma mark - Indicator Image Generation

/** This shape is a dash */
- (UIImageView *)imageViewForIndeterminateStatus;
{
    CGContextRef context = [self beginImageContextAndSetPathStyle];
    
    CGContextMoveToPoint(context, 6, kStandardTextFieldHeight / 2.f);
    CGContextAddLineToPoint(context, 24, kStandardTextFieldHeight / 2.f);
    CGContextStrokePath(context);
    
    return [self finalizeImageContextAndReturnImageView];
}

/** This shape is an X */
- (UIImageView *)imageViewForInvalidStatus
{
    CGContextRef context = [self beginImageContextAndSetPathStyle];
    
    CGContextMoveToPoint(context, 6, 6);
    CGContextAddLineToPoint(context, 24, 24);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 6, 24);
    CGContextAddLineToPoint(context, 24, 6);
    CGContextStrokePath(context);
    
    return [self finalizeImageContextAndReturnImageView];
}

/** This shape is a check mark */
- (UIImageView *)imageViewForValidStatus;
{
    CGContextRef context = [self beginImageContextAndSetPathStyle];
    
    CGContextMoveToPoint(context, 6, 14);
    CGContextAddLineToPoint(context, 12, 24);
    CGContextAddLineToPoint(context, 24, 6);
    CGContextStrokePath(context);
    
    return [self finalizeImageContextAndReturnImageView];
}

- (CGContextRef)beginImageContextAndSetPathStyle;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kStandardTextFieldHeight, kStandardTextFieldHeight), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, kIndicatorStrokeWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGColorRef strokeColor = self.validColor.CGColor;
    
    if(self.validationStatus == FormValidatingTextFieldStatusIndeterminate) {
        strokeColor = self.indeterminateColor.CGColor;
    }
    else if (self.validationStatus == FormValidatingTextFieldStatusInvalid) {
        strokeColor = self.invalidColor.CGColor;
    }
    else if (self.validationStatus == FormValidatingTextFieldStatusValid) {
        strokeColor = self.validColor.CGColor;
    }
    CGContextSetStrokeColorWithColor(context, strokeColor);
    return context;
}

- (UIImageView *)finalizeImageContextAndReturnImageView;
{
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIImageView.alloc initWithImage:image];
}

#pragma mark - Custom UITextField rect sizing
- (CGRect)textRectForBounds:(CGRect)bounds;
{
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, kTextEdgeInset,
                                                          0, kStandardTextFieldHeight - kTextEdgeInset));
}

- (CGRect)editingRectForBounds:(CGRect)bounds;
{
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, kTextEdgeInset,
                                                          0, kStandardTextFieldHeight - kTextEdgeInset));
}


@end
