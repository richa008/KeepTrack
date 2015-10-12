//
//  TVSeries.h
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/18/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TVSeries : NSObject

@property (nonatomic, strong) NSNumber *tvId;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *backDropImagePath;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSString *firstAirDate;
@property (nonatomic, strong) NSString *lastAirDate;
@property (nonatomic, strong) NSNumber *noOfSeasons;
@property (nonatomic, strong) NSNumber *noOfEpisodes;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *voteAverage;

@property (nonatomic, strong) NSMutableArray *createdBy;
@property (nonatomic, strong) NSMutableArray *cast;
@property (nonatomic, strong) NSMutableArray *genres;

@end
