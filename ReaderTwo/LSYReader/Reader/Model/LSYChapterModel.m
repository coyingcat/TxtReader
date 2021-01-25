//
//  LSYChapterModel.m
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYChapterModel.h"
#import "LSYReadConfig.h"
#import "LSYReadParser.h"

//#include <vector>

@interface LSYChapterModel ()
@property (nonatomic,strong) NSMutableArray *pageArray;
@end

@implementation LSYChapterModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageArray = [NSMutableArray array];
    }
    return self;
}


-(void)setContent:(NSString *)content
{
    _content = content;
    if (_type == ReaderTxt) {
         [self paginateWithBounds:CGRectMake(LeftSpacing, TopSpacing, [UIScreen mainScreen].bounds.size.width-LeftSpacing-RightSpacing, [UIScreen mainScreen].bounds.size.height-TopSpacing-BottomSpacing)];
    }
    
}
-(void)updateFont{
    
        [self paginateWithBounds:CGRectMake(LeftSpacing, TopSpacing, [UIScreen mainScreen].bounds.size.width-LeftSpacing-RightSpacing, [UIScreen mainScreen].bounds.size.height-TopSpacing-BottomSpacing)];
    
    
}
-(void)paginateWithBounds:(CGRect)bounds
{
    [_pageArray removeAllObjects];
    NSAttributedString *attrString;
    CTFramesetterRef frameSetter;
    CGPathRef path;
    NSMutableAttributedString *attrStr;
    attrStr = [[NSMutableAttributedString  alloc] initWithString:self.content];
    NSDictionary *attribute = [LSYReadParser parserAttribute:[LSYReadConfig shareInstance]];
    [attrStr setAttributes:attribute range:NSMakeRange(0, attrStr.length)];
    attrString = [attrStr copy];
    frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    path = CGPathCreateWithRect(bounds, NULL);
    int currentOffset = 0;
    int currentInnerOffset = 0;
    BOOL hasMorePages = YES;
    // 防止死循环，如果在同一个位置获取CTFrame超过2次，则跳出循环
    int preventDeadLoopSign = currentOffset;
    int samePlaceRepeatCount = 0;
    
    while (hasMorePages) {
        if (preventDeadLoopSign == currentOffset) {
            
            ++samePlaceRepeatCount;
            
        } else {
            
            samePlaceRepeatCount = 0;
        }
        
        if (samePlaceRepeatCount > 1) {
            // 退出循环前检查一下最后一页是否已经加上
            if (_pageArray.count == 0) {
                [_pageArray addObject:@(currentOffset)];
            }
            else {
                
                NSUInteger lastOffset = [[_pageArray lastObject] integerValue];
                
                if (lastOffset != currentOffset) {
                    [_pageArray addObject:@(currentOffset)];
                }
            }
            break;
        }
        
        [_pageArray addObject:@(currentOffset)];
        
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentInnerOffset, 0), path, NULL);
        CFRange range = CTFrameGetVisibleStringRange(frame);
        if ((range.location + range.length) != attrString.length) {
            
            currentOffset += range.length;
            currentInnerOffset += range.length;
            
        } else {
            // 已经分完，提示跳出循环
            hasMorePages = NO;
        }
        if (frame) CFRelease(frame);
    }
    
    CGPathRelease(path);
    CFRelease(frameSetter);
    _pageCount = _pageArray.count;
}
-(NSString *)stringOfPage:(NSUInteger)index
{
    NSUInteger local = [_pageArray[index] integerValue];
    NSUInteger length;
    if (index<self.pageCount-1) {
        length=  [_pageArray[index+1] integerValue] - [_pageArray[index] integerValue];
    }
    else{
        length = _content.length - [_pageArray[index] integerValue];
    }
    return [_content substringWithRange:NSMakeRange(local, length)];
}
-(id)copyWithZone:(NSZone *)zone
{
    LSYChapterModel *model = [[LSYChapterModel allocWithZone:zone] init];
    model.content = self.content;
    model.title = self.title;
    model.pageCount = self.pageCount;
    model.pageArray = self.pageArray;
    model.epubImagePath = self.epubImagePath;
    model.type = self.type;
    model.epubString = self.epubString;
    return model;
    
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeInteger:self.pageCount forKey:@"pageCount"];
    [aCoder encodeObject:self.pageArray forKey:@"pageArray"];
    [aCoder encodeObject:self.epubImagePath forKey:@"epubImagePath"];
    [aCoder encodeObject:@(self.type) forKey:@"type"];
    [aCoder encodeObject:self.epubContent forKey:@"epubContent"];
    [aCoder encodeObject:self.chapterpath forKey:@"chapterpath"];
    [aCoder encodeObject:self.html forKey:@"html"];
    [aCoder encodeObject:self.epubString forKey:@"epubString"];
    /**
     @property (nonatomic,copy) NSArray *epubframeRef;
     @property (nonatomic,copy) NSString *epubImagePath;
     @property (nonatomic,copy) NSArray <LSYImageData *> *imageArray;
    
     */
//    [aCoder encodeObject:self.epubframeRef forKey:@"epubframeRef"];
//    [aCoder encodeObject:self.epubImagePath forKey:@"epubImagePath"];
    
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _content = [aDecoder decodeObjectForKey:@"content"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.pageCount = [aDecoder decodeIntegerForKey:@"pageCount"];
        self.pageArray = [aDecoder decodeObjectForKey:@"pageArray"];
        self.type = [[aDecoder decodeObjectForKey:@"type"] integerValue];
        self.epubImagePath = [aDecoder decodeObjectForKey:@"epubImagePath"];
        self.epubContent = [aDecoder decodeObjectForKey:@"epubContent"];
        self.chapterpath = [aDecoder decodeObjectForKey:@"chapterpath"];
        self.html = [aDecoder decodeObjectForKey:@"html"];
        self.epubString = [aDecoder decodeObjectForKey:@"epubString"];
//        self.epubframeRef = [aDecoder decodeObjectForKey:@"epubframeRef"];
        
    }
    return self;
}
@end

@implementation LSYImageData

@end
