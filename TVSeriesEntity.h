//
//  TVSeriesEntity.h
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/18/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CastEntity, GenreEntity, ProducerEntity;

@interface TVSeriesEntity : NSManagedObject

@property (nonatomic, retain) NSString * backdropImage;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSString * firstAirDate;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSString * lastAirDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * numberOfEpisodes;
@property (nonatomic, retain) NSNumber * numberOfSeasons;
@property (nonatomic, retain) NSString * overview;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * tvId;
@property (nonatomic, retain) NSNumber * voteAverage;
@property (nonatomic, retain) NSSet *cast;
@property (nonatomic, retain) NSSet *createdBy;
@property (nonatomic, retain) NSSet *genres;
@end

@interface TVSeriesEntity (CoreDataGeneratedAccessors)

- (void)addCastObject:(CastEntity *)value;
- (void)removeCastObject:(CastEntity *)value;
- (void)addCast:(NSSet *)values;
- (void)removeCast:(NSSet *)values;

- (void)addCreatedByObject:(ProducerEntity *)value;
- (void)removeCreatedByObject:(ProducerEntity *)value;
- (void)addCreatedBy:(NSSet *)values;
- (void)removeCreatedBy:(NSSet *)values;

- (void)addGenresObject:(GenreEntity *)value;
- (void)removeGenresObject:(GenreEntity *)value;
- (void)addGenres:(NSSet *)values;
- (void)removeGenres:(NSSet *)values;

@end
