//
//  Modal.h
//  UbiqProject
//
//  Created by Joey on 10/2/15.
//
////


#import <UIKit/UIKit.h>
#import "Query.h"
#import "MapViewController.h"



@interface SettingsModalViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
- (IBAction)logoutOfAccount:(id)sender;

@end
