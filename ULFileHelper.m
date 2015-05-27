//
//  ULFileHelper.m
//  FlickrDemo
//
//  Created by allamaprabhu on 5/18/15.
//  Copyright (c) 2015 UrbanLadder. All rights reserved.
//

#import "ULFileHelper.h"

@implementation ULFileHelper
//Could be moved to /Library/Cache
+ (NSString *)documentsDirectory {
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [directories lastObject];
}

+ (NSString *)imageCacheDirectory {
    NSString *documentsDir = [ULFileHelper documentsDirectory];
    return [documentsDir stringByAppendingPathComponent:@"ImageCache"];
}

@end
