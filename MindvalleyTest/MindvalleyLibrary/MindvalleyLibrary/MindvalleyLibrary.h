//
//  MindvalleyLibrary.h
//  MindvalleyLibrary
//
//  Created by BlackNGreen on 06/01/18.
//  Copyright © 2018 Mindvalley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    kResourceTypeJSON,
    kResourceTypeXML,
    kResourceTypeAny
}ResourceType;

@interface MindvalleyLibrary : NSObject

-(void)loadImage:(NSString*)url into:(UIImageView *)imgView;
-(void)loadImage:(NSString*)url into:(UIImageView *)imgView withLoading:(BOOL)loading;
-(void)getResourceFromURL:(NSString *)url ofType:(ResourceType)type onCompletion:(void(^)(BOOL success, NSError *error,  id data))completion;

//cancel single download file
- (void)cancelDownloadForUrl:(NSString *)url;

//cancel all downloads
- (void)cancelAllDownloads;

// Get current downloads
- (NSArray *)currentDownloads;

+ (instancetype)shared;


@end
