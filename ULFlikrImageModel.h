//
//  ULFlikrImageModel.h
//  FlickrDemo
//
//  Created by allamaprabhu on 5/15/15.
//  Copyright (c) 2015 UrbanLadder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ULFlikrImageModel : NSObject
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *resourceId;
@property(nonatomic,strong) NSString *publishedDate;
@property(nonatomic,strong) NSString *updatedDate;
@property(nonatomic,strong) NSString *takenDate;
@property(nonatomic,strong) NSString *imageURL;
@property(nonatomic,strong) NSString *imageDiskPath;
@end
