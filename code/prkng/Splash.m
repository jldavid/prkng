#import "Splash.h"

@interface Splash ()
@end

@implementation Splash

- (void)viewDidLoad
{
    [super viewDidLoad];
    //_parkleButton.adjustsImageWhenHighlighted = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
- (IBAction)click:(id)sender {
    [self performSegueWithIdentifier:@"map" sender:self];
}
*/

@end
