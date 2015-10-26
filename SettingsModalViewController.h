//
//  Modal.h
//  UbiqProject
//
//  Created by Joey on 10/2/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Query.h"

@interface SettingsModalViewController : UIViewController
- (IBAction)BackButton:(id)sender;

@property Query *printQuery;

@end
