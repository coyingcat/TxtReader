//
//  LSYReadModel.m
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYReadModel.h"

@implementation LSYReadModel
-(instancetype)initWithContent:(NSString *)content
{
    self = [super init];
    if (self) {
        _content = content;
        NSMutableArray *charpter = [NSMutableArray array];
        [LSYReadUtilites separateChapter:&charpter content:content];
        _chapters = charpter;
        _notes = [NSMutableArray array];
        _marks = [NSMutableArray array];
        _record = [[LSYRecordModel alloc] init];
        _record.chapterModel = charpter.firstObject;
        _record.chapterCount = _chapters.count;
        _marksRecord = [NSMutableDictionary dictionary];
        _type = ReaderTxt;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.marks forKey:@"marks"];
    [aCoder encodeObject:self.notes forKey:@"notes"];
    [aCoder encodeObject:self.chapters forKey:@"chapters"];
    [aCoder encodeObject:self.record forKey:@"record"];
    [aCoder encodeObject:self.resource forKey:@"resource"];
    [aCoder encodeObject:self.marksRecord forKey:@"marksRecord"];
    [aCoder encodeObject:@(self.type) forKey:@"type"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.marks = [aDecoder decodeObjectForKey:@"marks"];
        self.notes = [aDecoder decodeObjectForKey:@"notes"];
        self.chapters = [aDecoder decodeObjectForKey:@"chapters"];
        self.record = [aDecoder decodeObjectForKey:@"record"];
        self.resource = [aDecoder decodeObjectForKey:@"resource"];
        self.marksRecord = [aDecoder decodeObjectForKey:@"marksRecord"];
        self.type = [[aDecoder decodeObjectForKey:@"type"] integerValue];
    }
    return self;
}
+(void)updateLocalModel:(LSYReadModel *)readModel url:(NSURL *)url
{
    if (readModel != nil){
        NSString *key = [url.path lastPathComponent];
        NSKeyedArchiver *archiver= [[NSKeyedArchiver alloc] initRequiringSecureCoding: true];
        [archiver encodeObject: readModel forKey:key];
        
        [[NSUserDefaults standardUserDefaults] setObject: archiver.encodedData forKey:key];
    }
    
}



+(id)getLocalModelWithURL:(NSURL *)url
{
    NSString *key = [url.path lastPathComponent];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!data) {
        if ([[key pathExtension] isEqualToString:@"txt"]) {
            LSYReadModel *model = [[LSYReadModel alloc] initWithContent:[LSYReadUtilites encodeWithURL:url]];
            model.resource = url;
            [LSYReadModel updateLocalModel:model url:url];
            return model;
        }
        else{
            @throw [NSException exceptionWithName:@"FileException" reason:@"文件格式错误" userInfo:nil];
        }
        
    }
    NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc] initForReadingFromData: data error: nil];
    //主线程操作
    LSYReadModel *model = [unarchive decodeObjectForKey:key];
    return model;
}

+ (BOOL)supportsSecureCoding{
    return YES;
}


@end
