//
//  MovieEntity.h
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/18/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CastEntity, DirectorEntity, GenreEntity, ProducerEntity;

@interface MovieEntity : NSManagedObject

@property (nonatomic, retain) NSString * backDropImagePath;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSNumber * movieId;
@property (nonatomic, retain) NSString * overview;
@property (nonatomic, retain) NSString * releaseDate;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * voteAverage;
@property (nonatomic, retain) NSSet *cast;
@property (nonatomic, retain) DirectorEntity *director;
@property (nonatomic, retain) NSSet *genres;
@property (nonatomic, retain) ProducerEntity *producer;
@end

@interface MovieEntity (CoreDataGeneratedAccessors)

- (void)addCastObject:(CastEntity *)value;
- (void)removeCastObject:(CastEntity *)value;
- (void)addCast:(NSSet *)values;
- (void)removeCast:(NSSet *)values;

- (void)addGenresObject:(GenreEntity *)value;
- (void)removeGenresObject:(GenreEntity *)value;
- (void)addGenres:(NSSet *)values;
- (void)removeGenres:(NSSet *)values;

@end
