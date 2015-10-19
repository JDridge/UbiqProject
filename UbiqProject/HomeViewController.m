//
//  ViewController.m
//  UbiqProject
//
//  Created by Joey on 10/2/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import "HomeViewController.h"
#import "Query.h"
#import "MapViewController.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize CategorySegmentedControl, FirstLocation, SecondLocation, queryToPass, direction, shakes;

- (void)viewDidLoad {
    NSLog(@"hi");
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillAppear:(BOOL)animated {
    
}

- (IBAction)ConvergeLocations:(id)sender {
    
    Query *setUpQueryToPass = [[Query alloc] init];
    NSMutableArray *locationsToPass = [[NSMutableArray alloc] init];
    
    [locationsToPass addObject:FirstLocation.text];
    [locationsToPass addObject:SecondLocation.text];
    /*
    if([FirstLocation.text isEqual: @""] || [FirstLocation.text isEqualToString:@"Enter location..."]) {
        FirstLocation.text = @"you screwed up";
    }
    if([SecondLocation.text isEqual:@""] || [SecondLocation.text isEqualToString:@"Enter location..."]) {
        SecondLocation.text = @"you also screwed up";
    }
    */
    if(true) { //add validation
        setUpQueryToPass.category = [CategorySegmentedControl titleForSegmentAtIndex:CategorySegmentedControl.selectedSegmentIndex];
        setUpQueryToPass.locations = locationsToPass;
        
        queryToPass = setUpQueryToPass;
        
        [self performSegueWithIdentifier:@"mapVC" sender:nil];
    }
    else {
        direction = 1;
        shakes = 0;
        [self shake:FirstLocation];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MapViewController *viewController = [segue destinationViewController];
    viewController.queryToShow = queryToPass;
}


-(void)shake:(UIView *)shakeThisObject {
    [UIView animateWithDuration:0.03 animations:^{
        shakeThisObject.transform = CGAffineTransformMakeTranslation(5 * direction, 0);
    }
                     completion:^(BOOL finished) {
                         if(shakes >= 10) {
                             shakeThisObject.transform = CGAffineTransformIdentity;
                             return;
                         }
                         shakes++;
                         direction = direction * -1;
                         [self shake:shakeThisObject];
                     }
     ];
}
@end
