//
//  KeyedArchiver.swift

//
//  
//

import UIKit

class KeyedArchiver: NSObject {
    
    /// 归档文件
    class func archiver(folderName:String, fileName:String, object:AnyObject) {
        
        var path = Sand.readDocumentDirectoryPath + "/\(PersistKey.readFolder)/\(folderName)"
        
        if creat_file(path: path) { // 创建文件夹成功或者文件夹存在
            
            path += "/\(fileName)"
            
            NSKeyedArchiver.archiveRootObject(object, toFile: path)
        }
    }
    
    /// 解档文件
    class func unarchiver(folderName:String, fileName:String) ->AnyObject? {
        
        let path = Sand.readDocumentDirectoryPath + "/\(PersistKey.readFolder)/\(folderName)/\(fileName)"
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: path) as AnyObject?
    }
    
    /// 删除归档文件
    class func remove(folderName:String!, fileName:String? = nil) ->Bool {
        
        var path = Sand.readDocumentDirectoryPath + "/\(PersistKey.readFolder)/\(folderName!)"
        
        if fileName != nil , !fileName!.isEmpty { path += "/\(fileName!)" }
        
        do{
            try FileManager.default.removeItem(atPath: path)
            
            return true
            
        }catch{
            return false
        }
        
        
    }
    
    /// 清空归档文件
    class func clear() ->Bool {
        let path = Sand.readDocumentDirectoryPath + "/\(PersistKey.readFolder)"
        do{
            try FileManager.default.removeItem(atPath: path)
            return true
        }catch{
            return false
        }
    }
    
    /// 是否存在归档文件
    class func isExist(folderName:String, fileName:String? = nil) ->Bool {
        var path = Sand.readDocumentDirectoryPath + "/\(PersistKey.readFolder)/\(folderName)"
        if let name = fileName, !name.isEmpty {
            path += "/\(name)"
        }
        return FileManager.default.fileExists(atPath: path)
    }
    
    /// 创建文件夹,如果存在则不创建
    private class func creat_file(path:String) ->Bool {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) { return true }
        do{
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return true
        }catch{
            return false
        }
    }
}
