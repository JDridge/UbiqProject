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

- (instancetype)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate subtitle:(NSString *)subtitle name:(NSString *)name email:(NSString *)email {
    self = [super init];
    if (self) {
        self.title = title;
        self.coordinate = coordinate;
        self.subtitle = subtitle;
        self.name = name;
        self.email = email;
    }

    return self;
}

+ (instancetype)annotationWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate subtitle:(NSString *)subtitle name:(NSString *)name email:(NSString *)email {
    return [[self alloc] initWithTitle:title coordinate:coordinate subtitle:subtitle name:name email:email];
}

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
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"CustomAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    //Custom pin image
    annotationView.image = [UIImage imageNamed:@"halfwayarrow"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    
    //Setting up the right callout button
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    //The right callout button is the halfwayarrow for now.
//    UIImage *buttonImage = [UIImage imageNamed:@"halfwayarrow"];
//    [rightButton setImage:buttonImage forState:UIControlStateNormal];
//    annotationView.rightCalloutAccessoryView = rightButton;

    return annotationView;
}

@end
