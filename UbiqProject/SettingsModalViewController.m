//
//  Modal.m
//  UbiqProject
//
//  Created by Joey on 10/2/15.
//
//

#import "SettingsModalViewController.h"

@interface SettingsModalViewController ()

@end

@implementation SettingsModalViewController

@synthesize printQuery, firstLocationLatitude, firstLocationLongitude, secondLocationLatitude, secondLocationLongitude, labelLatitude1, labelLongitude1, labelLatitude2, labelLongitude2;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    labelLatitude1.text = [NSString stringWithFormat:@"%f", firstLocationLatitude];
    labelLongitude1.text = [NSString stringWithFormat:@"%f", firstLocationLongitude];
    labelLatitude2.text = [NSString stringWithFormat:@"%f", secondLocationLatitude];
    labelLongitude2.text = [NSString stringWithFormat:@"%f", secondLocationLongitude];
    
    
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
