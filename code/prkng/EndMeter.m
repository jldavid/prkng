#import "EndMeter.h"

@interface EndMeter ()
@end

@implementation EndMeter


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
    
    // Do any additional setup after loading the view.
}

-(void) gback {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) gforth {
    [self performSegueWithIdentifier:@"inspector" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
