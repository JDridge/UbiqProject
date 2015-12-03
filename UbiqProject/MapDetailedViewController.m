//
//  MapDetailedViewController.m
//  UbiqProject
//
//  Created by Joey on 11/17/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import "MapDetailedViewController.h"
#import "YPAPISample.h"

@interface MapDetailedViewController ()

@end

@implementation MapDetailedViewController

@synthesize nameLabel, phoneLabel, addressLabel, reviewCountLabel, urlImage, ratingImage, category, pinLocation, yelpURL;

- (void)viewDidLoad {
    
    @autoreleasepool {
        NSString *defaultTerm = category;
        NSString *defaultCoordinates = [NSString stringWithFormat:@"%f,%f", pinLocation.coordinate.latitude, pinLocation.coordinate.longitude];
    
        //Get the term and location from the command line if there were any, otherwise assign default values.
        NSString *term = [[NSUserDefaults standardUserDefaults] valueForKey:@"term"] ?: defaultTerm;
        NSString *ll = [[NSUserDefaults standardUserDefaults] valueForKey:@"ll"] ?: defaultCoordinates;
        
        
        YPAPISample *APISample = [[YPAPISample alloc] init];
        
        dispatch_group_t requestGroup = dispatch_group_create();
        
        dispatch_group_enter(requestGroup);
        [APISample queryTopBusinessInfoForTerm:term ll:ll completionHandler:^(NSDictionary *topBusinessJSON, NSError *error) {
            
            if (error) {
                NSLog(@"An error happened during the request: %@", error);
            } else if (topBusinessJSON) {
                //TODO - assign yelpURL
                //TODO - set labels for result
                
                NSLog(@"Top business info: \n %@", topBusinessJSON);
                
                //po [topBusinessJSON objectForKey:@"url"]

                
                
            } else {
                NSLog(@"No business was found");
            }
            
            dispatch_group_leave(requestGroup);
        }];
        dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER); // This avoids the program exiting before all our asynchronous callbacks have been made.
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#warning DO THIS
- (IBAction)backButtonTouched:(id)sender {
    //dismiss modal (google it)
}

- (IBAction)openInYelpButtonTouched:(id)sender {
    [self maybeDoSomethingWithYelp];
}

- (BOOL)isYelpInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"yelp5.3:"]];
}

- (void)maybeDoSomethingWithYelp {
    if ([self isYelpInstalled]) {
        NSString *yelpStringFormat = @"yelp5.3://";
        yelpStringFormat = [NSString stringWithFormat:@"%@%@", yelpStringFormat, [yelpURL substringFromIndex:18]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:yelpStringFormat]];
        
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:yelpURL]];
    }
}


@end
