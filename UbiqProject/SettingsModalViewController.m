//
//  Modal.m
//  UbiqProject
//
//  Created by Joey on 10/2/15.
//
// 

#import "SettingsModalViewController.h"
#import "SWRevealViewController.h"
#import "LoginFormViewController.h"

@interface SettingsModalViewController ()

@end

@implementation SettingsModalViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
     
     */
    
    self.title = @"Settings";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"≡"
                                   style:UIBarButtonItemStyleDone
                                   target:self.revealViewController
                                   action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    NSString *name = [NSString stringWithFormat:@"%@ %@", [PFUser currentUser][@"firstName"], [PFUser currentUser][@"lastName"]];
    _nameLabel.text = name;
    _addressLabel.text = [PFUser currentUser][@"address"];
    _emailLabel.text = [[PFUser currentUser] username];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

/*
- (IBAction)BackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
 */


- (IBAction)logoutOfAccount:(id)sender {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Warning"
                                message:@"Do you really want to log out of your account?"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *voteYesButton = [UIAlertAction
                                    actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [PFUser logOut];
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        [self transitionToLoginScreen];
                                    }];
    
    UIAlertAction *voteNoButton = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                   }];
    [alert addAction:voteYesButton];
    [alert addAction:voteNoButton];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void) transitionToLoginScreen {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ /* put code to execute here */
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        LoginFormViewController *detailViewController = (LoginFormViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"loginVC"];
        [self presentViewController:detailViewController animated:YES completion:nil];
        
        
    });
}
@end
