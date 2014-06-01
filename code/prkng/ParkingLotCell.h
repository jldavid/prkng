//
//  ParkingLotCell.h
//  prkng
//
//  Created by Ryan Laudi on 2014-06-01.
//  Copyright (c) 2014 jldavid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkingLotCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lotIDLabel;
@property (strong, nonatomic) IBOutlet UIImageView *lotIDImageView;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *lotDetailLabel;
@property (strong, nonatomic) IBOutlet UILabel *rateLabel;

@end
