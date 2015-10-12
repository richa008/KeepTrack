//
//  MoviesUtil.m
//  KeepTrack
//
//  Created by Deshmukh,Richa on 6/3/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import "MoviesUtil.h"
#import "DataManager.h"
#import "Constants.h"

@implementation MoviesUtil

static MoviesUtil* _moviesUtil = nil;

-(UIAlertController *) showAddMovieOptions:(NSInteger)movieId onCompletion: (CompletionBlock) completionBlock
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Add to List"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *watchedAction = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(ADD_WATCHED, @"watched action")
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action)
                                    {
                                        NSLog(@"watched action");
                                        [[DataManager dataManager] addMovieToList:movieId withStatus :WATCHED onCompletion:completionBlock];
                                    }];
    
    UIAlertAction *unwatchedAction = [UIAlertAction
                                      actionWithTitle:NSLocalizedString(ADD_UNWATCHED, @"unwatched action")
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction *action)
                                      {
                                          NSLog(@"unwatched action");
                                          [[DataManager dataManager] addMovieToList:movieId withStatus :UNWATCHED onCompletion:completionBlock];
                                      }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(CANCEL, @"cancel action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"cancel action");
                                       
                                   }];
    
    [alertController addAction:watchedAction];
    [alertController addAction:unwatchedAction];
    [alertController addAction:cancelAction];
    
    alertController.view.tintColor = [Util darkColor];
    
    return alertController;
}

-(UIAlertController *) editWatchedMovies : (NSInteger) movieId onCompletion: (CompletionBlock) completionBlock
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Edit"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    alertController.modalTransitionStyle=UIModalPresentationOverCurrentContext;
    
    UIAlertAction *favAction = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(ADD_TO_FAVORITES, @"favorites action")
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action)
                                    {
                                        MovieEntity *movie = (MovieEntity *)[[DataManager dataManager] objectFromCoreDataWithValue:movieId withName:@"movieId" inEntity:@"MovieEntity"];
                                        movie.favorite = @(1);
                                        [[DataManager dataManager] saveContext];
                                        if(completionBlock){
                                            completionBlock();
                                        }
                                    }];
    
    UIAlertAction *removeAction = [UIAlertAction
                                      actionWithTitle:NSLocalizedString(REMOVE_WATCHED, @"Remove action")
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction *action)
                                      {
                                          [[DataManager dataManager] deleteMovieFromCoreDataWithId:movieId onCompletion:completionBlock];
                                          /*if(completionBlock){
                                              completionBlock();
                                          }*/
                                      }];
    
    UIAlertAction *unwatchedAction = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(MOVE_WANT_TO_WATCH, @"watched action")
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action)
                                    {
                                        MovieEntity *movie = (MovieEntity *)[[DataManager dataManager] objectFromCoreDataWithValue:movieId withName:@"movieId" inEntity:@"MovieEntity"];
                                        movie.status = @(UNWATCHED);
                                        [[DataManager dataManager] saveContext];
                                        if(completionBlock){
                                            completionBlock();
                                        }
                                    }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(CANCEL, @"cancel action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    
    [alertController addAction:unwatchedAction];
    [alertController addAction:favAction];
    [alertController addAction:removeAction];
    [alertController addAction:cancelAction];
    
    alertController.view.tintColor = [Util darkColor];
    return alertController;
}

-(UIAlertController *) editUnwatchedMovies :(NSInteger) movieId onCompletion: (CompletionBlock) completionBlock
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Edit List"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    alertController.modalTransitionStyle=UIModalPresentationOverCurrentContext;
    
    UIAlertAction *watchedAction = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(MOVE_WATCHED, @"watched action")
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action)
                                    {
                                        MovieEntity *movie = (MovieEntity *)[[DataManager dataManager] objectFromCoreDataWithValue:movieId withName:@"movieId" inEntity:@"MovieEntity"];
                                        movie.status = @(WATCHED);
                                        [[DataManager dataManager] saveContext];
                                        if(completionBlock){
                                            completionBlock();
                                        }
                                    }];
    
    UIAlertAction *removeAction = [UIAlertAction
                                      actionWithTitle:NSLocalizedString(REMOVE_UNWATCHED, @"Remove action")
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction *action)
                                      {
                                          [[DataManager dataManager] deleteMovieFromCoreDataWithId:movieId onCompletion:completionBlock];
                                          /*if(completionBlock){
                                              completionBlock();
                                          }*/
                                      }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(CANCEL, @"cancel action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    
    [alertController addAction:watchedAction];
    [alertController addAction:removeAction];
    [alertController addAction:cancelAction];
    
    alertController.view.tintColor = [Util darkColor];
    return alertController;
}

-(UIAlertController *) editFavoriteMovies: (NSInteger) movieId onCompletion: (CompletionBlock) completionBlock
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Edit List"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    alertController.modalTransitionStyle=UIModalPresentationOverCurrentContext;
    
    UIAlertAction *unwatchedAction = [UIAlertAction
                                      actionWithTitle:NSLocalizedString(REMOVE_FAVORITES, @"Remove action")
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction *action)
                                      {
                                          MovieEntity *movie = (MovieEntity *)[[DataManager dataManager] objectFromCoreDataWithValue:movieId withName:@"movieId" inEntity:@"MovieEntity"];
                                          movie.favorite = @(0);
                                          [[DataManager dataManager] saveContext];
                                          if(completionBlock){
                                              completionBlock();
                                          }
                                      }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(CANCEL, @"cancel action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    
    [alertController addAction:unwatchedAction];
    [alertController addAction:cancelAction];
    
    alertController.view.tintColor = [Util darkColor];
    return alertController;
}

+(MoviesUtil*) moviesUtil {
    @synchronized([MoviesUtil class]) {
        if (!_moviesUtil)
        {
            _moviesUtil = [[self alloc] init];
        }
        
        return _moviesUtil;
    }
    return nil;
}

+(id)alloc {
    @synchronized([MoviesUtil class])
    {
        NSAssert(_moviesUtil == nil, @"Attempted to allocate a second instance of a singleton.");
        _moviesUtil = [super alloc];
        return _moviesUtil;
    }
    return nil;
}

-(id)init
{
    self = [super init];
    
    return self;
}


@end
