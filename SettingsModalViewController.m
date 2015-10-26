//
//  Modal.m
//  UbiqProject
//
//  Created by Joey on 10/2/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import "SettingsModalViewController.h"

@interface SettingsModalViewController ()

@end

@implementation SettingsModalViewController

@synthesize printQuery;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


- (IBAction)BackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
