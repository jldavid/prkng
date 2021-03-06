#import "Inspector.h"
#import "InspectorParkingLotCell.h"

@interface Inspector ()

@property (strong, nonatomic) NSMutableArray *parkingLots;
@end

@implementation Inspector

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x095ABB)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title.png"]];
    
    UIImage *disclosure = [UIImage imageNamed:@"disclosure.png"];
    UIBarButtonItem *disclosureItem = [[UIBarButtonItem alloc]
                                       initWithImage:disclosure style:0 target:self action:@selector(gback)];
    NSArray *actionButtonItems = @[disclosureItem];
    self.navigationItem.leftBarButtonItems = actionButtonItems;
    
    [self populateDummyData];
}

-(void) gback {
    [self.navigationController popViewControllerAnimated:YES];
}                                                                                                                                                                                                                 

- (void)populateDummyData
{
    NSDictionary *p1 = @{@"spotStatus" : @"Spot A7 is Vacant",
                         @"elapsedTime" : @"10 sec ago",
                         @"hoursStayed" : @"30 seconds stayed"};
    
    [self.parkingLots addObject:p1];
    
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
