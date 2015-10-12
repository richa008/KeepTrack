//
//  RestkitMappings.m
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/8/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import "RestkitMappings.h"
#import "Movie.h"
#import "TVSeries.h"
#import "Cast.h"
#import "Crew.h"
#import "Genre.h"

@implementation RestkitMappings

+(RKObjectMapping *) tvSearchMappings
{
    RKObjectMapping *tvSearchMappings = [RKObjectMapping mappingForClass:[TVSeries class]];
    
    NSDictionary *dict = @{ @"id": @"tvId",
                            @"name": @"name",
                            @"first_air_date": @"firstAirDate",
                            @"poster_path": @"imagePath"
                           };
    [tvSearchMappings addAttributeMappingsFromDictionary:dict];
    
    return tvSearchMappings;
}

+(RKObjectMapping *) movieSearchMappings
{
    RKObjectMapping *movieMappings = [RKObjectMapping mappingForClass:[Movie class]];
    
    NSDictionary *dict = @{ @"id": @"movieId",
                            @"title": @"title",
                            @"release_date": @"releaseDate",
                            @"poster_path": @"imagePath"
                            };
    [movieMappings addAttributeMappingsFromDictionary:dict];
    
    return movieMappings;
}

+(RKObjectMapping *) genreMappings
{
    RKObjectMapping *genreMapping = [RKObjectMapping mappingForClass:[Genre class]];
    NSDictionary *genreDict = @{ @"id": @"genreId",
                                 @"name": @"genre"
                                 };
    [genreMapping addAttributeMappingsFromDictionary:genreDict];
    
    return genreMapping;
}

+(RKObjectMapping *) movieDetailsMappings
{
    
    RKObjectMapping *movieMappings = [RKObjectMapping mappingForClass:[Movie class]];
    NSDictionary *dict = @{ @"id": @"movieId",
                            @"title": @"title",
                            @"release_date": @"releaseDate",
                            @"poster_path": @"imagePath",
                            @"backdrop_path":@"backDropImagePath",
                            @"overview":@"overview",
                            @"vote_average":@"voteAverage"
                            };
    [movieMappings addAttributeMappingsFromDictionary:dict];
    [movieMappings addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"genres" toKeyPath:@"genres" withMapping:[RestkitMappings genreMappings]]];
    
    return movieMappings;
}

+(RKObjectMapping *) tvDetailsMappings
{
    
    RKObjectMapping *tvMappings = [RKObjectMapping mappingForClass:[TVSeries class]];
    NSDictionary *dict = @{ @"id": @"tvId",
                            @"name": @"name",
                            @"poster_path": @"imagePath",
                            @"backdrop_path": @"backDropImagePath",
                            @"overview": @"overview",
                            @"first_air_date": @"firstAirDate",
                            @"last_air_date" : @"lastAirDate",
                            @"number_of_seasons" : @"noOfSeasons",
                            @"number_of_episodes": @"noOfEpisodes",
                            @"vote_average": @"voteAverage"
                            
                            };
    [tvMappings addAttributeMappingsFromDictionary:dict];
    [tvMappings addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"genres" toKeyPath:@"genres" withMapping:[RestkitMappings genreMappings]]];
     [tvMappings addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"created_by" toKeyPath:@"createdBy" withMapping:[RestkitMappings crewMappings]]];
    
    return tvMappings;
}


+(RKObjectMapping *) castMappings
{
    RKObjectMapping *castMappings = [RKObjectMapping mappingForClass:[Cast class]];
    
    NSDictionary *dict = @{ @"id": @"castId",
                            @"name": @"name"
                          };
    [castMappings addAttributeMappingsFromDictionary:dict];
    
    return castMappings;
}

+(RKObjectMapping *) crewMappings
{
    RKObjectMapping *crewMappings = [RKObjectMapping mappingForClass:[Crew class]];
    
    NSDictionary *dict = @{ @"id": @"crewId",
                            @"name": @"name",
                            @"job":@"job"
                          };
    [crewMappings addAttributeMappingsFromDictionary:dict];
    
    return crewMappings;
}

@end
