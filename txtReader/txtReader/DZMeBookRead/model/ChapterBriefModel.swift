//
//  ChapterBriefModel.swift

//
//  
//

import UIKit

class ChapterBriefModel: NSObject,NSCoding {
    
    /// 章节ID    
    var id: Int!

    /// 小说ID
    var bookID:String!
    
    /// 章节名称
    var name:String!
    
    // MARK: -- NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        id = aDecoder.decodeObject(forKey: "id") as? Int
        bookID = aDecoder.decodeObject(forKey: "bookID") as? String
        
        name = aDecoder.decodeObject(forKey: "name") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(bookID, forKey: "bookID")
        aCoder.encode(id, forKey: "id")
        
        aCoder.encode(name, forKey: "name")
    }
    
    init(_ dict:Any? = nil) {
        
        super.init()
        
        if dict != nil {
            setValuesForKeys(dict as! [String : Any])
            
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String){
        
        
    }
    
    
    
    override func value(forUndefinedKey key: String) -> Any? {
        
        return nil
    }
}
