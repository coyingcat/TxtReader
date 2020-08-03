//
//  ReadModel+Mark.swift

//
//  
//

import UIKit

extension ReadModel {

    /// 添加书签,默认使用当前阅读记录!
    func insetMark(recordModel:ReadRecordModel? = nil) {
        
        let recordModel = (recordModel ?? self.recordModel)!
        
        let markModel = ReadMarkModel()
        
        markModel.bookID = recordModel.bookID
        
        markModel.chapterID = recordModel.chapterModel.id
        
        if recordModel.pageModel.isHomePage {
            
            markModel.name = "(无章节名)"
            
            markModel.content = bookID
            
        }else{
            
            markModel.name = recordModel.chapterModel.name
            
            markModel.content = recordModel.contentString.removeSEHeadAndTail.removeEnterAll
        }
        
        markModel.time = NSNumber(value: Timer1970())
        
        markModel.location = recordModel.locationFirst
        
        if markModels.isEmpty {
            
            markModels.append(markModel)
            
        }else{
            
            markModels.insert(markModel, at: 0)
        }
        
        keep()
    }
    
    /// 移除当前书签
    @discardableResult
    func removeMark(index: Int) ->Bool {
        
        markModels.remove(at: index)
        
        keep()
        
        return true
    }
    
    /// 移除当前书签
    @discardableResult
    func removeMark(recordModel:ReadRecordModel? = nil) ->Bool {
        
        let recordModel = (recordModel ?? self.recordModel)!
        
        let markModel = isExistMark(recordModel: recordModel)
        
        if let mark = markModel, let index = markModels.firstIndex(of: mark){
            return removeMark(index: index)
        }
        
        return false
    }
    
    /// 是否存在书签
    func isExistMark(recordModel:ReadRecordModel? = nil) ->ReadMarkModel? {
        
        if markModels.isEmpty { return nil }
        
        let recordModel = (recordModel ?? self.recordModel)!
        
        let locationFirst = recordModel.locationFirst
        
        let locationLast = recordModel.locationLast
        
        for markModel in markModels {
            
            if markModel.chapterID == recordModel.chapterModel.id, markModel.location >= locationFirst, markModel.location < locationLast{
                return markModel
            }
        }
        
        return nil
    }
}
