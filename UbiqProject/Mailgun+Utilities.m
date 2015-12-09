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
#import <Parse/Parse.h>

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
    NSString *emailTo = [NSString stringWithFormat:@"%@ <%@>", user, email];
    NSString *subject = [NSString stringWithFormat:@"%@ %@", you, @"has requested for you to converge with them."];
    NSString *body = [NSString stringWithFormat:@"Hello %@,\n%@ has requested for you to converge with them. Please open the converge app to see more! \n🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥\n Open the app here! converge://OPENME \n🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥\n\nHave a good day! \n\n-Converge Team", user, you];
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
    NSString *body = [NSString stringWithFormat:@"Hello %@,\nThe status of the ballot for location %@ is: %@. Please open the converge app to see more information. Open the app here! converge://OPENME\nHave a good day! \n\n-Converge Team", user, location, status];
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

+ (void) sendEmailToUserAboutStatusOfBallotWithComments:(NSString*)user email:(NSString*)email location:(NSString*)location status:(NSString*)status comments:(NSString*)comments {
    
    if([status isEqualToString:@"Voted Yes"]) {
        status = @"Accepted";
    }
    else {
        status = @"Declined";
    }
    
    NSString *emailTo = @"ubicomp6uh@gmail.com";
    //NSString *emailTo = [NSString stringWithFormat:@"%@ <%@>", user, email];
    NSString *subject = @"Status of your converge ballot";
    NSString *body;
    if([comments length] == 0) {
        body = [NSString stringWithFormat:@"Hello %@,\nThe status of the ballot for location %@ is: %@. Please open the converge app to see more information. Open the app here! converge://OPENME", [PFUser currentUser], location, status];
    }
    else {
        body = [NSString stringWithFormat:@"Hello %@,\nThe status of the ballot for location %@ is: %@. The other person also included this message: \"%@\".\nOpen the app here! converge://OPENME", user, location, status, comments];
    }
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

+ (void) sendEmailToUserAboutStatusOfBallotWithComments:(NSString*)user email:(NSString*)email location:(NSString*)location status:(NSString*)status comments:(NSString*)comments image:(UIImageView*)image{
    NSString *body;
    if([status isEqualToString:@"Voted Yes"]) {
        status = @"Accepted";
    }
    else {
        status = @"Declined";
    }
    
    NSString *emailTo = [NSString stringWithFormat:@"%@ <%@>", user, email];
    NSString *subject = @"Status of your converge ballot";
    
    MGMessage *message = [[MGMessage alloc] init];
    if([comments length] == 0 && [status isEqualToString:@"Accepted"]) {
        body = [NSString stringWithFormat:@"Hello %@ %@,\nThe status of the ballot for location %@ is: %@. \nA map preview of the place will be provided below! Please open the converge app to see more information. Open the app here! converge://OPENME\n\nHave a good day! \n-Converge Team\n\n", [PFUser currentUser][@"firstName"], [PFUser currentUser][@"lastName"], location, status];
        
        message = [MGMessage messageFrom:@"Converge App <converge@converge.converge>"
                                      to:emailTo
                                 subject:subject
                                    body:body];
        UIImage *catImage = image.image;
        [message addImage:catImage withName:@"imageYO" type:PNGFileType];
    }
    else if([comments length] == 0 && [status isEqualToString:@"Declined"]) {
        body = [NSString stringWithFormat:@"Hello %@ %@,\nThe status of the ballot for location %@ is: %@. \nPlease open the converge app to see more information. Open the app here! converge://OPENME\n\nHave a good day! \n-Converge Team\n\n", [PFUser currentUser][@"firstName"], [PFUser currentUser][@"lastName"], location, status];
        message = [MGMessage messageFrom:@"Converge App <converge@converge.converge>"
                                      to:emailTo
                                 subject:subject
                                    body:body];
    }
    else if([status isEqualToString:@"Accepted"]) {
        body = [NSString stringWithFormat:@"Hello %@ %@,\nThe status of the ballot for location %@ is: %@. \nA map preview of the place will be provided below! \n%@ also included this message to you: \"%@\".\nOpen the app here! converge://OPENME\n\nHave a good day! \n-Converge Team\n\n", [PFUser currentUser][@"firstName"], [PFUser currentUser][@"lastName"], location, status, user, comments];
        message = [MGMessage messageFrom:@"Converge App <converge@converge.converge>"
                                      to:emailTo
                                 subject:subject
                                    body:body];
        UIImage *catImage = image.image;
        [message addImage:catImage withName:@"imageYO" type:PNGFileType];
    }
    else {
        body = [NSString stringWithFormat:@"Hello %@ %@,\nThe status of the ballot for location %@ is: %@. \nPlease open the converge app to see more information. Open the app here! converge://OPENME\n\nHave a good day! \n-Converge Team\n\n", [PFUser currentUser][@"firstName"], [PFUser currentUser][@"lastName"], location, status];
        
        message = [MGMessage messageFrom:@"Converge App <converge@converge.converge>"
                                      to:emailTo
                                 subject:subject
                                    body:body];
    }
    Mailgun *mailgun = [Mailgun clientWithDomain:[NSString getMailgunClientWithDomain]
                                          apiKey:[NSString getMailgunApiKey]];
    
    [mailgun sendMessage:message success:^(NSString *messageId) {
        NSLog(@"Message %@ sent successfully!", messageId);
    } failure:^(NSError *error) {
        NSLog(@"Error sending message. The error was: %@", [error userInfo]);
    }];
    
}


@end
