//
//  Movie.h
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/8/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Genre.h"
#import "Cast.h"
#import "Crew.h"

@interface Movie : NSObject

@property (nonatomic, strong) NSNumber *movieId;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *backDropImagePath;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSString *releaseDate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *voteAverage;

@property (nonatomic, strong) NSMutableArray *cast;
@property (nonatomic, strong) NSMutableArray *crew;
@property (nonatomic, strong) NSMutableArray *genres;

@end
