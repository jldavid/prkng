#import "Map.h"
#import "FSNConnection.h"
#import <CoreLocation/CoreLocation.h>
#import "ParkingLotCell.h"
#import "MKMapView+ZoomLevel.h"
#import "iBeaconService.h"

@interface Map ()

@property (strong, nonatomic) NSDictionary *parkingData;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (strong, nonatomic) NSMutableArray *nearbyParkingLots;

@property (nonatomic, strong) UIAlertView *alertView;

@property (nonatomic) BOOL userNotified;

@end

#define PARKING_RADIUS 1.0
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation Map

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.locationManager.delegate = self;
    //self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //[self.locationManager startUpdatingLocation];
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x095ABB)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title.png"]];
    
    UIImage *disclosure = [UIImage imageNamed:@"disclosure.png"];
    UIBarButtonItem *disclosureItem = [[UIBarButtonItem alloc]
                                       initWithImage:disclosure style:0 target:self action:@selector(gback)];
    NSArray *actionButtonItems = @[disclosureItem];
    self.navigationItem.leftBarButtonItems = actionButtonItems;
    
    UIImage *pinpoint = [UIImage imageNamed:@"pinpoint.png"];
    UIBarButtonItem *pinpointItem = [[UIBarButtonItem alloc]
                                     initWithImage:pinpoint style:0 target:self action:@selector(gforth)];
    NSArray *actionButtonItemsTwo = @[pinpointItem];
    self.navigationItem.rightBarButtonItems = actionButtonItemsTwo;
    
    [iBeaconService sharedManager];
    
    self.userNotified = NO;
    
    [iBeaconService sharedManager].ableToShowEnteranceNotifier = YES;
    /*
     
     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", @"http://www1.toronto.ca", @"/City_Of_Toronto/Information_&_Technology/Open_Data/Data_Sets/Assets/Files/greenPParking.json"]];
     
     FSNConnection *connection = [FSNConnection withUrl:url
     method:FSNRequestMethodPOST
     headers:nil
     parameters:nil
     parseBlock:^id(FSNConnection *c, NSError **error) {
     return [c.responseData dictionaryFromJSONWithError:error];
     }
     completionBlock:^(FSNConnection *c) {
     
     self.parkingData = (NSDictionary *)c.parseResult;
     
     //NSLog(@"complete: %@\n  error: %@\n  parseResult: %@\n", c, c.error, c.parseResult);
     
     //NSLog(@"complete: %@\n  error: %@\n  parseResult: %@\n", c, c.error, c.parseResult);
     
     //NSError *error = nil;
     //NSDictionary *json = [NSJSONSerialization JSONObjectWithData:c.responseData options:kNilOptions error:&error];
     //NSString *token = [json objectForKey:@"token"];
     //NSLog(@"Token: %@", token);
     
     }
     progressBlock:^(FSNConnection *c) {
     //NSLog(@"progress: %@: %.2f", c, c.uploadProgress);
     }];
     //[connection start];
     
     [self setupMapView];
     
     */
    
    // populate dummy data
    
    [self populateDummyData];
    
    //    for (NSString* family in [UIFont familyNames]) {
    //        NSLog(@"%@", family);
    //        for (NSString* name in [UIFont fontNamesForFamilyName: family]) {
    //            NSLog(@" %@", name); }
    //    }
}

-(void) gback {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) gforth {
    [self performSegueWithIdentifier:@"meter" sender:self];
}

- (void)populateDummyData
{
    NSDictionary *p1 = @{@"address" : @"20 Charles Street",
                         @"kilometersAway" : @"0",
                         @"minutesAway" : @"0",
                         @"remainingSpots" : @"40",
                         @"rate" : @"$10.00 /hr"};
    
    [self.nearbyParkingLots addObject:p1];
    
    NSDictionary *p2 = @{@"address" : @"13 Isabella Street",
                         @"kilometersAway" : @"1.3",
                         @"minutesAway" : @"6",
                         @"remainingSpots" : @"12",
                         @"rate" : @"$4.50 /hr"};
    
    [self.nearbyParkingLots addObject:p2];
    
    NSDictionary *p3 = @{@"address" : @"15 Wellesley Street East",
                         @"kilometersAway" : @"1.6",
                         @"minutesAway" : @"9",
                         @"remainingSpots" : @"3",
                         @"rate" : @"$8.00 /hr"};
    
    [self.nearbyParkingLots addObject:p3];
    
    NSDictionary *p4 = @{@"address" : @"37 Yorkville Avenue",
                         @"kilometersAway" : @"1.9",
                         @"minutesAway" : @"14",
                         @"remainingSpots" : @"62",
                         @"rate" : @"$15.00 /hr"};
    
    [self.nearbyParkingLots addObject:p4];
    
    //    NSDictionary *p5 = @{@"address" : @"37 Queen Street East",
    //                         @"kilometersAway" : @"1.1",
    //                         @"minutesAway" : @"5",
    //                         @"remainingSpots" : @"157",
    //                         @"rate" : @"$4.50 /hr"};
    //
    //    [self.nearbyParkingLots addObject:p5];
    //
    //    NSDictionary *p6 = @{@"address" : @"45 Bay Street",
    //                         @"kilometersAway" : @"1.7",
    //                         @"minutesAway" : @"9",
    //                         @"remainingSpots" : @"19",
    //                         @"rate" : @"$4.50 /hr"};
    //
    //    [self.nearbyParkingLots addObject:p6];
    
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    // add observer for location notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRegionUpdate:)
                                                 name:@"kRegionUpdateNotification"
                                               object:nil];
    
    
    
	self.alertView = [[UIAlertView alloc] initWithTitle:@"You have parked!"
                                                message:@"You have parked in spot B52.\nYour PayPal account will be charged $2/hr."
                                               delegate:self
                                      cancelButtonTitle:@"Decline"
                                      otherButtonTitles:@"Accept", nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kRegionUpdateNotification" object:nil];
    
    [self performSegueWithIdentifier:@"meter" sender:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    self.userNotified = NO;
}

- (void)handleRegionUpdate:(NSNotification *)notification {
    
    NSString *regionStatus = (NSString *)notification.userInfo[@"status"];
    
    if ([regionStatus isEqualToString:@"kEnterRegion"])
    {
        NSLog(@"kEnterRegion");
        
        if ([iBeaconService sharedManager].ableToShowEnteranceNotifier == YES)
        {
            [self.alertView show];
            [iBeaconService sharedManager].ableToShowEnteranceNotifier = NO;
        }
    }
    else if ([regionStatus isEqualToString:@"kExitRegion"])
    {
        NSLog(@"kExitRegion");
        
        //        [iBeaconService sharedManager].ableToShowEnteranceNotifier = YES;
    }
    
    NSLog(@"%@", notification.userInfo[@"status"]);
}

- (void)parseJSON
{
    NSArray *carparks = [self.parkingData objectForKey:@"carparks"];
    
    //    NSLog(@"carparks = %@", carparks);
    
    //    NSLog(@"currlat = %f", self.currentLocation.coordinate.latitude);
    //    NSLog(@"currlng = %f", self.currentLocation.coordinate.longitude);
    
    for (NSDictionary *carparkDict in carparks)
    {
        //        NSLog(@"carparkDict = %@", carparkDict);
        
        CLLocationCoordinate2D curCoord;
        curCoord.latitude = [[carparkDict valueForKey:@"lat"] doubleValue];
        curCoord.longitude = [[carparkDict valueForKey:@"lng"] doubleValue];
        
        CLLocation *parkingLocation = [[CLLocation alloc] initWithLatitude:curCoord.latitude longitude:curCoord.longitude];
        
        CLLocationDistance kilometersAway = [self getKilometersAwayLocation1:self.currentLocation location2:parkingLocation];
        
        if (kilometersAway < PARKING_RADIUS)
        {
            //            NSLog(@"greenP = %fKM", kilometersAway);
            //[self.nearbyParkingLots addObject:carparkDict];
        }
    }
    
    //    NSLog(@"total nearbyParkingLots = %d", self.nearbyParkingLots.count);
    //    NSLog(@"nearbyParkingLots = %@", self.nearbyParkingLots);
    
    //[self setupTableView];
}

- (CLLocationDistance)getKilometersAwayLocation1:(CLLocation *)location1 location2:(CLLocation *)location2
{
    return [location1 distanceFromLocation:location2] / 1000;
}

- (void)setupTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView reloadData];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:34.0f/255.0f
                                                     green:34.0f/255.0f
                                                      blue:34.0f/255.0f alpha:1];
}

- (void)setupMapView
{
    //    CLLocationCoordinate2D coordinate;
    //    coordinate.latitude = 43.6667;
    //    coordinate.longitude = -79.4167;
    //
    //    self.mapView.showsUserLocation = YES;
    //    //self.mapView.delegate = self;
    //
    //    [self.mapView setCenterCoordinate:coordinate zoomLevel:13 animated:NO];
    //
    //    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:NO];
    //    self.mapView.mapType = MKMapTypeStandard;
    //    self.mapView.scrollEnabled = NO;
    //    self.mapView.rotateEnabled = NO;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)click:(id)sender
{
    [self performSegueWithIdentifier:@"meter" sender:self];
}

#pragma mark UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nearbyParkingLots.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParkingLotCell *cell = (ParkingLotCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *parkingDict = self.nearbyParkingLots[indexPath.row];
    
    NSString *address = [parkingDict objectForKey:@"address"];
    NSString *kmAway = [parkingDict objectForKey:@"kilometersAway"];
    NSString *minutesAway = [parkingDict objectForKey:@"minutesAway"];
    NSString *remainingSpots = [parkingDict objectForKey:@"remainingSpots"];
    NSString *rate = [parkingDict objectForKey:@"rate"];
    
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosureInd.png"]];
    
    cell.lotIDLabel.font = [UIFont fontWithName:@"GothamRounded-Light" size:17];
    cell.lotIDLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    //cell.imageView.image = [UIImage imageNamed:@""];
    
    cell.addressLabel.font = [UIFont fontWithName:@"GothamRounded-Light" size:19];
    cell.addressLabel.text = address;
    
    //    CLLocationCoordinate2D curCoord;
    //    curCoord.latitude = [[parkingDict valueForKey:@"lat"] doubleValue];
    //    curCoord.longitude = [[parkingDict valueForKey:@"lng"] doubleValue];
    //
    //    CLLocation *parkingLocation = [[CLLocation alloc] initWithLatitude:curCoord.latitude longitude:curCoord.longitude];
    //    CLLocationDistance kilometersAway = [self getKilometersAwayLocation1:self.currentLocation location2:parkingLocation];
    //    NSString *kmAwayString = [NSString stringWithFormat:@"%f", kilometersAway];
    
    cell.lotDetailLabel.font = [UIFont fontWithName:@"GothamRounded-Light" size:14];
    cell.lotDetailLabel.text = [NSString stringWithFormat:@"%@ km  %@ mins  %@ %@", kmAway, minutesAway, remainingSpots, [remainingSpots intValue] == 1 ? @"spot" : @"spots"];
    
    cell.rateLabel.font = [UIFont fontWithName:@"GothamRounded-Light" size:25];
    cell.rateLabel.text = rate;
    
    return cell;
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (newLocation)
    {
        self.currentLocation = newLocation;
        
        //[self parseJSON];
    }
}


#pragma mark Lazy Loading
- (NSDictionary *)parkingData
{
    if (!_parkingData)
        _parkingData = [[NSDictionary alloc] init];
    
    return _parkingData;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    return _locationManager;
}

- (NSMutableArray *)nearbyParkingLots
{
    if (!_nearbyParkingLots)
        _nearbyParkingLots = [[NSMutableArray alloc] init];
    
    return _nearbyParkingLots;
}

@end
