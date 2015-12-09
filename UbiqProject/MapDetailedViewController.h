//
//  MapDetailedViewController.h
//  UbiqProject
//
//  Created by Joey on 11/17/15.
//  Copyright © 2015 Joey. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CustomAnnotation.h"
#import "UserCustomAnnotation.h"
#import "SearchCustomAnnotation.h"

@interface MapDetailedViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property CustomAnnotation *myCustomAnnotation;
@property CustomAnnotation *friendsCustomAnnotation;

@property NSString *category;
@property MKAnnotationView *pinLocation;

@property (weak, nonatomic) IBOutlet UILabel *myName;
@property (weak, nonatomic) IBOutlet UILabel *myPhone;
@property (weak, nonatomic) IBOutlet UILabel *myAddress;
@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UILabel *friendPhone;
@property (weak, nonatomic) IBOutlet UILabel *friendAddress;
@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) IBOutlet UILabel *placePhone;
@property (weak, nonatomic) IBOutlet UILabel *placeAddress;
- (IBAction)yesTouched:(id)sender;
- (IBAction)nahManTouched:(id)sender;

@end