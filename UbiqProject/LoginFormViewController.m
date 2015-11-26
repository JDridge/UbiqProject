//
//  LoginFormViewController.m
//  UbiqProject
//
//  Created by Robert Vo on 11/24/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import "LoginFormViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UITextField+Utilities.h"

@implementation LoginFormViewController {
    AVPlayer *player;
}

@synthesize LoginButton, SignUpButton, LoginSignUpForm, WelcomeLabel;

- (void)viewDidLoad {
    LoginSignUpForm.hidden = YES;
    [super viewDidLoad];
    [self playVideo];
    [self setupLabelsAndButtonsOnStart];
    [self addGestureToDismissKeyboardOnTap];
}

-(void)playVideo {
    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"video" withExtension:@"mov"];
    player = [AVPlayer playerWithURL:videoURL];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.view.frame;
    [self.view.layer addSublayer:playerLayer];
    [player play];
    
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[player currentItem]];

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

        UIButton *signInButton = [self getGenericButton:@"Sign In!" selectorActionName:@"signIn:"];
        [LoginSignUpForm addArrangedSubview:signInButton];
        
        UIButton *backButton = [self getGenericButton:@"Back!" selectorActionName:@"backButtonTouched:"];
        [LoginSignUpForm addArrangedSubview:backButton];
    }];
    
    [self.view addSubview:LoginSignUpForm];
    
}



- (IBAction)SignUpButtonTouched:(id)sender {
    [self removeAllFromStackView];
    [self flipHiddenStatus:YES];
    NSLog(@"Signup...");
    
    UITextField *firstNameTextField = [UITextField getNameTextField:@"First Name"];
    [firstNameTextField becomeFirstResponder];
    [LoginSignUpForm addArrangedSubview:firstNameTextField];

    UITextField *lastNameTextField = [UITextField getNameTextField:@"Last Name"];
    [LoginSignUpForm addArrangedSubview:lastNameTextField];

    UITextField *emailAddressTextField = [UITextField createEmailAddressTextField];
    [LoginSignUpForm addArrangedSubview:emailAddressTextField];

    UITextField *passwordTextField = [UITextField createPasswordTextField:@"Password"];
    [LoginSignUpForm addArrangedSubview:passwordTextField];

    UITextField *verifyPasswordTextField = [UITextField createPasswordTextField:@"Verify Password"];
    [LoginSignUpForm addArrangedSubview:verifyPasswordTextField];

    UIButton *registerButton = [self getGenericButton:@"Register!" selectorActionName:@"registerForm:"];
    [LoginSignUpForm addArrangedSubview:registerButton];

    UIButton *backButton = [self getGenericButton:@"Back!" selectorActionName:@"backButtonTouched:"];
    [LoginSignUpForm addArrangedSubview:backButton];
    
    [self.view addSubview:LoginSignUpForm];

}



- (void) registerForm:(UIButton*)sender {
    NSLog(@"Registering...");

    PFObject *gameScore = [PFObject objectWithClassName:@"GameTable"];
    gameScore[@"score"] = @1337;
    gameScore[@"playerName"] = @123;
    gameScore[@"ragisuvhfds"] = @"maybe";
    [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"success");
            // The object has been saved.
        } else {
            [self displayError:error];
        }
    }];
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
    if ([theTextField.placeholder isEqualToString:@"Password"]) {

        [theTextField resignFirstResponder];
    }
    
//    if (theTextField == self.textPassword) {
//        [theTextField resignFirstResponder];
//    } else if (theTextField == self.textUsername) {
//        [self.textPassword becomeFirstResponder];
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

- (UIButton *)getGenericButton:(NSString *)title selectorActionName:(NSString *)selectorMethod {
    UIButton *newButton = [[UIButton alloc] initWithFrame:[self getDefaultRectangleSize]];
    [newButton setTitle:title forState:UIControlStateNormal];
    newButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    newButton.layer.borderWidth = 2.0f;
    newButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [newButton setTintColor:[UIColor whiteColor]];
    
    SEL method = NSSelectorFromString(selectorMethod);
    [newButton addTarget:self action:method forControlEvents:UIControlEventTouchUpInside];
    
    return newButton;
}

+ (CGRect)getDefaultRectangleSize {
    return CGRectMake(10, 200, 500, 150);
}


@end
