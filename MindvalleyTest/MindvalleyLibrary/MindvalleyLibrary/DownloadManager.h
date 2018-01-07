//
//  DownloadManager.h
//  MindvalleyTest
//
//  Created by Divyam on 30/05/17.
//  Copyright © 2017 divyam. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DownloadManager : NSObject

@property (nonatomic, strong) void(^backgroundTransferCompletionHandler)();


// Download data from URl
- (void)downloadFileForURL:(NSString *)urlString
           completionBlock:(void(^)(BOOL success, NSError *error,  id data))completionBlock;

//cancel single download file
- (void)cancelDownloadForUrl:(NSString *)url;

//cancel all downloads
- (void)cancelAllDownloads;

// Get current downloads
- (NSArray *)currentDownloads;

+ (instancetype)sharedManager;

@end
