//
//  MapDetailedViewController.h
//  UbiqProject
//
//  Created by Joey on 11/17/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapDetailedViewController : UIViewController

- (IBAction)backButtonTouched:(id)sender;
- (IBAction)openInYelpButtonTouched:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *urlImage;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;

@property NSString *yelpURL;

@property NSString *category;
@property id <MKAnnotation> pinLocation;

@end