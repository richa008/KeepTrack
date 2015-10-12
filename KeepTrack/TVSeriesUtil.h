//
//  TVSeriesUtil.h
//  KeepTrack
//
//  Created by Deshmukh,Richa on 6/3/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Util.h"

@interface TVSeriesUtil : Util

+(TVSeriesUtil *) tvSeriesUtil;

-(UIAlertController *) showAddTVOptions : (NSInteger) tvId onCompletion: (CompletionBlock) completionBlock;
-(UIAlertController *) editWatchedTv : (NSInteger) tvId onCompletion: (CompletionBlock) completionBlock;
-(UIAlertController *) editUnwatchedTv :(NSInteger) tvId onCompletion: (CompletionBlock) completionBlock;
-(UIAlertController *) editFavoriteTv: (NSInteger) tvId onCompletion: (CompletionBlock) completionBlock;

@end
