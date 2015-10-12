//
//  DataManager.h
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/8/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieEntity.h"
#import "Movie.h"
#import "Util.h"

@interface DataManager : NSObject

+(DataManager *) dataManager;

typedef void (^ SuccessBlock)(NSArray *result);
typedef void (^ FailureBlock)();

-(void) searchMoviesByTitle : (NSString *) movieTitle withSuccess:(SuccessBlock)successBlock withFailure:(FailureBlock)failureBlock;
-(void) searchTsSeriesByTitle:(NSString *) tvSeriesTitle withSuccess:(SuccessBlock)successBlock withFailure:(FailureBlock)failureBlock;

-(void) popularMovies :(SuccessBlock)successBlock withFailure:(FailureBlock)failureBlock;
-(void) popularTvSeries :(SuccessBlock)successBlock withFailure:(FailureBlock)failureBlock;

-(void) getBasicMovieDetailsByMovieId : (NSInteger) movieId withSuccess:(SuccessBlock)successBlock withFailure:(FailureBlock)failureBlock;
-(void) getMovieDetailsByMovieId : (NSInteger) movieId withSuccess:(SuccessBlock)successBlock withFailure:(FailureBlock) failureBlock;
-(void) getBasicTvSeriesDetailsById:(NSInteger) movieId withSuccess:(SuccessBlock)successBlock withFailure:(FailureBlock) failureBlock;
-(void) getTvSeriesDetailsById:(NSInteger) movieId withSuccess:(SuccessBlock)successBlock withFailure:(FailureBlock) failureBlock;

-(BOOL) isObjectInListForEntity:(NSString *) entity withId :(NSInteger) objectId withIdString : (NSString *) objectString;
-(NSManagedObject *) objectFromCoreDataWithValue: (NSInteger) objectValue withName : (NSString *) objectName inEntity : (NSString *) entityName;
-(NSArray *) objectArrayFromCoreDataWithValue: (NSInteger) objectValue withName : (NSString *) objectName inEntity : (NSString *) entityName;

-(void) deleteMovieFromCoreDataWithId : (NSInteger) movieId onCompletion: (CompletionBlock) completionBlock;
-(void) deleteTvSeriesFromCoreDataWithId : (NSInteger) tvId onCompletion: (CompletionBlock) completionBlock;

-(void) addMovieToList : (NSInteger) movieId  withStatus:(NSInteger) status onCompletion: (CompletionBlock) completionBlock;
-(void) addTvSeriesToList : (NSInteger) tvId  withStatus:(NSInteger) status onCompletion: (CompletionBlock) completionBlock;

-(void) saveContext;

@end
