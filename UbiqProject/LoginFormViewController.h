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
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@property (weak, nonatomic) IBOutlet UIButton *SignUpButton;
- (IBAction)LoginButtonTouched:(id)sender;
- (IBAction)SignUpButtonTouched:(id)sender;

@end
