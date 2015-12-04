//
//  NSString+APIKeys.h
//  UbiqProject
//
//  Created by Robert Vo on 12/3/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (APIKeys)

+ (NSDictionary*) getAllKeys;
+ (NSString*) getYelpConsumerKey;
+ (NSString*) getYelpConsumerSecretKey;
+ (NSString*) getYelpToken;
+ (NSString*) getYelpTokenSecret;
+ (NSString*) getParseClientKey;
+ (NSString*) getParseApplicationID;

@end
