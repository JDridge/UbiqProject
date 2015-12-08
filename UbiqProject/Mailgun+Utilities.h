//
//  Mailgun+Utilities.h
//  UbiqProject
//
//  Created by Robert Vo on 12/7/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import "MailGun.h"

@interface Mailgun (Utilities)

+ (void) sendEmailToUser:(NSString*)user;
+ (void) sendEmailToUserRequestingBallot:(NSString*)user from:(NSString*)you;
+ (void) sendEmailAboutStatusOfBallot:(NSString*)user location:(NSString*)location status:(NSString*)status;

@end
