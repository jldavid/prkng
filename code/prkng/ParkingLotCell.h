#import <UIKit/UIKit.h>

@interface ParkingLotCell : UITableViewCell
    @property (strong, nonatomic) IBOutlet UILabel *lotIDLabel;
    @property (strong, nonatomic) IBOutlet UIImageView *lotIDImageView;
    @property (strong, nonatomic) IBOutlet UILabel *addressLabel;
    @property (strong, nonatomic) IBOutlet UILabel *lotDetailLabel;
    @property (strong, nonatomic) IBOutlet UILabel *rateLabel;
@end
