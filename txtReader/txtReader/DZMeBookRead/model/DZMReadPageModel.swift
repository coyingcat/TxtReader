//
//  ReadPageModel.swift

//
//  
//

import UIKit

class ReadPageModel: NSObject,NSCoding {

    // MARK: 常用属性
    
    /// 当前页内容
    var content:NSAttributedString!
    
    /// 当前页范围
    var pageRange:NSRange!
    
    /// 当前页序号
    var page: Int = 0
    
    
    // MARK: 滚动模式使用
    
    /// 根据开头类型返回开头高度 (目前主要是滚动模式使用)
    var headTypeHeight:CGFloat = 0
    
    /// 当前内容Size (目前主要是(滚动模式 || 长按模式)使用)
    var contentSize = CGSize.zero
    
    /// 当前内容头部类型 (目前主要是滚动模式使用)
    private
    var headTypeIndex: Int = 0
    
    /// 当前内容头部类型 (目前主要是滚动模式使用)
    var headType: PageHeadType? {
        set{
            if let n = newValue{
                headTypeIndex = n.rawValue
            }
        }
        get{
            PageHeadType(rawValue: headTypeIndex)
        }
    }
    
    /// 当前内容总高(cell 高度)
    var cellHeight: CGFloat{
        
        // 内容高度 + 头部高度
        contentSize.height + headTypeHeight
    }
    
    
    // MARK: 快捷获取
    
    /// 书籍首页
    var isHomePage:Bool {
        pageRange.location == TypeSetting.readBookHomePage
    }
    
    /// 获取显示内容(考虑可能会变换字体颜色的情况)
    var showContent: NSAttributedString{
        
        let textColor = ReadConfigure.shared.textColor
        let tempShowContent = NSMutableAttributedString(attributedString: content)
        tempShowContent.addAttributes([.foregroundColor : textColor], range: NSMakeRange(0, content.length))
        return tempShowContent
    }
    
    // MARK: -- NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        content = aDecoder.decodeObject(forKey: "content") as? NSAttributedString
        
        pageRange = aDecoder.decodeObject(forKey: "range") as? NSRange
        
        page = aDecoder.decodeInteger(forKey: "page")
        
        headTypeHeight = aDecoder.decodeObject(forKey: "headTypeHeight") as! CGFloat
        if let sizeVal = aDecoder.decodeObject(forKey: "contentSize") as? NSValue{
            contentSize = sizeVal.cgSizeValue
        }
        
        headTypeIndex = aDecoder.decodeInteger(forKey: "headTypeIndex")
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(content, forKey: "content")
        
        aCoder.encode(pageRange, forKey: "range")
        
        aCoder.encode(page, forKey: "page")
        
        aCoder.encode(headTypeHeight, forKey: "headTypeHeight")
        let sizeVal = NSValue(cgSize: contentSize)
        aCoder.encode(sizeVal, forKey: "contentSize")
        
        aCoder.encode(headTypeIndex, forKey: "headTypeIndex")
    }
    
    init(_ dict:Any? = nil) {
        
        super.init()
        
        if dict != nil { setValuesForKeys(dict as! [String : Any]) }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
