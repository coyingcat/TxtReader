//
//  ReadModel.swift

//
//  
//

import UIKit




class ReadModel: NSObject,NSCoding {

    /// 小说ID
    let bookID:String
    /// 当前阅读记录
    var recordModel:ReadRecordModel?
    
    /// 书签列表
    var markModels = [ReadMarkModel]()
    
    /// 章节列表
    var chapterListModels = [ChapterBriefModel]()
    
    
    // MARK: 快速进入
    
    /// 本地小说全文
    var fullText:String!
    
    
    
    //  仅用于 ReadTextFastParser
    /// 章节内容范围数组      [    章节ID/章节优先级          :       章节内容 Range     ]
    var bookRanges: BookRange!
    
    
    // MARK: 辅助
    
    /// 保存
    func keep() {
        
        recordModel?.save()
        
        KeyedArchiver.archiver(folderName: bookID, fileName: PersistKey.readObject, object: self)
    }
    
  
    
    
    // MARK: 构造
    
    /// 获取阅读对象,如果则创建对象返回
    class func model(bookID: String) ->ReadModel {
           let readModel: ReadModel
           if bookID.exists{
               readModel = KeyedArchiver.unarchiver(folderName: bookID, fileName: PersistKey.readObject) as! ReadModel
               
           }else{
               readModel = ReadModel(key: bookID)
           }
           // 获取阅读记录
           readModel.recordModel = ReadRecordModel.model(notes: bookID)
           return readModel
    }
    
    
    
    init(key bID: String) {
        bookID = bID
        super.init()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        bookID = aDecoder.decodeObject(forKey: "bookID") as! String
        super.init()
        
        chapterListModels = aDecoder.decodeObject(forKey: "chapterListModels") as! [ChapterBriefModel]
        
        markModels = aDecoder.decodeObject(forKey: "markModels") as! [ReadMarkModel]
        
        fullText = aDecoder.decodeObject(forKey: "fullText") as? String
        
        bookRanges = aDecoder.decodeObject(forKey: "ranges") as? BookRange
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(bookID, forKey: "bookID")
        aCoder.encode(chapterListModels, forKey: "chapterListModels")
        
        aCoder.encode(markModels, forKey: "markModels")
        
        aCoder.encode(fullText, forKey: "fullText")
        
        aCoder.encode(bookRanges, forKey: "ranges")
    }
    
}






extension ReadModel{
    
    /// 计算总进度
    func progress(readTotal recordModel:ReadRecordModel!) ->Float {
        
        // 当前阅读进度
        var progress:Float = 0
        
        // 临时检查
        if recordModel == nil { return progress }
        
        if recordModel.isLastChapter, recordModel.isLastPage { // 最后一章最后一页
            
            // 获得当前阅读进度
            progress = 1.0
            
        }else{
            
            // 当前章节在所有章节列表中的位置
            let chapterIndex = Float(recordModel.chapterModel.priority)
            
            // 章节总数量
            let chapterCount = Float(chapterListModels.count)
            
            // 阅读记录首位置
            let locationFirst = Float(recordModel.locationFirst)
            
            // 阅读记录内容长度
            let fullContentLength = Float(recordModel.chapterModel.fullContent.length)
            
            // 获得当前阅读进度
            progress = chapterIndex/chapterCount + (locationFirst / fullContentLength)/chapterCount
        }
        
        // 返回
        return progress
    }
}
