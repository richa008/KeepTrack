//
//  MovieDetailsViewController.h
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/10/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailsViewController : UIViewController <UIScrollViewDelegate, UITextViewDelegate>

@property (nonatomic) NSInteger movieId;
@property (nonatomic) NSInteger movieControl;
@property (nonatomic) BOOL navigatedFromSearch;

@end
