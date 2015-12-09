//
//  UserCustomAnnotation.m
//  UbiqProject
//
//  Created by Lorenzo Bermillo on 11/25/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import "UserCustomAnnotation.h"

@implementation UserCustomAnnotation

@synthesize title, coordinate, subtitle,name;

-(id)initWithTitleCoordinateSubtitle:(NSString*)newTitle Location:(CLLocationCoordinate2D)location subtitle:(NSString*)newSubtitle {
    self = [super init];
    if(self) {
        title = newTitle;
        coordinate = location;
        subtitle = newSubtitle;
    }
    return self;
}

- (id)initWithTitleCoordinateSubtitleName:(NSString *)newTitle coordinate:(CLLocationCoordinate2D)location subtitle:(NSString *)newSubtitle name:(NSString *)newName {
    self = [super init];
    if (self) {
        title = newTitle;
        coordinate = location;
        subtitle = newSubtitle;
        name = newName;
    }
    
    return self;
}

- (MKAnnotationView*) annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"UserCustomAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    //Custom pin image
    if ([title isEqual: @"Joseph"])
        annotationView.image = [UIImage imageNamed:@"smallJOSEPH"];
    else if ([title isEqual: @"Chris"])
        annotationView.image = [UIImage imageNamed:@"smallCHRIS"];
    else
        annotationView.image = [UIImage imageNamed:@"smallROBERT"];
    
    //Setting up the right callout button
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    //The right callout button is the halfwayarrow for now.
//    UIImage *buttonImage = [UIImage imageNamed:@"halfwayarrow"];
//    [rightButton setImage:buttonImage forState:UIControlStateNormal];
//    annotationView.rightCalloutAccessoryView = rightButton;
    
    return annotationView;
}


@end
