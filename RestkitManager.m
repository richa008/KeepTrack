//
//  CoreDataManager.m
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/8/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import "RestkitManager.h"
#import "RestkitMappings.h"
#import <RestKit/RestKit.h>

@implementation RestkitManager

const NSString *apiPathUrl = @"https://api.themoviedb.org/3/";

+(void)setupSharedManager
{
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://api.themoviedb.org/3/"]];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    [RKObjectManager setSharedManager:manager];
    [RestkitManager setupManagedObjectStore];
    [RestkitManager setupResponseDescriptors];
}


+(void) setupManagedObjectStore
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    
    //Describes schema. contains collection of entities and their relationships
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];

    //The RKManagedObjectStore class encapsulates a Core Data stack including a managed object model, a persistent store coordinator, and a set of managed object contexts. Simplifies setting up core data stack
    RKManagedObjectStore *store = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    NSError *error;
    BOOL success = RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error);
    
    if(!success)
    {
         NSLog(@"Failed to create Application Data Directory at path '%@': %@", RKApplicationDataDirectory(), error);
    }
    
    NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"KeepTrack.sqlite"];
    
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption: @"YES",
                              NSInferMappingModelAutomaticallyOption: @"YES"
                              };
    
    //This class is the abstract base class for all Core Data persistent stores. sqlite file
    NSPersistentStore *persistentStore = [store addSQLitePersistentStoreAtPath:path fromSeedDatabaseAtPath:nil withConfiguration:nil options:options error:&error];
    
    if (! persistentStore)
    {
        NSLog(@"Failed adding persistent store at path '%@': %@", path, error);
    }
    
    [store createManagedObjectContexts];
    
    store.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:store.persistentStoreManagedObjectContext];
    
    [[RKObjectManager sharedManager] setManagedObjectStore:store];
}

+(void) setupResponseDescriptors
{
    RKResponseDescriptor *movieSearchDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RestkitMappings movieSearchMappings] method:RKRequestMethodGET pathPattern:@"search/movie" keyPath:@"results" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [[RKObjectManager sharedManager] addResponseDescriptor:movieSearchDescriptor];
    
    RKResponseDescriptor *moviePopularDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RestkitMappings movieSearchMappings] method:RKRequestMethodGET pathPattern:@"movie/popular" keyPath:@"results" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [[RKObjectManager sharedManager] addResponseDescriptor:moviePopularDescriptor];
    
    RKResponseDescriptor *tvSearchDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RestkitMappings tvSearchMappings] method:RKRequestMethodGET pathPattern:@"search/tv" keyPath:@"results" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [[RKObjectManager sharedManager] addResponseDescriptor:tvSearchDescriptor];
    
    RKResponseDescriptor *tvPopularDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RestkitMappings tvSearchMappings] method:RKRequestMethodGET pathPattern:@"tv/popular" keyPath:@"results" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [[RKObjectManager sharedManager] addResponseDescriptor:tvPopularDescriptor];
    
    RKResponseDescriptor *movieDetailsDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RestkitMappings movieDetailsMappings] method:RKRequestMethodGET pathPattern:@"movie/:movieId" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [[RKObjectManager sharedManager] addResponseDescriptor:movieDetailsDescriptor];
    
    RKResponseDescriptor *tvDetailsDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RestkitMappings tvDetailsMappings] method:RKRequestMethodGET pathPattern:@"tv/:tvId" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [[RKObjectManager sharedManager] addResponseDescriptor:tvDetailsDescriptor];
    
    RKResponseDescriptor *castDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RestkitMappings castMappings] method:RKRequestMethodGET pathPattern:@"movie/:movieId/credits" keyPath:@"cast" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [[RKObjectManager sharedManager] addResponseDescriptor:castDescriptor];
    
    RKResponseDescriptor *tvCrewDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RestkitMappings castMappings] method:RKRequestMethodGET pathPattern:@"tv/:tvId/credits" keyPath:@"cast" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [[RKObjectManager sharedManager] addResponseDescriptor:tvCrewDescriptor];

    RKResponseDescriptor *crewDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RestkitMappings crewMappings] method:RKRequestMethodGET pathPattern:@"movie/:movieId/credits" keyPath:@"crew" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [[RKObjectManager sharedManager] addResponseDescriptor:crewDescriptor];
}


@end
