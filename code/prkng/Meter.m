#import "Meter.h"

@interface Meter ()
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
