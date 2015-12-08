//
//  Ballot.h
//  UbiqProject
//
//  Created by Mario Laiseca-Ruiz on 12/7/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ballot : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *use;
@property (strong, nonatomic) NSNumber *amount;
@end
