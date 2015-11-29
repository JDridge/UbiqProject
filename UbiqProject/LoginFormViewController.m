//
//  LoginFormViewController.m
//  UbiqProject
//
//  Created by Robert Vo on 11/24/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import "LoginFormViewController.h"
#import "UITextField+Utilities.h"
#import "UIButton+Utilities.h"
#import "FormTextField.h"

@implementation LoginFormViewController

@synthesize LoginButton, SignUpButton, LoginSignUpForm, WelcomeLabel, backgroundVideo;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self playVideo];
    [self setupLabelsAndButtonsOnStart];
    [self addGestureToDismissKeyboardOnTap];
}

-(void)playVideo {
    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"video" withExtension:@"mov"];
    backgroundVideo = [AVPlayer playerWithURL:videoURL];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:backgroundVideo];
    playerLayer.frame = self.view.frame;
    [self.view.layer addSublayer:playerLayer];
    [backgroundVideo play];

    backgroundVideo.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[backgroundVideo currentItem]];

}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *playerItem = [notification object];
    [playerItem seekToTime:kCMTimeZero];
}

- (void) setupLabelsAndButtonsOnStart {
    UIView *filter = [[UIView alloc] initWithFrame:self.view.frame];
    filter.backgroundColor = [UIColor blackColor];
    filter.alpha = 0.05;
    [self.view addSubview:filter];
    
    WelcomeLabel.text = @"WELCOME";
    WelcomeLabel.textColor = [UIColor whiteColor];
    WelcomeLabel.font = [UIFont systemFontOfSize:50];
    WelcomeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:WelcomeLabel];
    
    LoginButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    LoginButton.layer.borderWidth = 2.0;
    LoginButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [LoginButton setTintColor:[UIColor whiteColor]];
    [self.view addSubview:LoginButton];


    SignUpButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    SignUpButton.layer.borderWidth = 2.0f;
    SignUpButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [SignUpButton setTintColor:[UIColor whiteColor]];
    [self.view addSubview:SignUpButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (IBAction)LoginButtonTouched:(id)sender {
    [self removeAllFromStackView];
    [self flipHiddenStatus:YES];

    NSLog(@"Login...");
    
    [UIView animateWithDuration:0.25 animations:^{
        
        UITextField *emailAddressTextField = [UITextField createEmailAddressTextField];
        [emailAddressTextField becomeFirstResponder];
        
        [LoginSignUpForm addArrangedSubview:emailAddressTextField];

        UITextField *passwordTextField = [UITextField createPasswordTextField:@"Password"];
        [LoginSignUpForm addArrangedSubview:passwordTextField];

        UIButton *signInButton = [UIButton getGenericButton:@"Sign In!" selectorActionName:@"signIn:"];
        [LoginSignUpForm addArrangedSubview:signInButton];
        
        UIButton *backButton = [UIButton getGenericButton:@"Back!" selectorActionName:@"backButtonTouched:"];
        [LoginSignUpForm addArrangedSubview:backButton];
    }];
    
    [self.view addSubview:LoginSignUpForm];
    
}

- (IBAction)SignUpButtonTouched:(id)sender {
    [self removeAllFromStackView];
    [self flipHiddenStatus:YES];
    NSLog(@"Signup...");
    
    UITextField *firstNameTextField = [UITextField createNameTextField:@"First Name"];
    [firstNameTextField becomeFirstResponder];
    [LoginSignUpForm addArrangedSubview:firstNameTextField];

    UITextField *lastNameTextField = [UITextField createNameTextField:@"Last Name"];
    [LoginSignUpForm addArrangedSubview:lastNameTextField];

    UITextField *emailAddressTextField = [UITextField createEmailAddressTextField];
    [LoginSignUpForm addArrangedSubview:emailAddressTextField];

    UITextField *passwordTextField = [UITextField createPasswordTextField:@"Password"];
    passwordTextField.tag = 10;
    passwordTextField.delegate = self;

    [LoginSignUpForm addArrangedSubview:passwordTextField];

    UITextField *verifyPasswordTextField = [UITextField createPasswordTextField:@"Verify Password"];
    verifyPasswordTextField.tag = 20;
    verifyPasswordTextField.delegate = self;

    [LoginSignUpForm addArrangedSubview:verifyPasswordTextField];

    UIButton *registerButton = [UIButton getGenericButton:@"Register!" selectorActionName:@"registerForm:"];
    [LoginSignUpForm addArrangedSubview:registerButton];

    UIButton *backButton = [UIButton getGenericButton:@"Back!" selectorActionName:@"backButtonTouched:"];
    [LoginSignUpForm addArrangedSubview:backButton];
    
    [self.view addSubview:LoginSignUpForm];

}

- (void) registerForm:(UIButton*)sender {
    NSLog(@"Registering...");

//    PFObject *gameScore = [PFObject objectWithClassName:@"GameTable"];
//    gameScore[@"score"] = @1337;
//    gameScore[@"playerName"] = @123;
//    gameScore[@"ragisuvhfds"] = @"maybe";
//    [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            NSLog(@"success");
//            // The object has been saved.
//        } else {
//            [self displayError:error];
//        }
//    }];
}

- (void) signIn:(UIButton*)sender {
    NSLog(@"Signing in...");
}

- (void) backButtonTouched:(UIButton*)sender {
    [self disableFocusFromAllTextFields];
    NSLog(@"Going Back...");
    [self flipHiddenStatus:NO];
}

-(void) removeAllFromStackView {
    for(int i = 0; i < [self.LoginSignUpForm.arrangedSubviews count]; i++) {
        UIView * view = self.LoginSignUpForm.arrangedSubviews[i];
        view.hidden = YES;
    }
}

//Dismisses keyboard on tap anywhere outside the keyboard.
- (void)addGestureToDismissKeyboardOnTap {
    UITapGestureRecognizer *tapOutsideOfKeyboard = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(disableFocusFromAllTextFields)];
    [self.view addGestureRecognizer:tapOutsideOfKeyboard];
}

//Removes the focus off of all of the text fields.
- (void) disableFocusFromAllTextFields {
    for(NSUInteger i = 0; i < [self.LoginSignUpForm.arrangedSubviews count]; i++) {
        if([self.LoginSignUpForm.arrangedSubviews[i] isKindOfClass:[UITextField class]]) {
            UITextField * thisTextField = (UITextField *) self.LoginSignUpForm.arrangedSubviews[i];
            [thisTextField resignFirstResponder];
        }
    }
}

//TODO - Make hitting the 'return' key move to the next text field.
//TODO - Make hitting the 'done' key (on password field) to submit the form.
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {

        [theTextField resignFirstResponder];
    
//    if (theTextField == self.textPassword) {
//        [theTextField resignFirstResponder];
//    } else if (theTextField == self.textUsername) {
//        [self.textPassword becomeFirstResponder];
//    }
    return YES;
}


//- (void) editingChanged:(FormTextField*)sender {
//    if([sender tag] == 20) {
//        FormTextField* firstPasswordField = (FormTextField*) [self.view viewWithTag:10];
//        
//        if([firstPasswordField.text isEqualToString:sender.text]) {
//            sender.layer.borderColor = ([[[FormTextField alloc] init] validColor]).CGColor;
//            sender.rightView = [[FormTextField alloc] init].imageViewForInvalidStatus;
//        }
//    }
//    else if([sender tag] == 10 && ((FormTextField*) [self.view viewWithTag:20]).text.length > 1) {
//        if(![sender.text isEqualToString:((FormTextField*)[self.view viewWithTag:20]).text]) {
//            sender.rightView = [[FormTextField alloc] init].imageViewForInvalidStatus;
//        }
//    }
//    //            self.layer.borderColor = self.validColor.CGColor;
////    self.rightView = self.imageViewForValidStatus;
//
////    - (void)setValidationStatus:(FormTextFieldStatus)status;
//
//}


- (BOOL)textField:(FormTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    FormTextField *passwordField = LoginSignUpForm.arrangedSubviews[4];
    FormTextField *verifyPasswordField = LoginSignUpForm.arrangedSubviews[5];

    //FormTextField *passwordField = (FormTextField*) [self.view viewWithTag:10];
    //FormTextField *verifyPasswordField = (FormTextField*) [self.view viewWithTag:20];

    if(textField.tag == 10 || textField.tag == 20) {
        if(searchStr.length < 6) {
            textField.validationStatus = FormValidatingTextFieldStatusIndeterminate;
            textField.layer.borderColor = ([[[FormTextField alloc] init] indeterminateColor]).CGColor;
            textField.rightView = textField.imageViewForIndeterminateStatus;
        }
    }
    
    if(textField.tag == 10 && searchStr.length > 5) {
        if(verifyPasswordField.validationStatus == FormValidatingTextFieldStatusValid && !([verifyPasswordField.text isEqualToString:searchStr])) {
            textField.validationStatus = FormValidatingTextFieldStatusInvalid;
            textField.layer.borderColor = ([[[FormTextField alloc] init] invalidColor]).CGColor;
            textField.rightView = textField.imageViewForInvalidStatus;
            
            verifyPasswordField.validationStatus = FormValidatingTextFieldStatusInvalid;
            verifyPasswordField.layer.borderColor = ([[[FormTextField alloc] init] invalidColor]).CGColor;
            verifyPasswordField.rightView = verifyPasswordField.imageViewForInvalidStatus;
        }
        else if ([verifyPasswordField.text isEqualToString:searchStr]) {
            verifyPasswordField.validationStatus = FormValidatingTextFieldStatusValid;
            verifyPasswordField.layer.borderColor = ([[[FormTextField alloc] init] validColor]).CGColor;
            verifyPasswordField.rightView = textField.imageViewForValidStatus;
            
            textField.validationStatus = FormValidatingTextFieldStatusValid;
            textField.layer.borderColor = ([[[FormTextField alloc] init] validColor]).CGColor;
            textField.rightView = textField.imageViewForValidStatus;

        }
        else {
            textField.validationStatus = FormValidatingTextFieldStatusValid;
            textField.layer.borderColor = ([[[FormTextField alloc] init] validColor]).CGColor;
            textField.rightView = textField.imageViewForValidStatus;
        }
    }
    
    
    if(textField.tag == 20) {
        if([searchStr isEqualToString:passwordField.text]) {
            textField.validationStatus = FormValidatingTextFieldStatusValid;
            textField.layer.borderColor = ([[[FormTextField alloc] init] validColor]).CGColor;
            textField.rightView = textField.imageViewForValidStatus;
        }
        else {
            textField.validationStatus = FormValidatingTextFieldStatusInvalid;
            textField.layer.borderColor = ([[[FormTextField alloc] init] invalidColor]).CGColor;
            textField.rightView = textField.imageViewForInvalidStatus;
        }
    }
    
    
    
//    if(theTextField.tag == 20) {
//        FormTextField* firstPasswordField = (FormTextField*) [self.view viewWithTag:10];
//        
//        
//        if([firstPasswordField.text isEqualToString:searchStr]) {
//            theTextField.validationStatus = FormValidatingTextFieldStatusValid;
//            theTextField.layer.borderColor = ([[[FormTextField alloc] init] validColor]).CGColor;
//            theTextField.rightView = theTextField.imageViewForValidStatus;
//            
//        }
//        else {
//            theTextField.validationStatus = FormValidatingTextFieldStatusInvalid;
//            theTextField.layer.borderColor = ([[[FormTextField alloc] init] invalidColor]).CGColor;
//            theTextField.rightView = theTextField.imageViewForInvalidStatus;
//        }
//    }
//    else if(theTextField.tag == 10 && ((FormTextField*) [self.view viewWithTag:10]).validationStatus == FormValidatingTextFieldStatusValid) {
//        FormTextField* verifyPasswordField = (FormTextField*) [self.view viewWithTag:20];
//        if([verifyPasswordField.text isEqualToString:searchStr]) {
//            theTextField.validationStatus = FormValidatingTextFieldStatusValid;
//            theTextField.layer.borderColor = ([[[FormTextField alloc] init] validColor]).CGColor;
//            theTextField.rightView = theTextField.imageViewForValidStatus;
//            
//        }
//        else {
//            theTextField.validationStatus = FormValidatingTextFieldStatusInvalid;
//            theTextField.layer.borderColor = ([[[FormTextField alloc] init] invalidColor]).CGColor;
//            theTextField.rightView = theTextField.imageViewForInvalidStatus;
//        }
//    }

    
    return YES;
}

- (void) flipHiddenStatus:(BOOL)status {
    SignUpButton.hidden = status;
    LoginButton.hidden = status;
    LoginSignUpForm.hidden = !status;
}

- (void) displayError:(NSError*) error {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Error"
                                message:[error localizedDescription]
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okayButton = [UIAlertAction
                                 actionWithTitle:@"Okay 🙃"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
    [alert addAction:okayButton];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
