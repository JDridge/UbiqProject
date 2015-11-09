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
- (IBAction)BackButton:(id)sender;

@property Query *printQuery;
@end
