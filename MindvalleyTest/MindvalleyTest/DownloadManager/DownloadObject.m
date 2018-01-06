//
//  DownloadObject.m
//  MindvalleyTest
//
//  Created by Divyam on 30/05/17.
//  Copyright © 2017 divyam. All rights reserved.
//

#import "DownloadObject.h"

@implementation DownloadObject

- (instancetype)initWithDownloadTask:(NSURLSessionDownloadTask *)downloadTask
                     completionBlock:(CompletionBlock)completionBlock{
    self = [super init];
    if (self) {
        self.downloadTask = downloadTask;
        self.completion = completionBlock;
    }
    return self;
}

@end
