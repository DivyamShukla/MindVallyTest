//
//  CacheManager.m
//  MindvalleyTest
//
//  Created by Divyam on 30/05/17.
//  Copyright © 2017 divyam. All rights reserved.
//

#import "CacheManager.h"

/*
 * Cache a maximum of 100 data
 */
#define CACHE_COUNT_LIMIT 100

/**
 * The size in bytes of data is used as the cost, so this sets a cost limit of 10MB.
 */
#define CACHE_TOTAL_COST_LIMIT 10 * 1024 * 1024


static CacheManager *sharedManager = nil;

@interface CacheManager ()
@property(nonatomic,strong)NSCache *cache;

@end

@implementation CacheManager


+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cache = [[NSCache alloc] init];
        self.cache.countLimit = CACHE_COUNT_LIMIT;
        self.cache.totalCostLimit = CACHE_TOTAL_COST_LIMIT;
        [self.cache setEvictsObjectsWithDiscardedContent:YES];
        }
    return self;
}

- (void)setCache:(id)obj forKey:(NSString*)key{
    if(obj)
        [self.cache setObject:obj forKey:key];
}

- (id)getCacheForKey:(NSString *)key{
    return [self.cache objectForKey:key];
}


- (BOOL)checkCacheForKey:(NSString *)key{
    return [self getCacheForKey:key] != nil ? YES : NO;
}

- (void)clearCacheForKey:(NSString *)key{
    [self.cache removeObjectForKey:key];
}

- (void)clearAllCache{
    [self.cache removeAllObjects];
}


@end
