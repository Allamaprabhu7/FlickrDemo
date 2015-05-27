//
//  ULXMLParser.m
//  FlickrDemo
//
//  Created by allamaprabhu on 5/15/15.
//  Copyright (c) 2015 UrbanLadder. All rights reserved.
//

#import "ULXMLParser.h"

@implementation ULXMLParser
- (instancetype)initWithdata:(NSData *)data {
    self = [super init];
    if (self) {
        _data = [data copy];
        _currentImageModal = nil;
        _currentParsedCharacterData = [[NSMutableString alloc] init];
        _imagesList = [NSMutableArray array];
    }
    return self;
}

- (void)main {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:_data];
    parser.delegate = self;
    [parser parse];
}



static NSString * const kEntryTag = @"entry";
static NSString * const ktitleTag = @"title";
static NSString * const kResourceIDTag = @"id";
static NSString * const kPublishedDateTag = @"published";
static NSString * const kUpdatedDateTag = @"updated";
static NSString * const kDateTakenTag = @"dc:date.Taken";
static NSString * const kLinkTag    = @"link";


- (void)parserDidStartDocument:(NSXMLParser *)parser {
    
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self postNoticicationOverMainThread];
}

- (void)postNoticicationOverMainThread
{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(postNoticicationOverMainThread) withObject:nil waitUntilDone:NO];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kDidFinishParsingNotification" object:self userInfo:@{@"parsedData":_imagesList}];
    }
}

// sent when the parser finds an element start tag.
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:kEntryTag]) {
        _currentImageModal = [[ULFlikrImageModel alloc] init];
    }
    if ([elementName isEqualToString:kLinkTag]) {
        NSString *relativeLink = [attributeDict objectForKey:@"rel"];
        if ([relativeLink isEqualToString:@"enclosure"]) {
            NSString *imageUrl = [attributeDict objectForKey:@"href"];
            _currentImageModal.imageURL = imageUrl;
        }
    }
    else if ([elementName isEqualToString:ktitleTag] || [elementName isEqualToString:kResourceIDTag]  || [elementName isEqualToString:kPublishedDateTag] || [elementName isEqualToString:kUpdatedDateTag]) {
        _shouldParseString = YES;
        //Set this to empty string after every elemnt start
        [_currentParsedCharacterData setString:@""];
    }
}

// sent when an end tag is encountered. The various parameters are supplied as above.
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:kEntryTag]) {
        [_imagesList addObject:_currentImageModal];
    }
    else if ([elementName isEqualToString:ktitleTag]) {
        _currentImageModal.title = _currentParsedCharacterData;
    }
    else if ([elementName isEqualToString:kResourceIDTag]) {
        _currentImageModal.resourceId = _currentParsedCharacterData;
    }
    else if ([elementName isEqualToString:kPublishedDateTag]) {
        _currentImageModal.publishedDate = _currentParsedCharacterData;
    }
    else if ([elementName isEqualToString:kUpdatedDateTag]) {
        _currentImageModal.updatedDate = _currentParsedCharacterData;
    }
    else if ([elementName isEqualToString:kDateTakenTag]) {
        _currentImageModal.takenDate  = _currentParsedCharacterData;
    }
    _shouldParseString = NO;
}

// This returns the string of the characters encountered thus far. You may not necessarily get the longest character run. The parser reserves the right to hand these to the delegate as potentially many calls in a row to -parser:foundCharacters:
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (_shouldParseString) {
        [_currentParsedCharacterData  appendString:string];
    }
}

@end
