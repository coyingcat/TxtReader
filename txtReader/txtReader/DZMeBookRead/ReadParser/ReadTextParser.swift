//
//  ReadTextParser.swift

//
//  
//

import UIKit

class ReadTextParser: NSObject {

    /// 异步解析本地链接
    ///
    /// - Parameters:
    ///   - url: 本地文件地址
    ///   - completion: 解析完成
    @objc class func resolve(url: URL, completion: @escaping ParserCompletion) {
        DispatchQueue.global().async{
            if let readModel = parser(book: url){
                DispatchQueue.main.async{
                    completion(readModel)
                }
            }
        }
    }
    
    /// 解析本地链接
    ///
    /// - Parameter url: 本地文件地址
    /// - Returns: 阅读对象
    private class func parser(book url:URL) ->ReadModel? {
        
        // 链接不为空, 且是本地文件路径
        let urlCheck = (url.absoluteString.isEmpty || !url.isFileURL) == false
        
        // 获取文件后缀名作为 bookName = bookID
        // bookID 为空
        guard urlCheck, let bookID = url.absoluteString.removingPercentEncoding?.lastPathComponent.deletingPathExtension , bookID.isEmpty == false else {
            return nil
        }
        
        
   //     guard bookID.exists == false else{
            // 存在， 则返回
     //       return ReadModel.model(bookID: bookID)
    //    }
     
        // 不存在， 则解析数据
        let content = ReadParserIMP.encode(url: url)
        
        // 解析失败
        guard content.isEmpty == false else { return nil }
        
        // 解析内容并获得章节列表
        let chapterListModels = parser(segments: bookID, content: content)
        
        // 解析内容失败
        guard chapterListModels.isEmpty == false else { return nil }
        // 阅读模型
        let readModel = ReadModel.model(bookID: bookID)
        
        // 记录章节列表
        readModel.chapterListModels = chapterListModels
        
        // 设置第一个章节为阅读记录
        readModel.recordModel?.modify(chapterID:  readModel.chapterListModels.first!.id, toPage: 0)
        
        // 保存
        readModel.keep()
        
        // 返回
        return readModel
        
    }
    
    /// 解析整本小说
    ///
    /// - Parameters:
    ///   - bookID: 小说ID
    ///   - content: 小说内容
    /// - Returns: 章节列表
    private class func parser(segments bookID:String, content:String) ->[ChapterBriefModel] {
        
        // 章节列表
        var chapterListModels = [ChapterBriefModel]()
        
        // 正则
        let parten = "第[0-9一二三四五六七八九十百千]*[章回].*"
        
        // 排版
        let content = ReadParserIMP.contentTypesetting(content: content)
        
        // 正则匹配结果
        var results = [NSTextCheckingResult]()
        
        // 开始匹配
        do{
            let regularExpression = try NSRegularExpression(pattern: parten, options: .caseInsensitive)
            
            results = regularExpression.matches(in: content, options: .reportCompletion, range: NSRange(location: 0, length: content.count))
            
        }catch{
            
            return chapterListModels
        }
        
        // 解析匹配结果
        
        
        guard results.isEmpty == false else {
            // 章节内容
            let chapterModel = ReadChapterModel(id: 1, in: bookID)
            
            // 章节名
            chapterModel.name = "开始"
            
            // 优先级
            chapterModel.priority = NSNumber(value: 0)
            
            // 内容
            chapterModel.content = TypeSetting.readSpace + content.removeSEHeadAndTail
            
            // 保存
            chapterModel.persist()
            
            // 添加章节列表模型
            chapterListModels.append(chapterModel.chapterList)
            return chapterListModels
        }
        
            
        // 章节数量
        let count = results.count
        
        // 记录最后一个Range
        var lastRange:NSRange!
        
        // 记录最后一个章节对象C
        var lastChapterModel:ReadChapterModel?
        
        // 有前言
        var isHavePreface = true
        
        // 遍历
        for i in 0...count {
            
            // 章节数量分析:
            // count + 1  = 匹配到的章节数量 + 最后一个章节
            // 1 + count + 1  = 第一章前面的前言内容 + 匹配到的章节数量 + 最后一个章节
            Log("章节总数: \(count + 1)  当前正在解析: \(i + 1)")
            
            var range = NSMakeRange(0, 0)
            
            var location = 0
            
            if i < count {
                
                range = results[i].range
                
                location = range.location
            }
            
            // 章节内容
            let chapterModel = ReadChapterModel(id: i + isHavePreface.val, in: bookID)
            
            // 优先级
            chapterModel.priority = NSNumber(value: i - isHavePreface.negVal)
            switch i {
            case 0:
                // 前言
                
                // 章节名
                chapterModel.name = "开始"
                
                // 内容
                chapterModel.content = content.substring(NSMakeRange(0, location))
                
                // 记录
                lastRange = range
                
                // 没有内容则不需要添加列表
                if chapterModel.content.isEmpty {
                    
                    isHavePreface = false
                    
                    continue
                }
            case count:
                // 结尾
                
                // 章节名
                chapterModel.name = content.substring(lastRange)
                
                // 内容(不包含章节名)
                chapterModel.content = content.substring(NSMakeRange(lastRange.rhs, content.count - lastRange.rhs))
            default:
                // 中间章节
                
                // 章节名
                chapterModel.name = content.substring(lastRange)
                
                // 内容(不包含章节名)
                chapterModel.content = content.substring(NSMakeRange(lastRange.rhs, location - lastRange.rhs))
            }
           
            
            // 章节开头双空格 + 章节纯内容
            chapterModel.content = TypeSetting.readSpace + chapterModel.content.removeSEHeadAndTail
            
            // 设置上一个章节ID
            chapterModel.previousChapterID = lastChapterModel?.id ?? nil
            
            // 设置下一个章节ID
            if i == (count - 1) { // 最后一个章节了
                chapterModel.nextChapterID = nil
            }
            else{
                lastChapterModel?.nextChapterID = chapterModel.id
            }
            
            // 保存
            chapterModel.persist()
            lastChapterModel?.persist()
            
            // 记录
            lastRange = range
            lastChapterModel = chapterModel
            
            // 通过章节内容生成章节列表
            chapterListModels.append(chapterModel.chapterList)
        }
        
        // 返回
        return chapterListModels
    }
    
}
