//
//  Mailgun+Utilities.m
//  UbiqProject
//
//  Created by Robert Vo on 12/7/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import "Mailgun+Utilities.h"
#import "MailGun.h"
#import "NSString+APIKeys.h"

@implementation Mailgun (Utilities)

+ (void) sendEmailToUser:(NSString*)user {
    NSString *emailTo = [NSString stringWithFormat:@"%@ %@", user, @"<zzz@uh.edu>"];
    
    Mailgun *mailgun = [Mailgun clientWithDomain:[NSString getMailgunClientWithDomain]
                                          apiKey:[NSString getMailgunApiKey]];
    
    [mailgun sendMessageTo:emailTo
                      from:@"Excited User <converge@converge.converge>"
                   subject:@"hello there"
                      body:@"hi!"
                   success:^(NSString *messageId) {
                       NSLog(@"success!");}
                   failure:^(NSError *error) {
                       NSLog(@"error %@", [error userInfo]);}];
}



@end
