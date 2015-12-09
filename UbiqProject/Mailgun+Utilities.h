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
+ (void) sendEmailToUserRequestingBallot:(NSString*)user from:(NSString*)you email:(NSString*)email;
+ (void) sendEmailToUserAboutStatusOfBallotWithComments:(NSString*)user email:(NSString*)email location:(NSString*)location status:(NSString*)status comments:(NSString*)comments;
+ (void) sendEmailToUserAboutStatusOfBallotWithComments:(NSString*)user email:(NSString*)email location:(NSString*)location status:(NSString*)status comments:(NSString*)comments image:(UIImageView*)image;

@end
