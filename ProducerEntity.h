//
//  ProducerEntity.h
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/18/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MovieEntity, TVSeriesEntity;

@interface ProducerEntity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * producerId;
@property (nonatomic, retain) NSSet *movies;
@property (nonatomic, retain) NSSet *tv;
@end

@interface ProducerEntity (CoreDataGeneratedAccessors)

- (void)addMoviesObject:(MovieEntity *)value;
- (void)removeMoviesObject:(MovieEntity *)value;
- (void)addMovies:(NSSet *)values;
- (void)removeMovies:(NSSet *)values;

- (void)addTvObject:(TVSeriesEntity *)value;
- (void)removeTvObject:(TVSeriesEntity *)value;
- (void)addTv:(NSSet *)values;
- (void)removeTv:(NSSet *)values;

@end
