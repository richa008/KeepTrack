//
//  DirectorEntity.h
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/18/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MovieEntity;

@interface DirectorEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * directorId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *movies;
@end

@interface DirectorEntity (CoreDataGeneratedAccessors)

- (void)addMoviesObject:(MovieEntity *)value;
- (void)removeMoviesObject:(MovieEntity *)value;
- (void)addMovies:(NSSet *)values;
- (void)removeMovies:(NSSet *)values;

@end
