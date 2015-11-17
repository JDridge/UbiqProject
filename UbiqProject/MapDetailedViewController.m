//
//  MapDetailedViewController.m
//  UbiqProject
//
//  Created by Joey on 11/17/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import "MapDetailedViewController.h"

@interface MapDetailedViewController ()

@end

@implementation MapDetailedViewController

- (void)viewDidLoad {
    NSString *pathToApiKeys = [[NSBundle mainBundle] pathForResource: @"APIKeys" ofType: @"plist"];
    if([[NSFileManager defaultManager] fileExistsAtPath:pathToApiKeys]) {
        NSLog(@"APIKeys.plist is found.");
        NSDictionary *allKeys = [NSDictionary dictionaryWithContentsOfFile:pathToApiKeys];
        NSString *yelpApiKey = [allKeys objectForKey:@"Yelp API Key"];
    }
    else {
        NSLog(@"APIKeys.plist missing!");
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
