
#import "iBeaconService.h"
#import "BeaconRegion.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface iBeaconService ()

@property (nonatomic, strong) CLLocationManager     *locationManager;
@property (nonatomic, strong) CBPeripheralManager   *peripheralManager;
@property (nonatomic, strong) NSDictionary          *peripheralData;
@property (nonatomic, assign) BOOL                  isMonitoringRegion;
@property (nonatomic, assign) BOOL                  didShowEntranceNotifier;
@property (nonatomic, assign) BOOL                  didShowExitNotifier;

@property (nonatomic) double proximity;

@end

static iBeaconService *_sharedInstance = nil;

@implementation iBeaconService

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[iBeaconService alloc] init];
    });
    return _sharedInstance;
}

- (double)getProximityToClosestRegion
{
    return self.proximity;
}

#pragma mark - Peripheral Manager Helpers

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self initializeRegionMonitoring];
    }
    
    return self;
}

/*
 - (void)initializePeripheralManager {
 // initialize new peripheral manager and begin monitoring for updates
 if (!self.peripheralManager) {
 self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
 
 // fire initial notification
 [self fireUpdateNotificationForStatus:@"Initializing CBPeripheralManager and waiting for state updates..."];
 }
 }
 
 - (void)startAdvertisingBeacon {
 // initialize new CLBeaconRegion and start advertising target region
 if (![self.peripheralManager isAdvertising]) {
 self.peripheralData = [[BeaconRegion targetRegion] peripheralDataWithMeasuredPower:nil];
 [self.peripheralManager startAdvertising:self.peripheralData];
 }
 }
 
 - (void)stopAdvertisingBeacon {
 // stop advertising CLBeaconRegion
 if ([self.peripheralManager isAdvertising]) {
 [self.peripheralManager stopAdvertising];
 self.peripheralManager = nil;
 self.peripheralData = nil;
 }
 }
 
 #pragma mark - CBPeripheralManagerDelegate
 - (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
 
 NSString *status;
 switch (peripheral.state) {
 case CBPeripheralManagerStateUnsupported:
 // ensure you are using a device supporting Bluetooth 4.0 or above.
 // not supported on iOS 7 simulator
 status = @"Device platform does not support BTLE peripheral role.";
 break;
 
 case CBPeripheralManagerStateUnauthorized:
 // verify app is permitted to use Bluetooth
 status = @"App is not authorized to use BTLE peripheral role.";
 break;
 
 case CBPeripheralManagerStatePoweredOff:
 // Bluetooth service is powered off
 status = @"Bluetooth service is currently powered off on this device.";
 break;
 
 case CBPeripheralManagerStatePoweredOn:
 // start advertising CLBeaconRegion
 status = @"Now advertising iBeacon signal.  Monitor other device for location updates.";
 [self startAdvertisingBeacon];
 break;
 
 case CBPeripheralManagerStateResetting:
 // Temporarily lost connection
 status = @"Bluetooth connection was lost.  Waiting for update...";
 break;
 
 case CBPeripheralManagerStateUnknown:
 default:
 // Connection status unknown
 status = @"Current peripheral state unknown.  Waiting for update...";
 break;
 }
 
 // fire notification with status update
 [self fireUpdateNotificationForStatus:status];
 }
 */

- (void)fireUpdateNotificationForStatus:(NSString*)status {
    // fire notification to update displayed status
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kRegionUpdateNotification"
                                                        object:Nil
                                                      userInfo:@{@"status" : status}];
}

#pragma mark - CLLocationManager Helpers

- (void)initializeRegionMonitoring {
    
    // initialize new location manager
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    // begin region monitoring
    [self.locationManager startMonitoringForRegion:[BeaconRegion targetRegion]];
    
    // fire notification with initial status
    NSLog(@"Initializing CLLocationManager and initiating region monitoring...");
}

- (void)stopMonitoringForRegion
{
    // stop monitoring for region
    [self.locationManager stopMonitoringForRegion:[BeaconRegion targetRegion]];
    
    self.locationManager = nil;
    
    // reset notifiers
    self.didShowEntranceNotifier = NO;
    self.didShowExitNotifier = NO;
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    // fire notification with failure status
    NSLog(@"Location manager failed with error: %@",error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    
    // handle notifyEntryStateOnDisplay
    // notify user they have entered the region, if you haven't already
    //    if (manager == self.locationManager &&
    //        [region.identifier isEqualToString:kUniqueRegionIdentifier] &&
    //        state == CLRegionStateInside &&
    //        !self.didShowEntranceNotifier) {
    
    // start beacon ranging
    [self startBeaconRanging];
    //}
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    // handle notifyOnEntry
    // notify user they have entered the region, if you haven't already
    //    if (manager == self.locationManager &&
    //        [region.identifier isEqualToString:kUniqueRegionIdentifier] &&
    //        !self.didShowEntranceNotifier) {
    
    // start beacon ranging
    [self startBeaconRanging];
    //}
}

- (void)startBeaconRanging
{
    
    // set entrance notifier flag
    self.didShowEntranceNotifier = YES;
    
    // start beacon ranging
    [self.locationManager startRangingBeaconsInRegion:[BeaconRegion targetRegion]];
    
    // fire notification with region update
    NSLog(@"Welcome!  You have entered the target region.");
}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
    // optionally notify user they have left the region
    if (!self.didShowExitNotifier) {
        
        self.didShowExitNotifier = YES;
        
        // fire notification with region update
        //[self fireUpdateNotificationForStatus:@"kExitRegion"];
    }
    
    // reset entrance notifier
    self.didShowEntranceNotifier = NO;
    
    // stop beacon ranging
    [manager stopRangingBeaconsInRegion:[BeaconRegion targetRegion]];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    // identify closest beacon in range
    if ([beacons count] > 0) {
        CLBeacon *closestBeacon = beacons[0];
        
        //[self fireUpdateNotificationForStatus:[NSString stringWithFormat:@"Beacon found, proximity = %f", closestBeacon.accuracy]];
        
        self.proximity = closestBeacon.accuracy;
        
        CGFloat radius = .07;
        
        if (closestBeacon.accuracy < radius && closestBeacon.accuracy >= 0)
            [self fireUpdateNotificationForStatus:@"kEnterRegion"];
        else if (closestBeacon.accuracy > radius)
            [self fireUpdateNotificationForStatus:@"kExitRegion"];
        else
            [self fireUpdateNotificationForStatus:@"kNone"];
    } else
        [self fireUpdateNotificationForStatus:@"kNone"];
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    
    // fire notification of range failure
    NSLog(@"Beacon ranging failed with error: %@", error);
    
    // assume notifications failed, reset indicators
    self.didShowEntranceNotifier = NO;
    self.didShowExitNotifier = NO;
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    
    // fire notification of region monitoring
    NSLog(@"Now monitoring for region: %@",((CLBeaconRegion*)region).identifier);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    
    // fire notification with status update
    NSLog(@"Region monitoring failed with error: %@", error);
    
    // assume notifications failed, reset indicators
    self.didShowEntranceNotifier = NO;
    self.didShowExitNotifier = NO;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    // current location usage is required to use this demo app
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        [[[UIAlertView alloc] initWithTitle:@"Current Location Required"
                                    message:@"Please re-enable Core Location to run this Demo.  The app will now exit."
                                   delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // exit application if user declined Current Location permissions
    exit(0);
}

@end
