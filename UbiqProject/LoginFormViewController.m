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
#import <Parse/Parse.h>
#import "HomeViewController.h" 

@implementation LoginFormViewController

@synthesize LoginButton, SignUpButton, LoginSignUpForm, WelcomeLabel, backgroundVideo;

-(void) transitionToHomeViewController {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ /* put code to execute here */
    
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        HomeViewController *detailViewController = (HomeViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"homeVC"];
        [self presentViewController:detailViewController animated:YES completion:nil];
        [[[self parentViewController] parentViewController] dismissViewControllerAnimated:YES completion:nil];

    });
}

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
    playerLayer.videoGravity = AVLayerVideoGravityResize;
    
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
    [self flipHiddenStatus:YES];
    NSLog(@"Signup...");
    
    UITextField *firstNameTextField = [UITextField createNameTextField:@"First Name"];
    [firstNameTextField becomeFirstResponder];
    firstNameTextField.delegate = self;
    
    [LoginSignUpForm addArrangedSubview:firstNameTextField];

    UITextField *lastNameTextField = [UITextField createNameTextField:@"Last Name"];
    lastNameTextField.delegate = self;
    [LoginSignUpForm addArrangedSubview:lastNameTextField];

    UITextField *emailAddressTextField = [UITextField createEmailAddressTextField];
    emailAddressTextField.delegate = self;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"hi");
    //HomeViewController *vc = [segue destinationViewController];
    
}


- (void) registerForm:(UIButton*)sender {
    NSLog(@"Registering...");
    
    if([self checkIfAllFieldsAreValid]) {
        NSLog(@"all valid");
        PFUser *user = [PFUser user];
        user.username = ((FormTextField*) LoginSignUpForm.arrangedSubviews[2]).text;
        user.password = ((FormTextField*) LoginSignUpForm.arrangedSubviews[3]).text;
        user.email = ((FormTextField*) LoginSignUpForm.arrangedSubviews[2]).text;
        user[@"firstName"] = ((FormTextField*) LoginSignUpForm.arrangedSubviews[0]).text;
        user[@"lastName"] = ((FormTextField*) LoginSignUpForm.arrangedSubviews[1]).text;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                //[self displaySuccessfulLogin:user];
                [self transitionToHomeViewController];
            } else {
                [self displayError:error];
            }
        }];
    }
    else {
        [self findAllInvalidFormsThenDisplayErrorNotification];
    }
}

- (void) displaySuccessfulLogin:(PFUser*)userToGreet {
    NSString *greetingMessage = [NSString stringWithFormat:@"Welcome %@ %@!", userToGreet[@"firstName"], userToGreet[@"lastName"]];
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Greetings"
                                message:greetingMessage
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okayButton = [UIAlertAction
                                 actionWithTitle:@"Okay"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
    [alert addAction:okayButton];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (void) signIn:(UIButton*)sender {
    NSLog(@"Signing in...");
    
    if([self checkIfAllFieldsAreValid]) {
        [PFUser logInWithUsernameInBackground:((FormTextField*) LoginSignUpForm.arrangedSubviews[0]).text
                                     password:((FormTextField*) LoginSignUpForm.arrangedSubviews[1]).text
                                        block:^(PFUser *user, NSError *error) {
                                            if (!error) {
                                                NSLog(@"no error");
                                                //[self displaySuccessfulLogin:user];
                                                [self transitionToHomeViewController];
                                            } else {
                                                [self displayError:error];
                                            }
                                        }];
    }
    else {
        [self findAllInvalidFormsThenDisplayErrorNotification];
    }
    
}

- (void) findAllInvalidFormsThenDisplayErrorNotification {
    NSMutableArray *invalidViews = [NSMutableArray array];
    for(int i = 0; i < [LoginSignUpForm.arrangedSubviews count]; i++) {
        if([LoginSignUpForm.arrangedSubviews[i] isKindOfClass:[FormTextField class]] &&
           ((FormTextField*)LoginSignUpForm.arrangedSubviews[i]).validationStatus != FormValidatingTextFieldStatusValid) {
            [invalidViews addObject:((FormTextField*)LoginSignUpForm.arrangedSubviews[i])];
        }
    }
    [self displayInvalidFormsFor:invalidViews];
}

- (void) displayInvalidFormsFor:(NSArray*)invalidViews {
    NSString *stringToDisplay = @"The following fields are invalid:";
    
    for(int i = 0; i < [invalidViews count]; i++) {
        if([((FormTextField*)invalidViews[i]).placeholder isEqualToString:@"First Name"]) {
            stringToDisplay = [NSString stringWithFormat:@"%@ \n%@", stringToDisplay, @"First Name can only contain characters."];
        }
        else if([((FormTextField*)invalidViews[i]).placeholder isEqualToString:@"Last Name"]) {
            stringToDisplay = [NSString stringWithFormat:@"%@ \n%@", stringToDisplay, @"Last Name can only contain characters."];
        }
        else if([((FormTextField*)invalidViews[i]).placeholder isEqualToString:@"Email Address"]) {
            stringToDisplay = [NSString stringWithFormat:@"%@ \n%@", stringToDisplay, @"Invalid email format."];
        }
        else if([((FormTextField*)invalidViews[i]).placeholder isEqualToString:@"Password"]) {
            stringToDisplay = [NSString stringWithFormat:@"%@ \n%@", stringToDisplay, @"Password must contain at least 6 characters."];
        }
        else if([((FormTextField*)invalidViews[i]).placeholder isEqualToString:@"Verify Password"]) {
            stringToDisplay = [NSString stringWithFormat:@"%@ \n%@", stringToDisplay, @"Verify Password must contain at least 6 characters."];
        }
    }

    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Error"
                                message:stringToDisplay
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okayButton = [UIAlertAction
                                 actionWithTitle:@"Okay 🙃"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
    [alert addAction:okayButton];
    
    [(FormTextField*)invalidViews[0] becomeFirstResponder];

    [self presentViewController:alert animated:YES completion:nil];

}

- (BOOL) checkIfAllFieldsAreValid {
    for(int i = 0; i < [LoginSignUpForm.arrangedSubviews count]; i++) {
        if([self.LoginSignUpForm.arrangedSubviews[i] isKindOfClass:[FormTextField class]]) {
            FormTextField *currentTextField = self.LoginSignUpForm.arrangedSubviews[i];
            if(currentTextField.validationStatus != FormValidatingTextFieldStatusValid) {
                return NO;
            }
        }
    }
    return YES;
}

- (void) backButtonTouched:(UIButton*)sender {
    [self removeAllFromStackView];
    [self disableFocusFromAllTextFields];
    NSLog(@"Going Back...");
    [self flipHiddenStatus:NO];

}

-(void) removeAllFromStackView {
    NSUInteger i = [self.LoginSignUpForm.arrangedSubviews count];
    while(i > 0) {
        i--;
        NSLog(@"%i", i);
        //[LoginSignUpForm removeArrangedSubview:LoginSignUpForm.arrangedSubviews[i]];
        [LoginSignUpForm.arrangedSubviews[i] removeFromSuperview];
        
    }
//    for(int i = 0; i < [self.LoginSignUpForm.arrangedSubviews count]; i++) {
//        UIView * view = self.LoginSignUpForm.arrangedSubviews[i];
//        view.hidden = YES;
//    }
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
    
//    FormTextField* testingergnisdf = self.LoginSignUpForm.arrangedSubviews[1];
//    if([testingergnisdf canBecomeFirstResponder]) {
//        [self.LoginSignUpForm.arrangedSubviews[1] becomeFirstResponder];
//        NSLog(@"hi");
//    }
//    else {
//        NSLog(@"no no");
//    }
//    canBecomeFirstResponder
//    [NSThread sleepForTimeInterval:2.0f];
//
//    [testingergnisdf becomeFirstResponder];
    
//    if([theTextField.placeholder isEqualToString:@"First Name"]) {
//        [theTextField resignFirstResponder];
//        [(FormTextField*)self.LoginSignUpForm.arrangedSubviews[1] becomeFirstResponder];
//    }
    
    
        //[theTextField resignFirstResponder];
    
//    if (theTextField == self.textPassword) {
//        [theTextField resignFirstResponder];
//    } else if (theTextField == self.textUsername) {
//        [self.textPassword becomeFirstResponder];
//    }
    return YES;
}




- (BOOL)textField:(FormTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if(textField.tag == 20 && ((FormTextField*) [self.view viewWithTag:10]).validationStatus == FormValidatingTextFieldStatusValid) {
        if([searchStr isEqualToString:((FormTextField*)[self.view viewWithTag:10]).text]) {
            textField.validationStatus = FormValidatingTextFieldStatusValid;
        }
        else {
            textField.validationStatus = FormValidatingTextFieldStatusInvalid;
        }
    }
    else if(textField.tag == 10 && ((FormTextField*) [self.view viewWithTag:20]).validationStatus == FormValidatingTextFieldStatusInvalid && [searchStr isEqualToString:((FormTextField*)[self.view viewWithTag:20]).text]) {
        [(FormTextField*) [self.view viewWithTag:20] setValidationStatus:FormValidatingTextFieldStatusValid];
    }
    return YES;
}


-(void) textFieldDidBeginEditing:(FormTextField *)textField {
    if(textField.tag == 10 || textField.tag == 20) {
        [textField setText:@""];
        textField.validationStatus = FormValidatingTextFieldStatusIndeterminate;
    }
    
    if(textField.tag == 10 && ((FormTextField*) [self.view viewWithTag:20]).validationStatus == FormValidatingTextFieldStatusValid) {
        [(FormTextField*) [self.view viewWithTag:20] setValidationStatus:FormValidatingTextFieldStatusInvalid];
    }
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
