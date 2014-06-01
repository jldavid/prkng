#import "Meter.h"
#import "iBeaconService.h"

@interface Meter ()

@property (nonatomic, strong) UIAlertView *alertView;

@property (nonatomic) BOOL userNotified;

@end

@implementation Meter

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
    
    UIImage *pinpoint = [UIImage imageNamed:@"pinpoint.png"];
    UIBarButtonItem *pinpointItem = [[UIBarButtonItem alloc]
                                     initWithImage:pinpoint style:0 target:self action:@selector(gforth)];
    NSArray *actionButtonItemsTwo = @[pinpointItem];
    self.navigationItem.rightBarButtonItems = actionButtonItemsTwo;
}

-(void) gback {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) gforth {
    [self performSegueWithIdentifier:@"endmeter" sender:self];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    // add observer for location notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRegionUpdate:)
                                                 name:@"kRegionUpdateNotification"
                                               object:nil];
    
    
    
	self.alertView = [[UIAlertView alloc] initWithTitle:@"Back so soon?"
                                                message:@"Parkle has detected that you have returned to your vehicle after 75 minutes. Total charges are $6.00. Do you wish to stayed parked?"
                                               delegate:self
                                      cancelButtonTitle:@"No I'm Done"
                                      otherButtonTitles:@"Yes I'm Staying", nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kRegionUpdateNotification" object:nil];
    
    [self performSegueWithIdentifier:@"endmeter" sender:self];
    
    [[iBeaconService sharedManager] stopMonitoringForRegion];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
}

- (void)handleRegionUpdate:(NSNotification *)notification {
    
    NSString *regionStatus = (NSString *)notification.userInfo[@"status"];
    
    if ([regionStatus isEqualToString:@"kEnterRegion"])
    {
        if ([iBeaconService sharedManager].ableToShowEnteranceNotifier == YES)
        {
            [self.alertView show];
            [iBeaconService sharedManager].ableToShowEnteranceNotifier = NO;
        }
    }
    else if ([regionStatus isEqualToString:@"kExitRegion"])
    {
        NSLog(@"meter kExitRegion");
        
        [iBeaconService sharedManager].ableToShowEnteranceNotifier = YES;
    }
    
    NSLog(@"%@", notification.userInfo[@"status"]);
}

@end
