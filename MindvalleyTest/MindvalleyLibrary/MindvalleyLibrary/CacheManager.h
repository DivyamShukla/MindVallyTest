//
//  CacheManager.h
//  MindvalleyTest
//
//  Created by Divyam on 30/05/17.
//  Copyright © 2017 divyam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

+ (instancetype)sharedManager;
- (void)setCache:(id)obj forKey:(NSString*)key;
- (id)getCacheForKey:(NSString *)key;
- (BOOL)checkCacheForKey:(NSString *)key;
- (void)clearCacheForKey:(NSString *)key;
- (void)clearAllCache;

@end
