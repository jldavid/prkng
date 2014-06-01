//
//  NSObject+MKMapView_ZoomLevel.h
//  prkng
//
//  Created by Ryan Laudi on 2014-06-01.
//  Copyright (c) 2014 jldavid. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
