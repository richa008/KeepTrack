//
//  EmptyTvTableViewCell.m
//  KeepTrack
//
//  Created by Deshmukh,Richa on 6/10/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import "EmptyTableViewCell.h"
#import "Util.h"

@implementation EmptyTableViewCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
   // self.imageView.frame = CGRectMake(5,5,60,60);
    
    UIImage *image = [[UIImage imageNamed:@"Crying"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.cryingImage setImage:image];
    [self.cryingImage setTintColor:[UIColor groupTableViewBackgroundColor]];
}

@end
