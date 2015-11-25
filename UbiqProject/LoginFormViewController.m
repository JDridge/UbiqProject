//
//  LoginFormViewController.m
//  UbiqProject
//
//  Created by Robert Vo on 11/24/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import "LoginFormViewController.h"

@implementation LoginFormViewController

@synthesize LoginButton, SignUpButton, LoginSignUpForm, WelcomeLabel;

- (void)viewDidLoad
{
    LoginSignUpForm.hidden = YES;
    [super viewDidLoad];
    [self createVideo];
    [self createLabels];
}

- (void)createVideo {
    // Load the video from the app bundle.
    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"video" withExtension:@"mov"];
    
    // Create and configure the movie player.
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;
    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    
    self.moviePlayer.view.frame = self.view.frame;
    [self.view insertSubview:self.moviePlayer.view atIndex:0];
    
    [self.moviePlayer play];
    
    // Loop video.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loopVideo) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
}

- (void)loopVideo {
    [self.moviePlayer play];
}


- (void) createLabels {
    UIView *filter = [[UIView alloc] initWithFrame:self.view.frame];
    filter.backgroundColor = [UIColor blackColor];
    filter.alpha = 0.05;
    [self.view addSubview:filter];
    
    //WelcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 100)];
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
    SignUpButton.hidden = YES;
    LoginButton.hidden = YES;
    LoginSignUpForm.hidden = NO;

    NSLog(@"Login...");
    
    [UIView animateWithDuration:0.25 animations:^{
        
        UITextField *textFieldToAdd = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, 500, 150)];
        textFieldToAdd.borderStyle = UITextBorderStyleRoundedRect;
        textFieldToAdd.frame = CGRectMake(10, 200, 500, 150);
        //textFieldToAdd.borderStyle = UITextBorderStyleRoundedRect;
        textFieldToAdd.font = [UIFont systemFontOfSize:15];
        textFieldToAdd.placeholder = @"First Name";
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
        [LoginSignUpForm addArrangedSubview:textFieldToAdd];

        UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, 500, 150)];
        [registerButton setTitle:@"Register!" forState:UIControlStateNormal];
        registerButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        registerButton.layer.borderWidth = 2.0f;
        registerButton.titleLabel.font = [UIFont systemFontOfSize:24];
        [registerButton setTintColor:[UIColor whiteColor]];
        [registerButton addTarget:self action:@selector(registerForm:) forControlEvents:UIControlEventTouchUpInside];
        [LoginSignUpForm addArrangedSubview:registerButton];

    }];
    
    
    [self.view addSubview:LoginSignUpForm];
    
}

- (IBAction)SignUpButtonTouched:(id)sender {
    LoginButton.hidden = YES;
    NSLog(@"Signup...");
}

- (void) registerForm:(UIButton*)sender {
    NSLog(@"Registering...");
}
@end
