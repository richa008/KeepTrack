//
//  TVSeriesUtil.m
//  KeepTrack
//
//  Created by Deshmukh,Richa on 6/3/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import "TVSeriesUtil.h"
#import "DataManager.h"
#import "TVSeriesEntity.h"
#import "Constants.h"

@implementation TVSeriesUtil

static TVSeriesUtil* _tvSeriesUtil = nil;

-(UIAlertController *) showAddTVOptions : (NSInteger) tvId onCompletion:(CompletionBlock)completionBlock
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
                                        [[DataManager dataManager] addTvSeriesToList:tvId withStatus :WATCHED onCompletion:completionBlock];
                                    }];
    
    UIAlertAction *unwatchedAction = [UIAlertAction
                                      actionWithTitle:NSLocalizedString(ADD_UNWATCHED, @"unwatched action")
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction *action)
                                      {
                                          NSLog(@"unwatched action");
                                          [[DataManager dataManager] addTvSeriesToList:tvId withStatus :UNWATCHED onCompletion:completionBlock];
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

-(UIAlertController *) editWatchedTv : (NSInteger) tvId onCompletion:(CompletionBlock)completionBlock
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Edit List"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    alertController.modalTransitionStyle=UIModalPresentationOverCurrentContext;
    
    UIAlertAction *unwatchedAction = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(MOVE_WANT_TO_WATCH, @"unwatched action")
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action)
                                    {
                                        TVSeriesEntity *tv = (TVSeriesEntity *)[[DataManager dataManager] objectFromCoreDataWithValue:tvId withName:@"tvId" inEntity:@"TVSeriesEntity"];
                                        tv.status = @(UNWATCHED);
                                        [[DataManager dataManager] saveContext];
                                        if(completionBlock){
                                            completionBlock();
                                        }
                                    }];
    
    UIAlertAction *favAction = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(ADD_TO_FAVORITES, @"favorites action")
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action)
                                    {
                                        TVSeriesEntity *tv = (TVSeriesEntity *)[[DataManager dataManager] objectFromCoreDataWithValue:tvId withName:@"tvId" inEntity:@"TVSeriesEntity"];
                                        tv.favorite = @(1);
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
                                          [[DataManager dataManager] deleteTvSeriesFromCoreDataWithId:tvId onCompletion:completionBlock];
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
    
    [alertController addAction:unwatchedAction];
    [alertController addAction:favAction];
    [alertController addAction:removeAction];
    [alertController addAction:cancelAction];
    
    alertController.view.tintColor = [Util darkColor];
    
    return alertController;
}

-(UIAlertController *) editUnwatchedTv :(NSInteger) tvId onCompletion:(CompletionBlock)completionBlock
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
                                        TVSeriesEntity *tv = (TVSeriesEntity *)[[DataManager dataManager] objectFromCoreDataWithValue:tvId withName:@"tvId" inEntity:@"TVSeriesEntity"];
                                        tv.status = @(WATCHED);
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
                                          [[DataManager dataManager] deleteTvSeriesFromCoreDataWithId:tvId onCompletion:completionBlock];
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

-(UIAlertController *) editFavoriteTv: (NSInteger) tvId onCompletion:(CompletionBlock)completionBlock
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
                                          TVSeriesEntity *tv = (TVSeriesEntity *)[[DataManager dataManager] objectFromCoreDataWithValue:tvId withName:@"tvId" inEntity:@"TVSeriesEntity"];
                                          tv.favorite = @(0);
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

+(TVSeriesUtil*) tvSeriesUtil {
    @synchronized([TVSeriesUtil class]) {
        if (!_tvSeriesUtil)
        {
            _tvSeriesUtil = [[self alloc] init];
        }
        
        return _tvSeriesUtil;
    }
    return nil;
}

+(id)alloc {
    @synchronized([TVSeriesUtil class])
    {
        NSAssert(_tvSeriesUtil == nil, @"Attempted to allocate a second instance of a singleton.");
        _tvSeriesUtil = [super alloc];
        return _tvSeriesUtil;
    }
    return nil;
}

-(id)init
{
    self = [super init];
    
    return self;
}

@end
