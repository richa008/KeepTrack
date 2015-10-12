//
//  Util.h
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/6/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <UIKit/UIKit.h>

@interface Util : NSObject

typedef void (^CompletionBlock)();

enum Status
{
    WATCHED = 0,
    UNWATCHED = 1
};

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define EMPTY_CELL_HEIGHT 200;
#define CELL_HEIGHT 95;

+(UIColor *) titleBarTintColor;
+(UIColor *) baseTintColor;
+(UIColor *) darkColor;
+(UIColor *) lightColor;

+(NSString *) imageBaseUrl;

+(void) changeTableViewDisplayStyle: (UITableView *) tableView;
+(void) displayViewWithGradient: (UIView *) view;

+(NSString *) showVoteAverage: (NSString *) voteAvg;
+(NSAttributedString *) displayString : (NSString *) str;

+(void) startAnimating: (UIActivityIndicatorView *) spinner;
+(void) stopAnimating: (UIActivityIndicatorView *) spinner;

@end
