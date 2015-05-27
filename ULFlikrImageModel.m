//
//  ULFlikrImageModel.m
//  FlickrDemo
//
//  Created by allamaprabhu on 5/15/15.
//  Copyright (c) 2015 UrbanLadder. All rights reserved.
//

#import "ULFlikrImageModel.h"

@implementation ULFlikrImageModel
-(NSString *)description {
    return [NSString stringWithFormat:@"TITLE :%@,ID :%@,PUBLISHEDDATE :%@,UPDATEDATE :%@,TAKENDATE :%@,IMAGEURL :%@,DISK PATH : %@",self.title,self.resourceId,self.publishedDate,self.updatedDate,self.takenDate,self.imageURL,self.imageDiskPath];
}
@end
