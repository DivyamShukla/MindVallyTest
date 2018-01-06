//
//  DownloadObject.h
//  MindvalleyTest
//
//  Created by Divyam on 30/05/17.
//  Copyright © 2017 divyam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionBlock)(BOOL success, NSError *error, id data);

@interface DownloadObject : NSObject



@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;

@property (copy, nonatomic) CompletionBlock completion;

@property (assign) int requestCount;

- (instancetype)initWithDownloadTask:(NSURLSessionDownloadTask *)downloadTask
                     completionBlock:(CompletionBlock)completionBlock;
@end
