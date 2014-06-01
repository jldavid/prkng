#import "Meter.h"

@interface Meter ()
@end

@implementation Meter

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:9.0/255.0 green:90.0/255.0 blue:187.0/255.0 alpha:0.8]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:194.0/255.0 blue:179.0/255.0 alpha:0.5]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
