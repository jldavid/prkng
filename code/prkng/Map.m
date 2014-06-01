#import "Map.h"
#import "FSNConnection.h"

@interface Map ()
@end

@implementation Map

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", @"http://www1.toronto.ca", @"/City_Of_Toronto/Information_&_Technology/Open_Data/Data_Sets/Assets/Files/greenPParking.json"]];
    FSNConnection *connection = [FSNConnection withUrl:url
                                                method:FSNRequestMethodPOST
                                               headers:nil
                                            parameters:nil
                                            parseBlock:^id(FSNConnection *c, NSError **error) {
                                                return [c.responseData dictionaryFromJSONWithError:error];
                                            }
                                       completionBlock:^(FSNConnection *c) {
                                           NSLog(@"complete: %@\n  error: %@\n  parseResult: %@\n", c, c.error, c.parseResult);
                                           //NSError *error = nil;
                                           //NSDictionary *json = [NSJSONSerialization JSONObjectWithData:c.responseData options:kNilOptions error:&error];
                                           //NSString *token = [json objectForKey:@"token"];
                                           //NSLog(@"Token: %@", token);
                                           
                                       }
                                         progressBlock:^(FSNConnection *c) {
                                             NSLog(@"progress: %@: %.2f", c, c.uploadProgress);
                                         }];
    [connection start];
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
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

- (IBAction)click:(id)sender {
        [self performSegueWithIdentifier:@"meter" sender:self];
}
@end
