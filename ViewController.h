//
//  ViewController.h
//  FlickrDemo
//
//  Created by allamaprabhu on 5/15/15.
//  Copyright (c) 2015 UrbanLadder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak) IBOutlet UITextField *searchFeild;
@property (nonatomic,weak) IBOutlet UICollectionView *collectionView;
@end

