//
//  ReadRecordModel.swift

//
//  
//

import UIKit



class ReadRecordModel: NSObject,NSCoding {

    /// 小说ID
    var bookID:String!
    
    /// 当前记录的阅读章节
    var chapterModel:ReadChapterModel!
    
    /// 阅读到的页码(上传阅读记录到服务器时传当前页面的 location 上去,从服务器拿回来 location 在转成页码。精准回到上次阅读位置)
    var page:Int = 0
    
    
    // MARK: 快捷获取
    
    /// 当前记录分页模型
    var pageModel:ReadPageModel{
        chapterModel.pageModels[page]
    }
    
    /// 当前记录起始坐标
    var locationFirst: Int{
        chapterModel.locationFirst(page: page)
    }
    
    /// 当前记录末尾坐标
    var locationLast: Int{
        chapterModel.locationLast(page: page)
    }
    
    /// 当前记录是否为第一个章节
    var isFirstChapter:Bool{
        chapterModel.isFirstChapter
    }
    
    /// 当前记录是否为最后一个章节
    var isLastChapter:Bool{
        chapterModel.isLastChapter
    }
    
    /// 当前记录是否为第一页
    var isFirstPage:Bool{
        page == 0
    }
    
    /// 当前记录是否为最后一页
    var isLastPage:Bool{
        page == chapterModel.pageCount - 1
    }
    
    /// 当前记录页码字符串
    var contentString:String{
        chapterModel.contentString(page: page)
    }
    
    /// 当前记录页码富文本
    var contentAttributedString:NSAttributedString {
        chapterModel.contentAttributedString(page: page)
    }
    
    /// 当前记录切到上一页
    func previousPage() {
        page = max(page - 1, 0)
    }
    
    /// 当前记录切到下一页
    func nextPage() {
        page = min(page + 1, chapterModel.pageCount - 1)
    }
    
    /// 当前记录切到第一页
    func firstPage() {
        page = 0
    }
    
    /// 当前记录切到最后一页
    func lastPage() {
        page = chapterModel.pageCount - 1
    }
    
    
    // MARK: 辅助
    
    /// 修改阅读记录为指定章节位置
    func modify(chapterModel:ReadChapterModel?, page  p: Int) {
        
        self.chapterModel = chapterModel
        
        self.page = p
        
        save()
    }
    
    /// 修改阅读记录为指定章节位置
    func modifyLoc(chapterID: Int, location: Int, isSave:Bool = true) {
        
        if ReadChapterModel.isExist(bookID: bookID, chapterID: chapterID) {
            
            chapterModel = ReadChapterModel(id: chapterID, in: bookID).real
            
            page = chapterModel.page(location: location)
            
            if isSave { save() }
        }
    }
    
    /// 修改阅读记录为指定章节页码 (toPage == ReadingConst.lastPage 为当前章节最后一页)
    func modify(chapterID: Int, toPage: Int, isSave:Bool = true) {
        
        if ReadChapterModel.isExist(bookID: bookID, chapterID: chapterID) {
            
            chapterModel = ReadChapterModel(id: chapterID, in: bookID).real
            
            if (toPage == ReadingConst.lastPage) {
                lastPage()
            }
            else{
                page = toPage
            }
            if isSave { save() }
        }
    }
    
    /// 更新字体
    func updateFont(isSave:Bool = true) {
        
        if chapterModel != nil {
            
            chapterModel.updateFont()
            
            page = chapterModel.page(location: Sand.readRecordCurrentChapterLocation)
            
            if isSave { save() }
        }
    }
    
    /// 拷贝阅读记录
    var copyModel: ReadRecordModel{
        
        let recordModel = ReadRecordModel()
        
        recordModel.bookID = bookID
        
        recordModel.chapterModel = chapterModel
        
        recordModel.page = page
        
        return recordModel
    }
    
    /// 保存记录
    func save() {
        
        KeyedArchiver.archiver(folderName: bookID, fileName: PersistKey.readRecord, object: self)
    }
    
    

    
    // MARK: 构造
    
    /// 获取阅读记录对象,如果则创建对象返回
    class func model(notes bookID: String) -> ReadRecordModel {
        
        let recordModel: ReadRecordModel
        
        if bookID.exists{
            recordModel = KeyedArchiver.unarchiver(folderName: bookID, fileName: PersistKey.readRecord) as! ReadRecordModel
            
            recordModel.chapterModel.updateFont()
            
        }else{
            recordModel = ReadRecordModel()
            recordModel.bookID = bookID
        }
        
        return recordModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        bookID = aDecoder.decodeObject(forKey: "bookID") as? String
        
        chapterModel = aDecoder.decodeObject(forKey: "chapterModel") as? ReadChapterModel
        
        page = aDecoder.decodeInteger(forKey: "page")
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(bookID, forKey: "bookID")
        
        aCoder.encode(chapterModel, forKey: "chapterModel")
        
        aCoder.encode(page, forKey: "page")
    }
    
    init(_ dict:Any? = nil) {
        
        super.init()
        
        if dict != nil { setValuesForKeys(dict as! [String : Any]) }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
    
    
    
    
    /// 获取当前记录下一页阅读记录
    var getBelowReadRecordModel: ReadRecordModel?{
          
          // 阅读记录为空
          if chapterModel == nil {
              return nil
          }
          
          // 复制
          let recordModel = copyModel
          
          // 书籍ID
          // 章节ID
          guard let bookID = recordModel.bookID, let chapterID = recordModel.chapterModel.nextChapterID else{
              return nil
          }
          
          // 最后一章 最后一页
          if recordModel.isLastChapter, recordModel.isLastPage {
              
              Log("已经是最后一页了")
              
              return nil
          }
          
          // 最后一页
          if recordModel.isLastPage {
              
              // 检查是否存在章节内容
              if ReadChapterModel.isExist(bookID: bookID, chapterID: chapterID){
                  // 修改阅读记录
                  recordModel.modify(chapterID: chapterID, toPage: 0, isSave: false)
                  
              }
          }else{
              recordModel.nextPage()
          }
          
          return recordModel
      }
    
    
    
    /// 获取当前记录上一页阅读记录
    var getAboveReadRecordModel: ReadRecordModel?{
          
          // 阅读记录为空
          if chapterModel == nil { return nil }
          
          // 复制
          let recordModel = copyModel
          
          // 书籍ID
          // 章节ID
          guard let bookID = recordModel.bookID, let chapterID = recordModel.chapterModel.previousChapterID else{
              return nil
          }
          
          // 第一章 第一页
          if recordModel.isFirstChapter , recordModel.isFirstPage {
              
              Log("已经是第一页了")
              
              return nil
          }
          
          // 第一页
          if recordModel.isFirstPage {
              
              // 检查是否存在章节内容
              if ReadChapterModel.isExist(bookID: bookID, chapterID: chapterID) {
                  // 存在
                  // 修改阅读记录
                  recordModel.modify(chapterID: chapterID, toPage: ReadingConst.lastPage, isSave: false)
                  
              }else{
                  return nil
              }
              
          }else{
              recordModel.previousPage()
              
          }
          return recordModel
      }
      
    
}
