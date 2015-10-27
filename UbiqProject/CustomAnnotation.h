//
//  CustomAnnotation.h
//  UbiqProject
//
//  Created by Joey on 10/26/15.
//  Copyright © 2015 Joey. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSString *name;

-(id)initWithTitle:(NSString*)newTitle Location:(CLLocationCoordinate2D)location subtitle:(NSString*)subtitle;
-(MKAnnotationView*) annotationView;

@end
