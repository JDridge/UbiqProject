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
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *ratingImage;
@property (copy, nonatomic) NSString *reviewCount;
@property (copy, nonatomic) NSString *url;

-(id)initWithTitleCoordinateSubtitle:(NSString*)newTitle Location:(CLLocationCoordinate2D)location subtitle:(NSString*)newSubtitle;

- (id)initWithTitleCoordinateSubtitleName:(NSString *)newTitle coordinate:(CLLocationCoordinate2D)location subtitle:(NSString *)newSubtitle name:(NSString *)newName;

-(id)initWithTitleCoordinateTitle:(NSString *)newTitle
                         Subtitle:(NSString *)newSubtitle
                             Name:(NSString *)newName
                          Address:(NSString *)newAddress
                            Phone:(NSString *)newPhone
                      RatingImage:(NSString *)newRatingImage 
                      ReviewCount:(NSString *)newReviewCount 
                              URL:(NSString *)newURL;

-(MKAnnotationView*) annotationView;

@end
