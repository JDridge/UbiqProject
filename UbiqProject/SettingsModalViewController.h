//
//  Modal.h
//  UbiqProject
//
//  Created by Joey on 10/2/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Query.h"
#import "MapViewController.h"


@interface SettingsModalViewController : UIViewController
- (IBAction)BackButton:(id)sender;

@property Query *printQuery;

@property (weak, nonatomic) IBOutlet UILabel *labelLatitude1;
@property (weak, nonatomic) IBOutlet UILabel *labelLongitude1;
@property (weak, nonatomic) IBOutlet UILabel *labelLatitude2;
@property (weak, nonatomic) IBOutlet UILabel *labelLongitude2;

@property double firstLocationLatitude, firstLocationLongitude, secondLocationLatitude, secondLocationLongitude;

@end
