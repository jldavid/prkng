//
//  InspectorParkingLotCell.h
//  prkng
//
//  Created by Ryan Laudi on 2014-06-01.
//  Copyright (c) 2014 jldavid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InspectorParkingLotCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lotIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *spotStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *elapsedTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *hoursStayedLabel;

@end
