#import "Map.h"
#import "FSNConnection.h"
#import <CoreLocation/CoreLocation.h>
#import "ParkingLotCell.h"

@interface Map ()

@property (strong, nonatomic) NSDictionary *parkingData;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (strong, nonatomic) NSMutableArray *nearbyParkingLots;

@end

#define PARKING_RADIUS 1.0

@implementation Map

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
    
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
    [connection start];
    
    [self setupMapView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
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
        
        CLLocationCoordinate2D coord;
        coord.latitude = [[carparkDict valueForKey:@"lat"] doubleValue];
        coord.longitude = [[carparkDict valueForKey:@"lng"] doubleValue];
        
        CLLocation *parkingLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        
        CLLocationDistance kilometers = [self.currentLocation distanceFromLocation:parkingLocation] / 1000;
        
        if (kilometers < PARKING_RADIUS)
        {
            //            NSLog(@"greenP = %fKM", kilometers);
            [self.nearbyParkingLots addObject:carparkDict];
        }
    }
    
    //    NSLog(@"total nearbyParkingLots = %d", self.nearbyParkingLots.count);
    //    NSLog(@"nearbyParkingLots = %@", self.nearbyParkingLots);
    
    [self setupTableView];
}

- (void)setupTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView reloadData];
}

- (void)setupMapView
{
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    self.mapView.mapType = MKMapTypeStandard;
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
    
    cell.lotIDLabel = [parkingDict objectForKey:@"id"];
    cell.imageView.image = [UIImage imageNamed:@""];
    cell.addressLabel = [parkingDict objectForKey:@"address"];
    cell.lotDetailLabel = [parkingDict objectForKey:@"id"];
    cell.rateLabel = [parkingDict objectForKey:@"id"];
    
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
        
        [self parseJSON];
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
