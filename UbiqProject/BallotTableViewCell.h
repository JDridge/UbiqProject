//
//  BallotTableViewCell.h
//  UbiqProject
//
//  Created by Robert Vo on 12/9/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BallotTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ballotLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ballotImage;

@property NSString *ballotID;
@property NSString *ballotEmail;
@property NSString *ballotPersonName;
@property NSString *ballotAddressOfPlace;

@end
