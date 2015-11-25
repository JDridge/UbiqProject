//
//  LoginFormViewController.h
//  UbiqProject
//
//  Created by Robert Vo on 11/24/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@import MediaPlayer;

@interface LoginFormViewController : UIViewController

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
- (IBAction)LoginButtonTouched:(id)sender;
- (IBAction)SignUpButtonTouched:(id)sender;
@property IBOutlet UIButton *LoginButton;
@property (weak, nonatomic) IBOutlet UIButton *SignUpButton;
@property (weak, nonatomic) IBOutlet UIStackView *LoginSignUpForm;

@end
