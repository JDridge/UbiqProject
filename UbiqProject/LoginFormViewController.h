//
//  LoginFormViewController.h
//  UbiqProject
//
//  Created by Robert Vo on 11/24/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//#import <Parse/Parse.h>

@interface LoginFormViewController : UIViewController <UITextFieldDelegate>

- (IBAction)LoginButtonTouched:(id)sender;
- (IBAction)SignUpButtonTouched:(id)sender;

@property (weak, nonatomic) AVPlayer *backgroundVideo;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@property (weak, nonatomic) IBOutlet UIButton *SignUpButton;
@property (weak, nonatomic) IBOutlet UIStackView *LoginSignUpForm;
@property (weak, nonatomic) IBOutlet UILabel *WelcomeLabel;

@end
