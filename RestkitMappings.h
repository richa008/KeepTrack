//
//  RestkitMappings.h
//  KeepTrack
//
//  Created by Deshmukh,Richa on 5/8/15.
//  Copyright (c) 2015 Richa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Restkit/RestKit.h>

@interface RestkitMappings : NSObject

+(RKObjectMapping *) movieSearchMappings;
+(RKObjectMapping *) movieDetailsMappings;
+(RKObjectMapping *) castMappings;
+(RKObjectMapping *) crewMappings;

+(RKObjectMapping *) tvSearchMappings;
+(RKObjectMapping *) tvDetailsMappings;

@end
