//
//  CSMBeaconRegion.m
//  iBeacons_Demo
//
//  Created by Christopher Mann on 9/16/13.
//  Copyright (c) 2013 Christopher Mann. All rights reserved.
//

#import "BeaconRegion.h"


static BeaconRegion *_sharedInstance = nil;

@implementation BeaconRegion

+ (instancetype)targetRegion {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[BeaconRegion alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    
    // initialize a new CLBeaconRegion with application-specific UUID and human-readable identifier
    self = [super initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"10D39AE7-020E-4467-9CB2-DD36366F899D"] identifier:@"com.park.region"];
    
    if (self)
    {
        self.notifyEntryStateOnDisplay = NO;     // only notify user if app is active
        self.notifyOnEntry = YES;                 // don't notify user on region entrance
        self.notifyOnExit = YES;                 // notify user on region exit
    }
    return self;
}

@end
