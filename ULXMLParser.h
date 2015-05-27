//
//  ULXMLParser.h
//  FlickrDemo
//
//  Created by allamaprabhu on 5/15/15.
//  Copyright (c) 2015 UrbanLadder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ULFlikrImageModel.h"

@interface ULXMLParser : NSOperation <NSXMLParserDelegate>
{
    @private
    NSData *__strong _data;
    ULFlikrImageModel *__strong _currentImageModal;
    NSMutableString *__strong _currentParsedCharacterData;
    BOOL _shouldParseString;
    NSMutableArray *_imagesList;
}
- (instancetype)initWithdata:(NSData *)data;
@end
