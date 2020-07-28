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
    var page = NSNumber(value: 0)
    
    
    // MARK: 快捷获取
    
    /// 当前记录分页模型
    var pageModel:ReadPageModel{
        chapterModel.pageModels[page.intValue]
    }
    
    /// 当前记录起始坐标
    var locationFirst:NSNumber{
        chapterModel.locationFirst(page: page.intValue)
    }
    
    /// 当前记录末尾坐标
    var locationLast:NSNumber{
        chapterModel.locationLast(page: page.intValue)
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
        page.intValue == 0
    }
    
    /// 当前记录是否为最后一页
    var isLastPage:Bool{
        page.intValue == (chapterModel.pageCount.intValue - 1)
    }
    
    /// 当前记录页码字符串
    var contentString:String{
        chapterModel.contentString(page: page.intValue)
    }
    
    /// 当前记录页码富文本
    var contentAttributedString:NSAttributedString {
        chapterModel.contentAttributedString(page: page.intValue)
    }
    
    /// 当前记录切到上一页
    func previousPage() {
        page = NSNumber(value: max(page.intValue - 1, 0))
    }
    
    /// 当前记录切到下一页
    func nextPage() {
        page = NSNumber(value: min(page.intValue + 1, chapterModel.pageCount.intValue - 1))
    }
    
    /// 当前记录切到第一页
    func firstPage() {
        page = NSNumber(value: 0)
    }
    
    /// 当前记录切到最后一页
    func lastPage() {
        page = NSNumber(value: chapterModel.pageCount.intValue - 1)
    }
    
    
    // MARK: 辅助
    
    /// 修改阅读记录为指定章节位置
    func modify(chapterModel:ReadChapterModel?, page: Int) {
        
        self.chapterModel = chapterModel
        
        self.page = NSNumber(value: page)
        
        save()
    }
    
    /// 修改阅读记录为指定章节位置
    func modifyLoc(chapterID:NSNumber!, location: Int, isSave:Bool = true) {
        
        if ReadChapterModel.isExist(bookID: bookID, chapterID: chapterID) {
            
            chapterModel = ReadChapterModel(id: chapterID, in: bookID).real
            
            page = chapterModel.page(location: location)
            
            if isSave { save() }
        }
    }
    
    /// 修改阅读记录为指定章节页码 (toPage == READ_LAST_PAGE 为当前章节最后一页)
    func modify(chapterID:NSNumber!, toPage: Int, isSave:Bool = true) {
        
        if ReadChapterModel.isExist(bookID: bookID, chapterID: chapterID) {
            
            chapterModel = ReadChapterModel(id: chapterID, in: bookID).real
            
            if (toPage == READ_LAST_PAGE) { lastPage()
                
            }else{ page = NSNumber(value: toPage) }
            
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
        
        KeyedArchiver.archiver(folderName: bookID, fileName: READ_KEY_RECORD, object: self)
    }
    
    

    
    // MARK: 构造
    
    /// 获取阅读记录对象,如果则创建对象返回
    class func model(notes bookID: String) -> ReadRecordModel {
        
        let recordModel: ReadRecordModel
        
        if bookID.exists{
            recordModel = KeyedArchiver.unarchiver(folderName: bookID, fileName: READ_KEY_RECORD) as! ReadRecordModel
            
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
        
        page = aDecoder.decodeObject(forKey: "page") as! NSNumber
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
}
