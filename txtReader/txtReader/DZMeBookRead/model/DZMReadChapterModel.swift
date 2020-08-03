//
//  ReadChapterModel.swift

//
//  
//

import UIKit

class ReadChapterModel: NSObject,NSCoding {
    
    /// 小说ID
    let bookID: String
    
    /// 章节ID
    let id: Int
    
    /// 上一章ID
    var previousChapterID: Int?
    
    /// 下一章ID
    var nextChapterID: Int?
    
    /// 章节名称
    var name:String!
    
    /// 内容
    /// 此处 content 是经过排版好且双空格开头的内容。
    /// 如果是网络数据需要确认是否处理好了,也就是在网络章节数据拿到之后, 使用排版接口进行排版并在开头加上双空格。(例如: TypeSetting.readSpace + 排版好的content )
    /// 排版内容搜索 contentTypesetting 方法
    var content:String!
    
    /// 优先级 (一般章节段落都带有排序的优先级 从0开始)
    var priority:NSNumber!
    
    /// 本章有多少页
    var pageCount = NSNumber(value: 0)
    
    /// 分页数据
    var pageModels = [ReadPageModel]()
    
    
    // MARK: 快捷获取
    
    /// 当前章节是否为第一个章节
    var isFirstChapter:Bool {
        previousChapterID == nil
    }
    
    /// 当前章节是否为最后一个章节
    var isLastChapter:Bool {
        nextChapterID == nil
    }
    
    /// 完整章节名称
    var fullName:String {
        name.readChapterName
    }
    
    /// 完整富文本内容
    var fullContent:NSAttributedString!
    
    
    var chapterList: ChapterBriefModel{
        let chapterListModel = ChapterBriefModel()
        chapterListModel.bookID = bookID
        chapterListModel.id = id
        chapterListModel.name = name
        return chapterListModel
    }
    
    /// 分页总高 (上下滚动模式使用)
    var pageTotalHeight:CGFloat {
        
        var pageTotalHeight:CGFloat = 0
        
        for pageModel in pageModels {
            
            pageTotalHeight += (pageModel.contentSize.height + pageModel.headTypeHeight)
        }
        
        return pageTotalHeight
    }
    
    
    // MARK: -- 更新字体
    
    /// 内容属性变化记录(我这里就只判断内容了字体属性变化了，标题也就跟着变化或者保存变化都无所谓了。如果有需求可以在加上比较标题属性变化)
    private var attributes = [NSAttributedString.Key: Any]()
    
    /// 更新字体
    func updateFont() {
        
        let tempAttributes = ReadConfigure.shared.attributes(isTitle: false, isPageing: true)
        
        if !NSDictionary(dictionary: attributes).isEqual(to: tempAttributes) {
            
            attributes = tempAttributes
            
            fullContent = fullContentAttrString()
            
            pageModels = ReadParserIMP.pageing(attrString: fullContent, rect: CGRect(origin: CGPoint.zero, size: READ_VIEW_RECT.size), isFirstChapter: isFirstChapter)
            
            pageCount = NSNumber(value: pageModels.count)
            
            persist()
        }
    }
    
    /// 完整内容排版
    private func fullContentAttrString() ->NSMutableAttributedString {
        
        let titleString = NSMutableAttributedString(string: fullName, attributes: ReadConfigure.shared.attributes(isTitle: true))
        
        let contentString = NSMutableAttributedString(string: content, attributes: ReadConfigure.shared.attributes(isTitle: false))
        
        titleString.append(contentString)
        
        return titleString
    }
    
    // MARK: 辅助功能
    
    /// 获取指定页码字符串
    func contentString(page: Int) ->String {
        pageModels[page].content.string
    }

    /// 获取指定页码富文本
    func contentAttributedString(page: Int) ->NSAttributedString {
        pageModels[page].showContent
    }
    
    /// 获取指定页开始坐标
    func locationFirst(page: Int) -> Int {
        pageModels[page].range.location
    }
    
    /// 获取指定页码末尾坐标
    func locationLast(page: Int) ->Int {
        let range = pageModels[page].range!
        return range.rhs
    }
    

    
    /// 获取存在指定坐标的页码
    func page(location: Int?) ->NSNumber {
        
        let count = pageModels.count
        guard let loc = location else {
            return NSNumber(value: 0)
        }
        for i in 0..<count {
            
            let range = pageModels[i].range!
            
            if loc < range.rhs {
                
                return NSNumber(value: i)
            }
        }
        
        return NSNumber(value: 0)
    }
    
    /// 保存
    func persist(){
        KeyedArchiver.archiver(folderName: bookID, fileName: String(id), object: self)
    }
    
    /// 是否存在章节内容
    class func isExist(bookID:String, chapterID: Int) ->Bool {
        KeyedArchiver.isExist(folderName: bookID, fileName: String(chapterID))
    }
    
    // MARK: 构造
    
    /// 获取章节对象,如果则创建对象返回
    
    var real: ReadChapterModel{
        if ReadChapterModel.isExist(bookID: bookID, chapterID: id) {
            let chapterModel = KeyedArchiver.unarchiver(folderName: bookID, fileName: String(id)) as! ReadChapterModel
            chapterModel.updateFont()
            return chapterModel
        }
        else{
            return self
        }
    }
    
    
    
    init(id chapter: Int, in key: String){
        bookID = key
        id = chapter
        
        super.init()
    }
        
    
    required init?(coder aDecoder: NSCoder) {
        bookID = aDecoder.decodeObject(forKey: "bookID") as! String
        
        id = aDecoder.decodeInteger(forKey: "id")
        
        super.init()
        
        
        
        previousChapterID = aDecoder.decodeObject(forKey: "previousChapterID") as? Int
        nextChapterID = aDecoder.decodeObject(forKey: "nextChapterID") as? Int
        
        name = aDecoder.decodeObject(forKey: "name") as? String
        
        priority = aDecoder.decodeObject(forKey: "priority") as? NSNumber
        
        content = aDecoder.decodeObject(forKey: "content") as? String
        
        fullContent = aDecoder.decodeObject(forKey: "fullContent") as? NSAttributedString
        
        pageCount = aDecoder.decodeObject(forKey: "pageCount") as! NSNumber
        
        pageModels = aDecoder.decodeObject(forKey: "pageModels") as! [ReadPageModel]
        
        attributes = aDecoder.decodeObject(forKey: "attributes") as? [NSAttributedString.Key:Any] ?? [:]
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(bookID, forKey: "bookID")
        
        aCoder.encode(id, forKey: "id")
        
        aCoder.encode(previousChapterID, forKey: "previousChapterID")
        
        aCoder.encode(nextChapterID, forKey: "nextChapterID");
        
        aCoder.encode(name, forKey: "name")
        
        aCoder.encode(priority, forKey: "priority")
        
        aCoder.encode(content, forKey: "content")
        
        aCoder.encode(fullContent, forKey: "fullContent")
        
        aCoder.encode(pageCount, forKey: "pageCount")
        
        aCoder.encode(pageModels, forKey: "pageModels")
        
        aCoder.encode(attributes, forKey: "attributes")
    }
    
  
}
