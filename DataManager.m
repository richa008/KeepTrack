//
//  DataManager.m
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/8/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import "DataManager.h"
#import "RestkitManager.h"
#import "TVSeriesEntity.h"
#import "TVSeries.h"
#import "Movie.h"
#import "Cast.h"
#import "Crew.h"
#import "GenreEntity.h"
#import "CastEntity.h"
#import "ProducerEntity.h"
#import "DirectorEntity.h"
#import <Restkit/Restkit.h>

@implementation DataManager

const static NSString *api_key = @"70471bf5ebea4aa268f21c21a86761d0";

static DataManager* _dataManager = nil;

/*
 * Makes a webservice call to get details about a movie
 */
-(void) getBasicMovieDetailsByMovieId : (NSInteger) movieId withSuccess:(SuccessBlock)successBlock withFailure:(FailureBlock)failureBlock;
{
    NSDictionary *params = @{
                             @"api_key" : api_key
                             };
    
    __block NSArray *arrayMovie = [[NSArray alloc] init];
    NSString *path = [NSString stringWithFormat:@"movie/%ld", (long)movieId];
    [[RKObjectManager sharedManager] getObjectsAtPath:path parameters:params
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                                                  arrayMovie = mappingResult.array;
                                                  if(successBlock)
                                                  {
                                                      successBlock(arrayMovie);
                                                  }
                                                  NSLog(@"success in movie details");
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error){
                                                  NSLog(@"FAILURE in getting movie details: %@", error);
                                              }
     ];
}



/*
 * Makes a webservice call to get details about a tv show
 */
-(void) getBasicTvSeriesDetailsById : (NSInteger) tvId withSuccess:(SuccessBlock)successBlock withFailure:(FailureBlock)failureBlock;
{
    NSDictionary *params = @{
                             @"api_key" : api_key
                             };
    
    __block NSArray *arrayTv = [[NSArray alloc] init];
    NSString *path = [NSString stringWithFormat:@"tv/%ld", (long)tvId];
    [[RKObjectManager sharedManager] getObjectsAtPath:path parameters:params
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                                                  arrayTv = mappingResult.array;
                                                  if(successBlock)
                                                  {
                                                      successBlock(arrayTv);
                                                  }
                                                  NSLog(@"success in tv details");
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error){
                                                  NSLog(@"FAILURE in getting tv details: %@", error);
                                              }
     ];
}


/*
 * Get cast and crew information about a movie
 *
 */
-(void) getCreditsByMovieId : (NSInteger) movieId withSuccess:(SuccessBlock)successBlock withFailure:(FailureBlock)failureBlock;
{
    NSDictionary *params = @{
                             @"api_key" : api_key
                             };
    
    __block NSArray *castArray = [[NSArray alloc] init];
    NSString *castPath = [NSString stringWithFormat:@"movie/%ld/credits", (long)movieId];
    [[RKObjectManager sharedManager] getObjectsAtPath:castPath parameters:params
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                                                  castArray = mappingResult.array;
                                                  if(successBlock)
                                                  {
                                                      successBlock(castArray);
                                                  }
                                                  NSLog(@"success in movie cast");
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error){
                                                  NSLog(@"FAILURE in getting movie cast: %@", error);
                                              }
     ];
}

/*
 * Get cast information about a tv series
 *
 */
-(void) getTvCastDetailsById : (NSInteger) tvId withSuccess:(SuccessBlock)successBlock withFailure:(FailureBlock)failureBlock;
{
    NSDictionary *params = @{
                             @"api_key" : api_key
                             };
    
    __block NSArray *castArray = [[NSArray alloc] init];
    NSString *castPath = [NSString stringWithFormat:@"tv/%ld/credits", (long)tvId];
    [[RKObjectManager sharedManager] getObjectsAtPath:castPath parameters:params
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                                                  castArray = mappingResult.array;
                                                  if(successBlock)
                                                  {
                                                      successBlock(castArray);
                                                  }
                                                  NSLog(@"success in tv cast");
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error){
                                                  NSLog(@"FAILURE in getting tv cast: %@", error);
                                              }
     ];
}

/*
 * Makes the call to get movie details. If that succeeds, makes the call to get cast and crew information
 */
-(void) getMovieDetailsByMovieId : (NSInteger) movieId withSuccess:(SuccessBlock)successBlock withFailure:(FailureBlock) failureBlock
{
    __block Movie *movie;
    //On success, make call to get cast and crew info
    SuccessBlock onSuccess = ^(NSArray *results)
    {
        movie = [results objectAtIndex:0];
        SuccessBlock onSuccessCrew = ^(NSArray *results)
        {
            movie.cast = [[NSMutableArray alloc] init];
            movie.crew = [[NSMutableArray alloc] init];
            for(id element in results)
            {
                if([element isKindOfClass:[Cast class]])
                {
                    [movie.cast addObject:element];
                }
                else if([element isKindOfClass:[Crew class]])
                {
                    [movie.crew addObject:element];
                }
            }
            if(successBlock)
            {
                NSArray *arry = @[movie];
                successBlock(arry);
            }
        };
        [self getCreditsByMovieId:movieId withSuccess:onSuccessCrew withFailure:nil];
    };
    [self getBasicMovieDetailsByMovieId:movieId withSuccess:onSuccess withFailure:nil];
}

/*
 * Makes the call to get tv series details. If that succeeds, makes the call to get cast and crew information
 */
-(void) getTvSeriesDetailsById : (NSInteger) tvId withSuccess:(SuccessBlock)successBlock withFailure:(FailureBlock) failureBlock
{
    __block TVSeries *tvSeries;
    //On success, make call to get cast and crew info
    SuccessBlock onSuccess = ^(NSArray *results)
    {
        tvSeries = [results objectAtIndex:0];
        SuccessBlock onSuccessCrew = ^(NSArray *results)
        {
            tvSeries.cast = [[NSMutableArray alloc] init];
            for(id element in results)
            {
                if([element isKindOfClass:[Cast class]])
                {
                    [tvSeries.cast addObject:element];
                }
            }
            if(successBlock)
            {
                NSArray *arry = @[tvSeries];
                successBlock(arry);
            }
        };
        [self getTvCastDetailsById:tvId withSuccess:onSuccessCrew withFailure:nil];
    };
    [self getBasicTvSeriesDetailsById:tvId withSuccess:onSuccess withFailure:nil];
}

-(void) popularMovies :(SuccessBlock)successBlock withFailure:(FailureBlock)failureBlock
{
    NSDictionary *params = @{
                             @"api_key" :api_key
                             };
    
    __block NSArray *array = [[NSArray alloc] init];
    NSString *path = [NSString stringWithFormat:@"movie/popular"];
    [[RKObjectManager sharedManager] getObjectsAtPath:path parameters:params
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                                                  array = mappingResult.array;
                                                  NSLog(@"success in getting popular movies");
                                                  if(successBlock){
                                                      successBlock(array);
                                                  }
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error){
                                                  NSLog(@"FAILURE in getting popular movies: %@", error);
                                              }
     ];
}

-(void) popularTvSeries:(SuccessBlock)successBlock withFailure:(FailureBlock)failureBlock
{
    NSDictionary *params = @{
                             @"api_key" :api_key
                             };
    
    __block NSArray *array = [[NSArray alloc] init];
    NSString *path = [NSString stringWithFormat:@"tv/popular"];
    [[RKObjectManager sharedManager] getObjectsAtPath:path parameters:params
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                                                  array = mappingResult.array;
                                                  NSLog(@"success in getting popular tv");
                                                  if(successBlock){
                                                      successBlock(array);
                                                  }
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error){
                                                  NSLog(@"FAILURE in getting popular tv: %@", error);
                                              }
     ];
}



/*
 * Search by movie titles
 */
-(void) searchMoviesByTitle : (NSString *) movieTitle withSuccess:(SuccessBlock)successBlock withFailure:(FailureBlock)failureBlock
{
    if(!movieTitle || [movieTitle isEqualToString:@""])
    {
        movieTitle = @"a";
    }
    NSDictionary *params = @{
                             @"api_key" :api_key,
                             @"query": movieTitle
                             };
    
    __block NSArray *array = [[NSArray alloc] init];
    NSString *path = [NSString stringWithFormat:@"search/movie"];
    [[RKObjectManager sharedManager] getObjectsAtPath:path parameters:params
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                                                  array = mappingResult.array;
                                                  NSLog(@"success in getting movies");
                                                  if(successBlock){
                                                      successBlock(array);
                                                  }
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error){
                                                  NSLog(@"FAILURE in getting movies: %@", error);
                                              }
     ];
}

/*
 * Search by tv series title
 */
-(void) searchTsSeriesByTitle:(NSString *) tvSeriesTitle withSuccess:(SuccessBlock)successBlock withFailure:(FailureBlock)failureBlock
{
    if(!tvSeriesTitle || [tvSeriesTitle isEqualToString:@""])
    {
        tvSeriesTitle = @"a";
    }
    NSDictionary *params = @{
                             @"api_key" :api_key,
                             @"query": tvSeriesTitle
                             };
    
    __block NSArray *array = [[NSArray alloc] init];
    NSString *path = [NSString stringWithFormat:@"search/tv"];
    [[RKObjectManager sharedManager] getObjectsAtPath:path parameters:params
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                                                  array = mappingResult.array;
                                                  NSLog(@"success in getting tv");
                                                  if(successBlock){
                                                      successBlock(array);
                                                  }
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error){
                                                  NSLog(@"FAILURE in getting tv: %@", error);
                                              }
     ];
}

/*
 * Returns true if the object exists in core data
 */
-(BOOL) isObjectInListForEntity:(NSString *) entity withId :(NSInteger) objectId withIdString : (NSString *) objectString
{
    NSManagedObjectContext *context = [[[RKObjectManager sharedManager] managedObjectStore] mainQueueManagedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entity];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K = %@", objectString, @(objectId)];
    NSError *error;
    NSInteger count = [context countForFetchRequest:fetchRequest error:&error];
    if (count == NSNotFound) {
        NSLog(@"Error: %@", error);
        return NO;
    }
    
    return (count > 0);
}

/*
 * Returns object if it exists in core data
 */
-(NSManagedObject *) objectFromCoreDataWithValue: (NSInteger) objectValue withName : (NSString *) objectName inEntity : (NSString *) entityName
{
    NSManagedObjectContext *context = [[[RKObjectManager sharedManager] managedObjectStore] mainQueueManagedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K = %@",objectName, @(objectValue)];
    
    NSError *error;
    NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
    
    if(array.count > 0)
    {
        NSManagedObject *object = [array objectAtIndex:0];
        return object;
    }
    
    return nil;
}

-(NSArray *) objectArrayFromCoreDataWithValue: (NSInteger) objectValue withName : (NSString *) objectName inEntity : (NSString *) entityName;
{
    NSManagedObjectContext *context = [[[RKObjectManager sharedManager] managedObjectStore] mainQueueManagedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K = %@",objectName, @(objectValue)];
    
    NSError *error;
    NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

-(void) deleteMovieFromCoreDataWithId : (NSInteger) movieId onCompletion: (CompletionBlock) completionBlock
{
    NSManagedObjectContext *context = [[[RKObjectManager sharedManager] managedObjectStore] mainQueueManagedObjectContext];
    MovieEntity *movie = (MovieEntity *)[self objectFromCoreDataWithValue:movieId withName:@"movieId" inEntity:@"MovieEntity"];
    [context deleteObject:movie];
    [self saveContext];
    if(completionBlock){
        completionBlock();
    }
}

-(void) deleteTvSeriesFromCoreDataWithId : (NSInteger) tvId onCompletion: (CompletionBlock) completionBlock
{
    NSManagedObjectContext *context = [[[RKObjectManager sharedManager] managedObjectStore] mainQueueManagedObjectContext];
    TVSeriesEntity *movie = (TVSeriesEntity *)[self objectFromCoreDataWithValue:tvId withName:@"tvId" inEntity:@"TVSeriesEntity"];
    [context deleteObject:movie];
    [self saveContext];
    if(completionBlock){
        completionBlock();
    }
}


-(void) addMovieToList : (NSInteger) movieId withStatus :(NSInteger) status onCompletion: (CompletionBlock) completionBlock
{
    BOOL movieExists = [[DataManager dataManager] isObjectInListForEntity:@"MovieEntity" withId:movieId withIdString: @"movieId"];
    if(movieExists)
    {
        //Get movie from core data
        MovieEntity *movie = (MovieEntity *)[self objectFromCoreDataWithValue:movieId withName:@"movieId" inEntity:@"MovieEntity"];
        movie.status = @(status);
        [[DataManager dataManager] saveContext];
    }
    else
    {
        SuccessBlock onSuccess = ^(NSArray *results)
        {
            Movie* movie = [results objectAtIndex:0];
            NSManagedObjectContext *context = [[[RKObjectManager sharedManager] managedObjectStore] mainQueueManagedObjectContext];
            MovieEntity *entity = [context insertNewObjectForEntityForName:@"MovieEntity"];
            entity.movieId = movie.movieId;
            entity.title = movie.title;
            entity.backDropImagePath = movie.backDropImagePath;
            entity.imagePath = movie.imagePath;
            entity.overview = movie.overview;
            entity.releaseDate = movie.releaseDate;
            entity.voteAverage = movie.voteAverage;
            entity.status = @(status);
            entity.favorite = @(0);
            
            for(Genre *genre in movie.genres)
            {
                GenreEntity *gEntity = (GenreEntity *)[self objectFromCoreDataWithValue:genre.genreId.integerValue withName:@"genreId" inEntity:@"GenreEntity"];
                if(gEntity != nil)
                {
                    [entity addGenresObject:gEntity];
                }
                else
                {
                    GenreEntity *gEntity = [context insertNewObjectForEntityForName:@"GenreEntity"];
                    gEntity.genreId = genre.genreId;
                    gEntity.name = genre.genre;
                    
                    [entity addGenresObject:gEntity];
                }
            }
           
            NSInteger count = (movie.cast.count < 8) ? movie.cast.count : 8;
            for(int i = 0; i < count; i++)
            {
                Cast *cast = movie.cast[i];
                CastEntity *cEntity = (CastEntity *)[self objectFromCoreDataWithValue:cast.castId withName:@"castId" inEntity:@"CastEntity"];
                if(cEntity)
                {
                    [entity addCastObject:cEntity];
                }
                else
                {
                    CastEntity *cEntity = [context insertNewObjectForEntityForName:@"CastEntity"];
                    
                    cEntity.castId = @(cast.castId);
                    cEntity.name = cast.name;
                    
                    [entity addCastObject:cEntity];
                }
            }
            
            
            for(Crew *crew in movie.crew)
            {
                if([crew.job isEqualToString:@"Director"])
                {
                    DirectorEntity *tempEntity = (DirectorEntity *)[self objectFromCoreDataWithValue:crew.crewId withName:@"directorId" inEntity:@"DirectorEntity"];
                    if(tempEntity)
                    {
                        entity.director = tempEntity;
                    }
                    else
                    {
                        DirectorEntity *tempEntity = [context insertNewObjectForEntityForName:@"DirectorEntity"];
                        tempEntity.name = crew.name;
                        tempEntity.directorId = @(crew.crewId);
                        entity.director = tempEntity;
                    }
                }
                else if([crew.job isEqualToString:@"Producer"])
                {
                    ProducerEntity *tempEntity = (ProducerEntity *)[self objectFromCoreDataWithValue:crew.crewId withName:@"producerId" inEntity:@"ProducerEntity"];
                    if(tempEntity)
                    {
                        entity.producer = tempEntity;
                    }
                    else
                    {
                        ProducerEntity *tempEntity = [context insertNewObjectForEntityForName:@"ProducerEntity"];
                        tempEntity.name = crew.name;
                        tempEntity.producerId = @(crew.crewId);
                        entity.producer = tempEntity;
                    }
                }
                
            }
            
            [[DataManager dataManager] saveContext];
            if(completionBlock){
                completionBlock();
            }
        };
        
        //Get movie details from service
        [[DataManager dataManager] getMovieDetailsByMovieId:movieId withSuccess:onSuccess withFailure:nil];
    }
}


-(void) addTvSeriesToList : (NSInteger) tvId withStatus :(NSInteger) status onCompletion: (CompletionBlock) completionBlock
{
    BOOL tvExists = [[DataManager dataManager] isObjectInListForEntity:@"TVSeriesEntity" withId:tvId withIdString: @"tvId"];
    if(tvExists)
    {
        TVSeriesEntity *tv = (TVSeriesEntity *)[self objectFromCoreDataWithValue:tvId withName:@"tvId" inEntity:@"TVSeriesEntity"];
        tv.status = @(status);
        [[DataManager dataManager] saveContext];
    }
    else
    {
        SuccessBlock onSuccess = ^(NSArray *results)
        {
            TVSeries* tv = [results objectAtIndex:0];
            NSManagedObjectContext *context = [[[RKObjectManager sharedManager] managedObjectStore] mainQueueManagedObjectContext];
            TVSeriesEntity *entity = [context insertNewObjectForEntityForName:@"TVSeriesEntity"];
            entity.tvId = tv.tvId;
            entity.name = tv.name;
            entity.backdropImage = tv.backDropImagePath;
            entity.imagePath = tv.imagePath;
            entity.overview = tv.overview;
            entity.firstAirDate = tv.firstAirDate;
            entity.lastAirDate = tv.lastAirDate;
            entity.numberOfSeasons = tv.noOfSeasons;
            entity.numberOfEpisodes = tv.noOfEpisodes;
            entity.voteAverage = tv.voteAverage;
            entity.status = @(status);
            entity.favorite = @(0);
            
            for(Genre *genre in tv.genres)
            {
                GenreEntity *gEntity = (GenreEntity *)[self objectFromCoreDataWithValue:genre.genreId.integerValue withName:@"genreId" inEntity:@"GenreEntity"];
                if(gEntity != nil)
                {
                    [entity addGenresObject:gEntity];
                }
                else
                {
                    GenreEntity *gEntity = [context insertNewObjectForEntityForName:@"GenreEntity"];
                    gEntity.genreId = genre.genreId;
                    gEntity.name = genre.genre;
                    
                    [entity addGenresObject:gEntity];
                }
            }
            NSInteger count = 0;
            if(tv.createdBy > 0)
            {
                count = (tv.createdBy.count > 2) ? 2: tv.createdBy.count;
            }
            for(int i = 0; i < count; i++)
            {
                Crew *crew = tv.createdBy[i];
                ProducerEntity *cEntity = (ProducerEntity *)[self objectFromCoreDataWithValue:crew.crewId withName:@"producerId" inEntity:@"ProducerEntity"];
                if(cEntity)
                {
                    [entity addCreatedByObject:cEntity];
                }
                else
                {
                    ProducerEntity *gEntity = [context insertNewObjectForEntityForName:@"ProducerEntity"];
                    gEntity.producerId = @(crew.crewId);
                    gEntity.name = crew.name;
                    
                    [entity addCreatedByObject:gEntity];
                }
            }
            
            count = 0;
            count = (tv.cast.count < 8) ? tv.cast.count : 8;
            for(int i = 0; i < count; i++)
            {
                Cast *cast = tv.cast[i];
                CastEntity *cEntity = (CastEntity *)[self objectFromCoreDataWithValue:cast.castId withName:@"castId" inEntity:@"CastEntity"];
                if(cEntity)
                {
                    [entity addCastObject:cEntity];
                }
                else
                {
                    CastEntity *cEntity = [context insertNewObjectForEntityForName:@"CastEntity"];
                    
                    cEntity.castId = @(cast.castId);
                    cEntity.name = cast.name;
                    
                    [entity addCastObject:cEntity];
                }
            }
            [[DataManager dataManager] saveContext];
            if(completionBlock){
                completionBlock();
            }
        };
        
        //Get movie details from service
        [[DataManager dataManager] getTvSeriesDetailsById:tvId withSuccess:onSuccess withFailure:nil];
    }
}


-(void) saveContext
{
    NSManagedObjectContext *context = [[[RKObjectManager sharedManager] managedObjectStore] mainQueueManagedObjectContext];
    NSError *error;
    
    if([context saveToPersistentStore:&error])
    {
        NSLog(@"Saved successfully");
    }
    else
    {
        NSLog(@"Error saving : %@", error);
    }
}

+(DataManager*) dataManager {
    @synchronized([DataManager class]) {
        if (!_dataManager)
        {
            _dataManager = [[self alloc] init];
        }
        
        return _dataManager;
    }
    return nil;
}

+(id)alloc {
    @synchronized([DataManager class])
    {
        NSAssert(_dataManager == nil, @"Attempted to allocate a second instance of a singleton.");
        _dataManager = [super alloc];
        return _dataManager;
    }
    return nil;
}

-(id)init
{
    self = [super init];
    
    return self;
}

@end
