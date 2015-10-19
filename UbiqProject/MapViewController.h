//
//  MapViewController.h
//  UbiqProject
//
//  Created by Robert Vo on 10/18/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Query.h"

@interface MapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *MapView;
@property Query *queryToShow;

@end
