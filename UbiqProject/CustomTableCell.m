//
//  CustomTableCell.m
//  UbiqProject
//
//  Created by Mario Laiseca-Ruiz on 12/8/15.
//  Copyright © 2015 Joey. All rights reserved.
//



#import "CustomTableCell.h"

@implementation CustomTableCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
