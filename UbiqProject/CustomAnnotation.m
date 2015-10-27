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
    
    annotationView.image = [UIImage imageNamed:@"bluepin.ico"];
    
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mapButton setTitle:@"hi" forState:UIControlStateNormal];
    [mapButton setBackgroundImage:[UIImage imageNamed:@"images-ex4/female-sign.png"] forState:UIControlStateNormal];
    
    //annotationView.rightCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"images-ex4/female-sign.png"]];
    
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
}


@end
