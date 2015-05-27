//
//  ULFlickrImageCell.h
//  FlickrDemo
//
//  Created by allamaprabhu on 5/18/15.
//  Copyright (c) 2015 UrbanLadder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ULFlikrImageModel.h"

@interface ULFlickrImageCell : UICollectionViewCell
@property (nonatomic,weak) IBOutlet UIImageView *imageView;
@property (nonatomic,weak) ULFlikrImageModel *imageModal;
@end
