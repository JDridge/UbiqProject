//
//  NSString+APIKeys.m
//  UbiqProject
//
//  Created by Robert Vo on 12/3/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import "NSString+APIKeys.h"

@implementation NSString (APIKeys)

+ (NSDictionary*) getAllKeys {
    NSString *pathToApiKeys = [[NSBundle mainBundle] pathForResource: @"APIKeys" ofType: @"plist"];
    if([[NSFileManager defaultManager] fileExistsAtPath:pathToApiKeys]) {
        NSLog(@"APIKeys.plist is found.");
        return [NSDictionary dictionaryWithContentsOfFile:pathToApiKeys];
    }
    else {
        NSLog(@"APIKeys.plist missing!");
        return nil;
    }
}

+ (NSString*) getYelpConsumerKey {
    return [self getAllKeys][@"YelpkConsumerKey"];
}

+ (NSString*) getYelpConsumerSecretKey {
    return [self getAllKeys][@"YelpkConsumerSecret"];
}

+ (NSString*) getYelpToken {
    return [self getAllKeys][@"YelpkToken"];
}

+ (NSString*) getYelpTokenSecret {
    return [self getAllKeys][@"YelpkTokenSecret"];
}

+ (NSString*) getParseClientKey {
    return [self getAllKeys][@"ParseClientKey"];
}

+ (NSString*) getParseApplicationID {
    return [self getAllKeys][@"ParseApplicationID"];
}

+ (NSString*) getMailgunClientWithDomain {
    return [self getAllKeys][@"MailgunClientWithDomain"];
}

+ (NSString*) getMailgunApiKey {
    return [self getAllKeys][@"MailgunApiKey"];
}

@end
