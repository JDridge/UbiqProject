//
//  LoginFormViewController.m
//  UbiqProject
//
//  Created by Robert Vo on 11/24/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import "LoginFormViewController.h"

@implementation LoginFormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self createGif];
    [self createVideo];
    
    [self createLabels];
}

- (void) createGif {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"railway" ofType:@"gif"];
    NSData *gif = [NSData dataWithContentsOfFile:filePath];
    
    UIWebView *webViewBG = [[UIWebView alloc] initWithFrame:self.view.frame];
    [webViewBG loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    webViewBG.userInteractionEnabled = NO;
    [self.view addSubview:webViewBG];
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
    
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 100)];
    welcomeLabel.text = @"WELCOME";
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.font = [UIFont systemFontOfSize:50];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:welcomeLabel];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.height, self.view.bounds.size.width/2, 240, 40)];
    loginBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    loginBtn.layer.borderWidth = 2.0;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    [loginBtn setTintColor:[UIColor whiteColor]];
    [loginBtn setTitle:@"Login" forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    
    UIButton *signUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 420, 240, 40)];
    signUpBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    signUpBtn.layer.borderWidth = 2.0f;
    signUpBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    [signUpBtn setTintColor:[UIColor whiteColor]];
    [signUpBtn setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.view addSubview:signUpBtn];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"Memory Warning");
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (IBAction)LoginButtonTouched:(id)sender {
}

- (IBAction)SignUpButtonTouched:(id)sender {
}
@end
