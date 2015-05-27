//
//  ULImageDownloadOperation.m
//  FlickrDemo
//
//  Created by allamaprabhu on 5/18/15.
//  Copyright (c) 2015 UrbanLadder. All rights reserved.
//

#import "ULImageDownloadOperation.h"
#import "ULFlikrImageModel.h"
#import "ULFileHelper.h"

@interface ULImageDownloadOperation ()
@property (nonatomic,weak)ULFlikrImageModel *currentImageModal;
@end

@implementation ULImageDownloadOperation
- (instancetype)initWithImageModal:(ULFlikrImageModel *)imageModal delegate:(id<ULImageDownloadDelegate>)del {
    self = [super init];
    if (self) {
        _currentImageModal = imageModal;
        _delegate = del;
    }
    return self;
}

- (void)main {
    //Perform synchronus download of image here
    if (self.currentImageModal.imageURL) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL  URLWithString:self.currentImageModal.imageURL]];
        NSURLResponse *urlResponse = nil;
        NSError *error = nil;
        NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)urlResponse;
        if (!imageData || error || (httpResponse.statusCode != 200)) {
            //Handle Error
        }
        else { //Success
            NSString *diskPath = [self generatedDiskPathForCurrentImageModal];
            if (![imageData writeToFile:diskPath atomically:YES]) {
                //hanlde error
            }
            //set disk image path to modal instance.
            _currentImageModal.imageDiskPath = diskPath;
            
            //Notify on main thread,Image download and writing to disk has been finished
            if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishImageDownloadFor:)]) {
                NSInvocationOperation *invokeOperation = [[NSInvocationOperation alloc] initWithTarget:self.delegate selector:@selector(didFinishImageDownloadFor:) object:self.currentImageModal];
                [[NSOperationQueue mainQueue] addOperation:invokeOperation];
            }
        }
    }
    else {
        //Hanlde error
    }
}

//Genrates disk image path from cloud URL.
//Images are named with last path componanat to avoid name collisions.

- (NSString *)generatedDiskPathForCurrentImageModal {
    NSString *imageName = [self.currentImageModal.imageURL lastPathComponent];
    NSString *resourceExtension = [self.currentImageModal.imageURL pathExtension];
    if (!imageName || ! resourceExtension) {
        //Hanlde Error
        return nil;
    }
    
    [self checkAndCreateImageCacheDirectory];
    NSString *dirPath = [ULFileHelper imageCacheDirectory];
    dirPath = [dirPath stringByAppendingPathComponent:imageName];
    return dirPath;
}


//Checks existance of Image cache directory
//If not,Creates one

- (void)checkAndCreateImageCacheDirectory {
    NSString *dirPath = [ULFileHelper imageCacheDirectory];
    NSLog(@"%@",dirPath);
    BOOL isDir = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir]) {
        //Create dir
        NSError *error = nil;
        BOOL status = [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error || !status) {
            //hanlde error
            return;
        }
        isDir = YES;
    }
    if (!isDir) {
        //hanlde error
        return;
    }
}
@end
