//
//  BallotTableViewCell.h
//  UbiqProject
//
//  Created by Robert Vo on 12/9/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BallotTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mapImage;
@property (weak, nonatomic) IBOutlet UILabel *firstPersonName;
@property (weak, nonatomic) IBOutlet UILabel *secondPersonName;
@property (weak, nonatomic) IBOutlet UILabel *firstPersonVote;
@property (weak, nonatomic) IBOutlet UILabel *secondPersonVote;


@end
