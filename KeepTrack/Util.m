//
//  Util.m
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/6/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import "Util.h"
#import "DataManager.h"
#import "TVSeriesEntity.h"

@implementation Util


+(UIColor *) titleBarTintColor
{
    return UIColorFromRGB(0x041d22);
}

+(UIColor *) baseTintColor
{
    return [UIColor whiteColor];
}

+(UIColor *) lightColor
{
    return UIColorFromRGB(0x0E6174);
}

+(UIColor *) darkColor
{
    return UIColorFromRGB(0x0A4553);
}

+(NSString *) imageBaseUrl
{
    return @"http://image.tmdb.org/t/p/w500";
}

+(void) displayViewWithGradient: (UIView *) view
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[UIColorFromRGB(0xd0e7ed) CGColor], nil];
    [view.layer insertSublayer:gradient atIndex:0];
}

+(void) changeTableViewDisplayStyle:(UITableView *)tableView
{
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [tableView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [tableView.layer setBorderWidth:0.5f];
}

+(NSString *) showVoteAverage: (NSString *) voteAvg
{
    return [NSString stringWithFormat:@"%@/10", voteAvg];
}

+(NSAttributedString *) displayString : (NSString *) str
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:1];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    
    return attributedString;
}

+(void) startAnimating: (UIActivityIndicatorView *) spinner
{
    [spinner startAnimating];
}

+(void) stopAnimating: (UIActivityIndicatorView *) spinner
{
    [spinner stopAnimating];
}

@end
