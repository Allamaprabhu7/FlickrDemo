//
//  ULImageDownloadOperation.h
//  FlickrDemo
//
//  Created by allamaprabhu on 5/18/15.
//  Copyright (c) 2015 UrbanLadder. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ULFlikrImageModel;
@protocol ULImageDownloadDelegate <NSObject>
@required
- (void)didFinishImageDownloadFor:(ULFlikrImageModel *)modal;
@end

@interface ULImageDownloadOperation : NSOperation
@property(nonatomic,weak)id <ULImageDownloadDelegate>delegate;
- (instancetype)initWithImageModal:(ULFlikrImageModel *)imageModal delegate:(id<ULImageDownloadDelegate>)del;
@end
