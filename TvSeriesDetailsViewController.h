//
//  TvSeriesDetailsViewController.h
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/19/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TvSeriesDetailsViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic) NSInteger tvId;
@property (nonatomic) NSInteger tvControl;
@property (nonatomic) BOOL navigatedFromSearch;

@end
