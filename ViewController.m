//
//  ViewController.m
//  FlickrDemo
//
//  Created by allamaprabhu on 5/15/15.
//  Copyright (c) 2015 UrbanLadder. All rights reserved.
//

#import "ViewController.h"
#import "ULXMLParser.h"
#import "ULImageDownloadOperation.h"
#import "ULFlickrImageCell.h"
#import "ULFileHelper.h"

#define MAX_IMAGE_DOWNLOAD_OPERATION_COUNT 2
static NSString *feedURLString = @"https://api.flickr.com/services/feeds/photos_public.gne";
static NSString *cellIdentifier = @"ImageCell";

static NSString * const kDidFinishParsingNotification = @"kDidFinishParsingNotification";
@interface ViewController () <ULImageDownloadDelegate>
@property (nonatomic,strong) ULXMLParser *currentParser;
@property (nonatomic,strong) NSOperationQueue *parsingQueue;
@property (nonatomic,strong) NSOperationQueue *imageDownloadQueue;
@property (nonatomic,strong) NSArray *parsedData;
@property (nonatomic,strong) NSString *searchQuerry;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ULFlickrImageCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellIdentifier];
}

//Fetches data from provided tag in background.
//Customize MAX_IMAGE_DOWNLOAD_OPERATION_COUNT tos et number of concurrent tasks

- (void)fetchDataForProvidedTag {
    [self clearCache];
    
    NSURLComponents *componanats = [[NSURLComponents alloc] initWithString:feedURLString];
    NSString *querryParam = [NSString stringWithFormat:@"tags=%@",self.searchQuerry];
    [componanats setQuery:querryParam];
    NSURLRequest *request = [NSURLRequest requestWithURL:[componanats URL]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data,NSError *error){
        if (error) {
            //handle Error
        }
        else {
            //Handle response and data
            NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
            //Here I am deliberately using xml format,There seems to be some problem with json format.Json response for above API includes certain illigal characther hecne parsing fails.
            if (urlResponse.statusCode == 200 && [urlResponse.MIMEType isEqualToString:@"application/atom+xml"]) {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishParseData:) name:kDidFinishParsingNotification object:nil];
                
                self.parsingQueue = [NSOperationQueue new];
                ULXMLParser *parser = [[ULXMLParser alloc] initWithdata:data];
                [self.parsingQueue addOperation:parser];
            }
            else
            {
                //hanlde error
            }
        }
    }];
}
//Notification call back,Will be on main thread
-(void)didFinishParseData:(NSNotification *)notif {
    self.parsedData = [[notif userInfo] objectForKey:@"parsedData"];
    if ([self.parsedData count]) {
        self.imageDownloadQueue = [NSOperationQueue new];
        //I am setting it to 5,To avoid throttling bandwindth
        self.imageDownloadQueue.maxConcurrentOperationCount = MAX_IMAGE_DOWNLOAD_OPERATION_COUNT;
        for (ULFlikrImageModel *modal in self.parsedData) {
            ULImageDownloadOperation *operation = [[ULImageDownloadOperation alloc] initWithImageModal:modal delegate:self];
            [self.imageDownloadQueue addOperation:operation];
        }
    }
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark Image downlaoder delegate

//Image has been downloaded
//Relaod only necessary rows
- (void)didFinishImageDownloadFor:(ULFlikrImageModel *)modal {
    assert([NSThread mainThread]);
    NSUInteger index = [self.parsedData indexOfObject:modal];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

#pragma -mark Textfeild delgates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.searchQuerry = [textField.text copy];
    [textField endEditing:YES];
    [self fetchDataForProvidedTag];
    return YES;
}

#pragma -mark UICollectionViewDelegate
//Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //we assume its 1 for our current usecase
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.parsedData count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ULFlickrImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.imageModal = [self.parsedData objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
//Collectionview flow Delegates
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(140, 120);
}


//Clear past cache here.
- (void)clearCache{
    self.searchQuerry = @"";
    NSString *cacheDir = [ULFileHelper imageCacheDirectory];
    NSError *error = nil;
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:cacheDir isDirectory:&isDir]) {
        if (![[NSFileManager defaultManager] removeItemAtPath:cacheDir error:&error]) {
            //hanlde error
        }
    }
}
@end
