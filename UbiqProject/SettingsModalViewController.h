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
//- (IBAction)BackButton:(id)sender;

@property Query *printQuery;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (weak, nonatomic) IBOutlet UILabel *setUnitType;
@property (weak, nonatomic) IBOutlet UILabel *unitNumber;
@property (weak, nonatomic) IBOutlet UILabel *unitType;
@property (weak, nonatomic) IBOutlet UIStepper *unitStepper;




@end
