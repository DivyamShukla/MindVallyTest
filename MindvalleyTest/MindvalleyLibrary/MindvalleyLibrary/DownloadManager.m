//
//  DownloadManager.m
//  MindvalleyTest
//
//  Created by Divyam on 30/05/17.
//  Copyright © 2017 divyam. All rights reserved.
//

#import "DownloadManager.h"
#import "DownloadObject.h"
#import "CacheManager.h"


@interface DownloadManager () <NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSMutableDictionary *downloads;

@end

@implementation DownloadManager


 static DownloadManager *sharedManager = nil;

+ (instancetype)sharedManager {
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        NSURLSessionConfiguration *sessionConfiguration =  [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[[NSBundle mainBundle] bundleIdentifier]];
        
        self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
        
        self.downloads = [NSMutableDictionary new];
    }
    return self;
}



#pragma mark - Downloading...

- (void)downloadFileForURL:(NSString *)urlString
           completionBlock:(void(^)(BOOL success, NSError *error, id data))completionBlock{
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    if([[CacheManager sharedManager] checkCacheForKey:urlString]){
        
        NSData *data = [[CacheManager sharedManager] getCacheForKey:urlString];
        
        completionBlock (YES,nil,data);
        
    }
    
    
    else if (![self fileDownloadCompletedForUrl:urlString]) {
        NSLog(@"File is downloading!");
        
        // increase download count
        
        DownloadObject *downloadObject = [self.downloads objectForKey:urlString];
        downloadObject.requestCount ++;
        [self.downloads setObject:downloadObject forKey:urlString];
        
        
    } else {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSessionDownloadTask *downloadTask;
        downloadTask = [self.session downloadTaskWithRequest:request];
        
        DownloadObject *downloadObject = [[DownloadObject alloc] initWithDownloadTask:downloadTask  completionBlock:completionBlock];
        downloadObject.requestCount = 1;
        
        [self.downloads addEntriesFromDictionary:@{urlString:downloadObject}];
        [downloadTask resume];
    }
}



- (void)cancelDownloadForUrl:(NSString *)url {
    DownloadObject *download = [self.downloads objectForKey:url];
    if (download) {
        
        if(download.requestCount ==1){
            [download.downloadTask cancel];
            [self.downloads removeObjectForKey:url];
            if (download.completion) {
                download.completion(NO,nil,nil);
            }
        }else{
            download.requestCount--;
             [self.downloads setObject:download forKey:url];
        }
    }
}

- (void)cancelAllDownloads {
    [self.downloads enumerateKeysAndObjectsUsingBlock:^(id key, DownloadObject *download, BOOL *stop) {
        if (download.completion) {
            download.completion(NO,nil,nil);
        }
        [download.downloadTask cancel];
        [self.downloads removeObjectForKey:key];
    }];
}

- (NSArray *)currentDownloads {
    NSMutableArray *currentDownloads = [NSMutableArray new];
    [self.downloads enumerateKeysAndObjectsUsingBlock:^(id key, DownloadObject *download, BOOL *stop) {
        [currentDownloads addObject:download.downloadTask.originalRequest.URL.absoluteString];
    }];
    return currentDownloads;
}

#pragma mark - NSURLSession Delegate

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
}







- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    
    NSError *error;
    
    
    NSString *fileIdentifier = downloadTask.originalRequest.URL.absoluteString;
    DownloadObject *download = [self.downloads objectForKey:fileIdentifier];
    
    BOOL success = YES;
    
    
    
    if ([downloadTask.response isKindOfClass:[NSHTTPURLResponse class]]) {
        
        NSInteger statusCode = [(NSHTTPURLResponse*)downloadTask.response statusCode];
        if (statusCode != 200) {
            NSLog(@"ERROR: HTTP status code %@", @(statusCode));
            success = NO;
        }
    }
    
    if (success) {
        
        // Move downloaded item from tmp directory to te caches directory
        // (not synced with user's iCloud documents)
        if (error) {
            NSLog(@"ERROR: %@", error);
        }
    }
    
    if (download.completion) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            NSData *data = [NSData dataWithContentsOfURL:location];
            CacheManager *cache = [CacheManager sharedManager];
            [cache setCache:data forKey:fileIdentifier];

            download.completion(success, error,data);
        });
    }
    // remove object from the download
    [self.downloads removeObjectForKey:fileIdentifier];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        NSLog(@"ERROR: %@", error);
        
        NSString *fileIdentifier = task.originalRequest.URL.absoluteString;
        DownloadObject *download = [self.downloads objectForKey:fileIdentifier];
        
        if (download.completion) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                download.completion(NO,error,nil);
            });
        }
        
        // remove object from the download
        [self.downloads removeObjectForKey:fileIdentifier];
    }
}



#pragma mark - File Management



- (BOOL)fileDownloadCompletedForUrl:(NSString *)fileIdentifier {
    BOOL retValue = YES;
    DownloadObject *download = [self.downloads objectForKey:fileIdentifier];
    if (download) {
        // downloads are removed once they finish
        retValue = NO;
    }
    return retValue;
}

- (BOOL)isFileDownloadingForUrl:(NSString *)fileIdentifier {
    return [self isFileDownloadingForUrl:fileIdentifier
                       completionBlock:nil];
}



- (BOOL)isFileDownloadingForUrl:(NSString *)fileIdentifier
                completionBlock:(void(^)(BOOL completed ,NSError *error , id data))completionBlock {
    BOOL retValue = NO;
    DownloadObject *download = [self.downloads objectForKey:fileIdentifier];
    
    if (download) {
        if (completionBlock) {
            download.completion = completionBlock;
        }
        
        retValue = YES;
    }
    return retValue;
}



#pragma mark - Background download

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    // Check if all download tasks have been finished.
    [session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        if ([downloadTasks count] == 0) {
            if (self.backgroundTransferCompletionHandler != nil) {
                // Copy locally the completion handler.
                void(^completionHandler)() = self.backgroundTransferCompletionHandler;
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Call the completion handler to tell the system that there are no other background transfers.
                    completionHandler();
                    // Show a local notification when all downloads are over.
                }];
                
                // Make nil the backgroundTransferCompletionHandler.
                self.backgroundTransferCompletionHandler = nil;
            }
        }
    }];
}


@end
