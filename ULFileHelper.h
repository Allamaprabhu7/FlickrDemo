//
//  ULFileHelper.h
//  FlickrDemo
//
//  Created by allamaprabhu on 5/18/15.
//  Copyright (c) 2015 UrbanLadder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ULFileHelper : NSObject
+ (NSString *)imageCacheDirectory;
+ (NSString *)documentsDirectory;
@end
