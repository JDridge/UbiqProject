//
//  CustomAnnotation.m
//  UbiqProject
//
//  Created by Joey on 10/26/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import "CustomAnnotation.h"
#import <MapKit/MapKit.h>

@implementation CustomAnnotation

@synthesize title, coordinate, subtitle,name;

-(id)initWithTitle:(NSString*)newTitle Location:(CLLocationCoordinate2D)location subtitle:(NSString*)thissubtitle {
    self = [super init];
    if(self) {
        title = newTitle;
        coordinate = location;
        subtitle = thissubtitle;
    }
    return self;
}

-(MKAnnotationView*) annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"Custom Annotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    //Custom pin image
    annotationView.image = [UIImage imageNamed:@"map"];
    
    //Setting up the right callout button
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    //The right callout button is the halfwayarrow for now.
    UIImage *buttonImage = [UIImage imageNamed:@"halfwayarrow"];
    [rightButton setImage:buttonImage forState:UIControlStateNormal];
    annotationView.rightCalloutAccessoryView = rightButton;

    return annotationView;
}

@end
