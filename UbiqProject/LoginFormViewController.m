//
//  LoginFormViewController.m
//  UbiqProject
//
//  Created by Robert Vo on 11/24/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import "LoginFormViewController.h"
#import <AVFoundation/AVFoundation.h>

@implementation LoginFormViewController {
    AVPlayer *player;
}

@synthesize LoginButton, SignUpButton, LoginSignUpForm, WelcomeLabel;

- (void)viewDidLoad {
    LoginSignUpForm.hidden = YES;
    [super viewDidLoad];
    [self playVideo];
    [self createLabels];
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

- (void) createLabels {
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
        
        UITextField *emailAddressTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, 500, 150)];
        emailAddressTextField.borderStyle = UITextBorderStyleRoundedRect;
        emailAddressTextField.font = [UIFont systemFontOfSize:15];
        emailAddressTextField.placeholder = @"Email Address";
        [emailAddressTextField setKeyboardType:UIKeyboardTypeEmailAddress];
        [LoginSignUpForm addArrangedSubview:emailAddressTextField];
        emailAddressTextField.delegate = self;

        [emailAddressTextField becomeFirstResponder];
        
        UITextField *textFieldToAdd = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, 500, 150)];
        textFieldToAdd.borderStyle = UITextBorderStyleRoundedRect;
        textFieldToAdd.font = [UIFont systemFontOfSize:15];
        textFieldToAdd.placeholder = @"Password";
        textFieldToAdd.autocorrectionType = UITextAutocorrectionTypeNo;
        textFieldToAdd.keyboardType = UIKeyboardTypeDefault;
        textFieldToAdd.returnKeyType = UIReturnKeyDone;
        textFieldToAdd.clearButtonMode = UITextFieldViewModeWhileEditing;
        textFieldToAdd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textFieldToAdd.delegate = self;

        [LoginSignUpForm addArrangedSubview:textFieldToAdd];

        UIButton *signInButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, 500, 150)];
        [signInButton setTitle:@"Sign In!" forState:UIControlStateNormal];
        signInButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        signInButton.layer.borderWidth = 2.0f;
        signInButton.titleLabel.font = [UIFont systemFontOfSize:24];
        [signInButton setTintColor:[UIColor whiteColor]];
        [signInButton addTarget:self action:@selector(signIn:) forControlEvents:UIControlEventTouchUpInside];
        [LoginSignUpForm addArrangedSubview:signInButton];
        
        UIButton *backButton = [self getBackButton];
        [LoginSignUpForm addArrangedSubview:backButton];

    }];
    
    
    [self.view addSubview:LoginSignUpForm];
    
}

- (IBAction)SignUpButtonTouched:(id)sender {
    [self removeAllFromStackView];
    [self flipHiddenStatus:YES];
    NSLog(@"Signup...");
    
        UITextField *textFieldToAdd = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, 500, 150)];
        textFieldToAdd.borderStyle = UITextBorderStyleRoundedRect;
        textFieldToAdd.font = [UIFont systemFontOfSize:15];
        textFieldToAdd.placeholder = @"First Name";
        textFieldToAdd.delegate = self;
        [LoginSignUpForm addArrangedSubview:textFieldToAdd];
        [textFieldToAdd becomeFirstResponder];
        
        textFieldToAdd = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, 500, 150)];
        textFieldToAdd.borderStyle = UITextBorderStyleRoundedRect;
        textFieldToAdd.font = [UIFont systemFontOfSize:15];
        textFieldToAdd.placeholder = @"Last Name";
        textFieldToAdd.autocorrectionType = UITextAutocorrectionTypeNo;
        textFieldToAdd.keyboardType = UIKeyboardTypeDefault;
        textFieldToAdd.returnKeyType = UIReturnKeyDone;
        textFieldToAdd.clearButtonMode = UITextFieldViewModeWhileEditing;
        textFieldToAdd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textFieldToAdd.delegate = self;

        [LoginSignUpForm addArrangedSubview:textFieldToAdd];
        
        textFieldToAdd = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, 500, 150)];
        textFieldToAdd.borderStyle = UITextBorderStyleRoundedRect;
        textFieldToAdd.font = [UIFont systemFontOfSize:15];
        textFieldToAdd.placeholder = @"Email Address";
        textFieldToAdd.autocorrectionType = UITextAutocorrectionTypeNo;
        textFieldToAdd.keyboardType = UIKeyboardTypeDefault;
        textFieldToAdd.returnKeyType = UIReturnKeyDone;
        textFieldToAdd.clearButtonMode = UITextFieldViewModeWhileEditing;
        textFieldToAdd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textFieldToAdd.delegate = self;

        [LoginSignUpForm addArrangedSubview:textFieldToAdd];
        
        
        textFieldToAdd = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, 500, 150)];
        textFieldToAdd.borderStyle = UITextBorderStyleRoundedRect;
        textFieldToAdd.font = [UIFont systemFontOfSize:15];
        textFieldToAdd.placeholder = @"Password";
        textFieldToAdd.autocorrectionType = UITextAutocorrectionTypeNo;
        textFieldToAdd.keyboardType = UIKeyboardTypeDefault;
        textFieldToAdd.returnKeyType = UIReturnKeyDone;
        textFieldToAdd.clearButtonMode = UITextFieldViewModeWhileEditing;
        textFieldToAdd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textFieldToAdd.delegate = self;
        
        [LoginSignUpForm addArrangedSubview:textFieldToAdd];

        
        UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, 500, 150)];
        [registerButton setTitle:@"Register!" forState:UIControlStateNormal];
        registerButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        registerButton.layer.borderWidth = 2.0f;
        registerButton.titleLabel.font = [UIFont systemFontOfSize:24];
        [registerButton setTintColor:[UIColor whiteColor]];
        [registerButton addTarget:self action:@selector(registerForm:) forControlEvents:UIControlEventTouchUpInside];

        [LoginSignUpForm addArrangedSubview:registerButton];
        
        UIButton *backButton = [self getBackButton];
        [LoginSignUpForm addArrangedSubview:backButton];

    
    
    
    [self.view addSubview:LoginSignUpForm];

}

- (UIButton*) getBackButton {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, 500, 150)];
    [backButton setTitle:@"Back!" forState:UIControlStateNormal];
    backButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    backButton.layer.borderWidth = 2.0f;
    backButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [backButton setTintColor:[UIColor whiteColor]];
    [backButton addTarget:self action:@selector(backButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    return backButton;
}

- (void) registerForm:(UIButton*)sender {
    NSLog(@"Registering...");
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
    for(int i = 0; i < [self.LoginSignUpForm.arrangedSubviews count]; i++) {
        if([self.LoginSignUpForm.arrangedSubviews[i] isKindOfClass:[UITextField class]]) {
            UITextField * thisTextField = self.LoginSignUpForm.arrangedSubviews[i];
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


@end
