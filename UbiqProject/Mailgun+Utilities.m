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
    NSString *emailTo = [NSString stringWithFormat:@"%@ %@", user, @"<ubicomp6uh@gmail.com>"];
    
    Mailgun *mailgun = [Mailgun clientWithDomain:[NSString getMailgunClientWithDomain]
                                          apiKey:[NSString getMailgunApiKey]];
    
    [mailgun sendMessageTo:emailTo
                      from:@"Excited User <converge@converge.converge>"
                   subject:@"hello there"
                      body:@"hi! Open the app here! converge://OPENME"
                   success:^(NSString *messageId) {
                       NSLog(@"success!");}
                   failure:^(NSError *error) {
                       NSLog(@"error %@", [error userInfo]);}];
}

+ (void) sendEmailToUserRequestingBallot:(NSString*)user from:(NSString*)you email:(NSString*)email {
    NSString *emailTo = [NSString stringWithFormat:@"%@ <ubicomp6uh@gmail.com>", user, email];
    NSString *subject = [NSString stringWithFormat:@"%@ %@", you, @" has requested for you to converge with them."];
    NSString *body = [NSString stringWithFormat:@"Hello %@,\n%@ has requested for you to converge with them. Please open the converge app to see more! \n🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥\n Open the app here! converge://OPENME \n🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥\n", user, you];
    Mailgun *mailgun = [Mailgun clientWithDomain:[NSString getMailgunClientWithDomain]
                                          apiKey:[NSString getMailgunApiKey]];
    [mailgun sendMessageTo:emailTo
                      from:@"Converge App <converge@converge.converge>"
                   subject:subject
                      body:body
                   success:^(NSString *messageId) {
                       NSLog(@"success!");}
                   failure:^(NSError *error) {
                       NSLog(@"error %@", [error userInfo]);}];
}

+ (void) sendEmailAboutStatusOfBallot:(NSString*)user location:(NSString*)location status:(NSString*)status {
    NSString *emailTo = [NSString stringWithFormat:@"%@ %@", user, @"<ubicomp6uh@gmail.com>"];
    NSString *subject = @"Status of your converge ballot";
    NSString *body = [NSString stringWithFormat:@"Hello %@,\nThe status of the ballot for location %@ is: %@. Please open the converge app to see more information. Open the app here! converge://OPENME", user, location, status];
    Mailgun *mailgun = [Mailgun clientWithDomain:[NSString getMailgunClientWithDomain]
                                          apiKey:[NSString getMailgunApiKey]];
    [mailgun sendMessageTo:emailTo
                      from:@"Converge App <converge@converge.converge>"
                   subject:subject
                      body:body
                   success:^(NSString *messageId) {
                       NSLog(@"success!");}
                   failure:^(NSError *error) {
                       NSLog(@"error %@", [error userInfo]);}];

}


@end
