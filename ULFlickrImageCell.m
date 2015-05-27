//
//  ULFlickrImageCell.m
//  FlickrDemo
//
//  Created by allamaprabhu on 5/18/15.
//  Copyright (c) 2015 UrbanLadder. All rights reserved.
//

#import "ULFlickrImageCell.h"

@implementation ULFlickrImageCell
//This sets imageview's image.
- (void)setImageModal:(ULFlikrImageModel *)imageModal {
    if (_imageModal != imageModal) {
        _imageModal = imageModal;
    }
    //set the image for model path here
    self.imageView.image = [UIImage imageWithContentsOfFile:_imageModal.imageDiskPath];
}
@end
