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

-(id)initWithTitleCoordinateSubtitle:(NSString*)newTitle Location:(CLLocationCoordinate2D)location subtitle:(NSString*)newSubtitle;

- (id)initWithTitleCoordinateSubtitleName:(NSString *)newTitle coordinate:(CLLocationCoordinate2D)location subtitle:(NSString *)newSubtitle name:(NSString *)newName;

-(MKAnnotationView*) annotationView;

@end
