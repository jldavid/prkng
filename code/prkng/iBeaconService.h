//
//  CSMLocationManager.h
//  iBeacons_Demo
//
//  Created by Christopher Mann on 9/5/13.
//  Copyright (c) 2013 Christopher Mann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface iBeaconService : NSObject <CLLocationManagerDelegate>

@property (nonatomic) BOOL ableToShowEnteranceNotifier;

+ (instancetype)sharedManager;
- (double)getProximityToClosestRegion;

- (void)stopMonitoringForRegion;

@end
