//
//  HistoryTableViewController.h
//  UbiqProject
//
//  Created by chris ly on 12/8/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface HistoryTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

- (void)fetchParseData;

@end
