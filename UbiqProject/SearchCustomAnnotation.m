//
//  SearchCustomAnnotation.m
//  UbiqProject
//
//  Created by Lorenzo Bermillo on 11/25/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import "SearchCustomAnnotation.h"

@implementation SearchCustomAnnotation
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
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"SearchCustomAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    //Custom pin image
    annotationView.image = [UIImage imageNamed:@"halfwayarrow"];
    
    //Setting up the right callout button
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    //The right callout button is the halfwayarrow for now.
    UIImage *buttonImage = [UIImage imageNamed:@"halfwayarrow"];
    [rightButton setImage:buttonImage forState:UIControlStateNormal];
    annotationView.rightCalloutAccessoryView = rightButton;
    
    return annotationView;
}


@end
