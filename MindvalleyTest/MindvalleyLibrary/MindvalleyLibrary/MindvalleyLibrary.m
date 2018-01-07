//
//  MindvalleyLibrary.m
//  MindvalleyLibrary
//
//  Created by BlackNGreen on 06/01/18.
//  Copyright © 2018 Mindvalley. All rights reserved.
//

#import "MindvalleyLibrary.h"
#import "DownloadManager.h"

@implementation MindvalleyLibrary


static MindvalleyLibrary *sharedManager = nil;

+ (instancetype)shared {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}


-(void)loadImage:(NSString*)url into:(UIImageView *)imgView{
    
    [[DownloadManager sharedManager] downloadFileForURL:url completionBlock:^(BOOL success, NSError *error, id data) {
        UIImage *img = [UIImage imageWithData:(NSData *)data];
        [imgView setImage:img];
    }];
}


-(void)loadImage:(NSString*)url into:(UIImageView *)imgView withLoading:(BOOL)loading{
    UIActivityIndicatorView *iv= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((imgView.frame.size.width/2)-14, (imgView.frame.size.height/2)-14, 29, 29)] ;
    if(loading){
        [iv setColor:[UIColor lightGrayColor]];
        [imgView addSubview:iv];
        [iv startAnimating];
    }
    [[DownloadManager sharedManager] downloadFileForURL:url completionBlock:^(BOOL success, NSError *error, id data) {
        if(loading){
            [iv removeFromSuperview];
        }
        UIImage *img = [UIImage imageWithData:(NSData *)data];
        [imgView setImage:img];
    }];
}


-(void)getResourceFromURL:(NSString *)url ofType:(ResourceType)type onCompletion:(void(^)(BOOL success, NSError *error,  id data))completion{
    
    [[DownloadManager sharedManager] downloadFileForURL:url completionBlock:^(BOOL success, NSError *error, id data) {
        if(error){
            completion(false,error,nil);
        }else{
            
            switch (type) {
                case kResourceTypeJSON:{
                    NSError *e = nil;
                    NSArray *json = [NSJSONSerialization JSONObjectWithData:(NSData *) data options: NSJSONReadingMutableContainers error: &e];
                    completion(true,nil,json);
                    break;
                }
                case kResourceTypeXML:{
                    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    completion(true,nil,responseString);
                    break;
                }
                case kResourceTypeAny:{
                    completion(true,nil,data);
                    break;
                }
                default:
                    completion(true,nil,data);
                    break;
            }
        }
    }];
}


- (void)cancelDownloadForUrl:(NSString *)url{
    [[DownloadManager sharedManager] cancelDownloadForUrl:url];
}


- (void)cancelAllDownloads{
    [[DownloadManager sharedManager] cancelAllDownloads];
}

- (NSArray *)currentDownloads{
    return [[DownloadManager sharedManager] currentDownloads];
}

@end
