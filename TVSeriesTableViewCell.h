//
//  TVSeriesTableViewCell.h
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/18/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVSeriesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end
