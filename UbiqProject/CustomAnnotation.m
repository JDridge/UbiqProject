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

@synthesize title, coordinate, subtitle, name, address, phone, ratingImage, reviewCount, url;

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

-(id)initWithTitleCoordinateTitle:(NSString *)newTitle
                         Subtitle:(NSString *)newSubtitle
                             Name:(NSString *)newName 
                          Address:(NSString *)newAddress 
                            Phone:(NSString *)newPhone 
                      RatingImage:(NSString *)newRatingImage 
                      ReviewCount:(NSString *)newReviewCount 
                              URL:(NSString *)newURL {
    
    self = [super init];
    if(self) {
        title = newTitle;
        subtitle = newSubtitle;
        address = newAddress;
        phone = newPhone;
        ratingImage = newRatingImage;
        reviewCount = newReviewCount;
        url = newURL;
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
