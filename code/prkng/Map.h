#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface Map : UIViewController <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)click:(id)sender;

@end
