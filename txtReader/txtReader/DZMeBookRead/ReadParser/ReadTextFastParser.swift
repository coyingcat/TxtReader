//
//  ReadTextFastParser.swift

//
//  
//

import UIKit



typealias BookRange = [Int: NSRange]


typealias ChapterInfo = (chapters: [ChapterBriefModel], table : BookRange, stdTxt: String)



class ReadTextFastParser: NSObject {
    
    /// 异步解析本地链接
    ///
    /// - Parameters:
    ///   - url: 本地文件地址
    ///   - completion: 解析完成
    @objc class func parser(least url: URL, completion: @escaping ParserCompletion) {
        
        DispatchQueue.global().async{
            
            if let readModel = parser(url: url){
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
    private class func parser(url: URL) ->ReadModel? {
        
        // 链接不为空且是本地文件路径
        if url.absoluteString.isEmpty || !url.isFileURL { return nil }
        
        // 获取文件后缀名作为 bookName
        // bookName 作为 bookID
        let bookID = url.absoluteString.removingPercentEncoding?.lastPathComponent.deletingPathExtension ?? ""
        
        // bookID 为空
        if bookID.isEmpty { return nil }
       // guard bookID.exists == false else{
            
            // 存在
            // 返回
      //      return ReadModel.model(bookID: bookID)
            
  //      }
        
        // 不存在
        // 解析数据
        let content = ReadParserIMP.encode(url: url)
        
        // 解析失败
        if content.isEmpty { return nil }
        
        // 阅读模型
        let readModel = ReadModel.model(bookID: bookID)
        
        
        // 解析内容并获得章节列表
        guard let chapterInfo = parseFull(id: readModel.bookID, content: content) else {
            
             // 解析内容失败
            return nil
        }
        
        // 小说全文
        readModel.fullText = chapterInfo.stdTxt
        
        // 章节列表
        readModel.chapterListModels = chapterInfo.chapters
        
        // 章节内容范围
        readModel.bookRanges = chapterInfo.table
        
        // 首章
        let chapterListModel = readModel.chapterListModels.first!
        
        // 加载首章
        parsePart(readModel: readModel, chapterID: chapterListModel.id)
        
        // 设置第一个章节为阅读记录
        readModel.recordModel?.modify(chapterID:  chapterListModel.id,toPage: 0)
        
        // 保存
        readModel.keep()
        
        // 返回
        return readModel
    
    }
    
    /// 解析整本小说
    ///
    /// - Parameters:
    ///   - readModel: readModel
    ///   - content: 小说内容
    private class func parseFull(id key: String, content plainTxt:String) -> ChapterInfo? {
        
        // 章节列表
        var chapterListModels = [ChapterBriefModel]()
        
        // 章节范围列表 [章节ID:[章节优先级:章节内容Range]]
        var ranges = BookRange()
        
        // 正则
        let parten = "第[0-9一二三四五六七八九十百千]*[章回].*"
        
        // 排版
        let contentFormatted = ReadParserIMP.contentTypesetting(content: plainTxt)
        
        // 正则匹配结果
        var results = [NSTextCheckingResult]()
        
        // 开始匹配
        do{
            let regularExpression:NSRegularExpression = try NSRegularExpression(pattern: parten, options: .caseInsensitive)
            
            results = regularExpression.matches(in: contentFormatted, options: .reportCompletion, range: NSRange(location: 0, length: contentFormatted.count))
            
        }
        catch{
            return nil
            
        }
        
        // 解析匹配结果
        if !results.isEmpty {
            
            // 章节数量
            let count = results.count
            
            // 记录最后一个Range
            var lastRange:NSRange!
            
            // 有前言
            var isHavePreface = true
            
            // 遍历
            for i in 0...count {
                
                // 章节数量分析:
                // count + 1  = 匹配到的章节数量 + 最后一个章节
                // 1 + count + 1  = 第一章前面的前言内容 + 匹配到的章节数量 + 最后一个章节
                // Log("章节总数: \(count + 1)  当前正在解析: \(i + 1)")
                
                var range = NSMakeRange(0, 0)
                
                var location = 0
                
                if i < count {
                    
                    range = results[i].range
                    
                    location = range.location
                }
                
                // 章节列表
                let chapterListModel = ChapterBriefModel()
                
                // 书ID
                chapterListModel.bookID = key
                
                // 章节ID
                // 优先级
                chapterListModel.id = i + NSNumber(value: isHavePreface).intValue
                
                if i == 0 { // 前言
                    
                    // 章节名
                    chapterListModel.name = "开始"
                    
                    // 内容Range
                    ranges[chapterListModel.id] = NSMakeRange(0, location)
                    
                    // 内容
                    let content = contentFormatted.substring(NSMakeRange(0, location))
                    
                    // 记录
                    lastRange = range
                    
                    // 没有内容则不需要添加列表
                    if content.isEmpty {
                        
                        isHavePreface = false
                        
                        continue
                    }
                    
                }else if i == count { // 结尾
                    
                    // 章节名
                    chapterListModel.name = contentFormatted.substring(lastRange)
                    
                    // 内容Range
                    ranges[chapterListModel.id] =  NSMakeRange(lastRange.rhs, contentFormatted.count - lastRange.rhs)
                    
                }else { // 中间章节
                    
                    // 章节名
                    chapterListModel.name = contentFormatted.substring(lastRange)
                    
                    // 内容Range
                    ranges[chapterListModel.id] =  NSMakeRange(lastRange.rhs, location - lastRange.rhs)
                }
                
                // 记录
                lastRange = range
                
                // 通过章节内容生成章节列表
                chapterListModels.append(chapterListModel)
            }
            
        }
        else{
            
            // 章节列表
            let chapterListModel = ChapterBriefModel()
            
            // 章节名
            chapterListModel.name = "开始"
            
            // 书ID
            chapterListModel.bookID = key
            
            // 章节ID
            // 优先级
            chapterListModel.id = 1
            // 内容Range
            ranges[chapterListModel.id] = NSMakeRange(0, contentFormatted.count)
            
            // 添加章节列表模型
            chapterListModels.append(chapterListModel)
            
            
        }
        return (chapterListModels, ranges, contentFormatted)
    }
    
    /// 获取单个指定章节
    @discardableResult
    class func parsePart(readModel: ReadModel, chapterID: Int, isUpdateFont:Bool = true) ->ReadChapterModel? {
        
        // 获得章节优先级\ 章节内容Range
        
         // 章节内容范围\ 章节内容Range
        if let rangeSpan = readModel.bookRanges[chapterID]{
            
            // 当前优先级
            let priority = chapterID - 1
            
            // 当前章节
            let chapterListModel = readModel.chapterListModels[priority]
            
            /// 第一个章节
            let isFirstChapter:Bool = (priority == 0)
            
            /// 最后一个章节
            let isLastChapter:Bool = (priority == (readModel.chapterListModels.count - 1))
            
            // 上一个章节ID
            let previousChapterID: Int? = isFirstChapter ? nil : readModel.chapterListModels[priority - 1].id
            
            // 下一个章节ID
            let nextChapterID: Int? = isLastChapter ? nil : readModel.chapterListModels[priority + 1].id
            
            // 章节内容
            let chapterModel = ReadChapterModel(id: chapterListModel.id, in: chapterListModel.bookID)
            
            // 章节名
            chapterModel.name = chapterListModel.name
        
            // 上一个章节ID
            chapterModel.previousChapterID = previousChapterID
            
            // 下一个章节ID
            chapterModel.nextChapterID = nextChapterID
            
            // 章节内容
            chapterModel.content = TypeSetting.readSpace + readModel.fullText.substring(rangeSpan).removeSEHeadAndTail

            // 保存
            if isUpdateFont {
                chapterModel.updateFont()
                
            }
            else{
                chapterModel.persist()
                
            }
            
            // 返回
            return chapterModel
        }
        else{
            return nil
        }
        
    }
}
