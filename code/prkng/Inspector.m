#import "Inspector.h"
#import "InspectorParkingLotCell.h"

@interface Inspector ()

@property (strong, nonatomic) NSMutableArray *parkingLots;

@end

@implementation Inspector

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)populateDummyData
{
    NSDictionary *p1 = @{@"spotStatus" : @"Spot J7 is Vacant",
                         @"elapsedTime" : @"1 min ago",
                         @"hoursStayed" : @"2 hours stayed"};
    
    [self.parkingLots addObject:p1];
    
    NSDictionary *p2 = @{@"spotStatus" : @"Spot J7 is Vacant",
                         @"elapsedTime" : @"1 min ago",
                         @"hoursStayed" : @"2 hours stayed"};
    
    [self.parkingLots addObject:p2];
    
    NSDictionary *p3 = @{@"spotStatus" : @"Spot J7 is Vacant",
                         @"elapsedTime" : @"1 min ago",
                         @"hoursStayed" : @"2 hours stayed"};
    
    [self.parkingLots addObject:p3];
    
    NSDictionary *p4 = @{@"spotStatus" : @"Spot J7 is Vacant",
                         @"elapsedTime" : @"1 min ago",
                         @"hoursStayed" : @"2 hours stayed"};
    
    [self.parkingLots addObject:p4];
    
    NSDictionary *p5 = @{@"spotStatus" : @"Spot J7 is Vacant",
                         @"elapsedTime" : @"1 min ago",
                         @"hoursStayed" : @"2 hours stayed"};

    [self.parkingLots addObject:p5];

    NSDictionary *p6 = @{@"spotStatus" : @"Spot J7 is Vacant",
                         @"elapsedTime" : @"1 min ago",
                         @"hoursStayed" : @"2 hours stayed"};

    [self.parkingLots addObject:p6];
    
    [self setupTableView];
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

#pragma mark UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.parkingLots.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InspectorParkingLotCell *cell = (InspectorParkingLotCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *parkingDict = self.parkingLots[indexPath.row];
    
    NSString *spotStatus = [parkingDict objectForKey:@"spotStatus"];
    NSString *elapsedTime = [parkingDict objectForKey:@"elapsedTime"];
    NSString *hoursStayed = [parkingDict objectForKey:@"hoursStayed"];
    
//    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosureInd.png"]];
    
    cell.lotIDLabel.font = [UIFont fontWithName:@"GothamRounded-Light" size:17];
    cell.lotIDLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];

    cell.spotStatusLabel.font = [UIFont fontWithName:@"GothamRounded-Light" size:17];
    cell.spotStatusLabel.text = spotStatus;
    
    cell.elapsedTimeLabel.font = [UIFont fontWithName:@"GothamRounded-Light" size:19];
    cell.elapsedTimeLabel.text = [NSString stringWithFormat:@"%@ %@", elapsedTime, [elapsedTime intValue] == 1 ? @"min" : @"mins"];
    
    cell.hoursStayedLabel.font = [UIFont fontWithName:@"GothamRounded-Light" size:14];
    cell.hoursStayedLabel.text = [NSString stringWithFormat:@"%@ %@ stayed", hoursStayed, [hoursStayed intValue] == 1 ? @"hour" : @"hours"];
    
    return cell;
}

#pragma mark Lazy Loading

- (NSMutableArray *)parkingLots
{
    if (!_parkingLots)
        _parkingLots = [[NSMutableArray alloc] init];
    
    return _parkingLots;
}

@end
