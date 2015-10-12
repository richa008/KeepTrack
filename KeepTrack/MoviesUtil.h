//
//  MoviesUtil.h
//  KeepTrack
//
//  Created by Deshmukh,Richa on 6/3/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import "Util.h"

@interface MoviesUtil : Util

+(MoviesUtil *) moviesUtil;

-(UIAlertController *) showAddMovieOptions : (NSInteger) movieId onCompletion: (CompletionBlock) completionBlock;
-(UIAlertController *) editWatchedMovies : (NSInteger) movieId onCompletion: (CompletionBlock) completionBlock;
-(UIAlertController *) editUnwatchedMovies :(NSInteger) movieId onCompletion: (CompletionBlock) completionBlock;
-(UIAlertController *) editFavoriteMovies: (NSInteger) movieId onCompletion: (CompletionBlock) completionBlock;

@end
