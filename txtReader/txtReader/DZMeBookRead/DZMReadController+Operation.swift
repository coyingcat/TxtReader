//
//  ReadController+Operation.swift

//
//  
//

import UIKit

extension ReadController {
    
    /// 获取指定阅读记录阅读页
    func getReadController(recordModel:ReadRecordModel!) ->ReadViewController? {
        
        if recordModel != nil {
            
            if ReadConfigure.shared.openLongPress {
                // 需要返回支持长按的控制器
                
                let controller = ReadLongPressViewController()
                
                controller.recordModel = recordModel
                
                controller.readModel = readModel
                
                return controller
                
            }else{
                // 无长按功能
                
                let controller = ReadViewController()
                
                controller.recordModel = recordModel
                
                controller.readModel = readModel
                
                return controller
            }
        }
        
        return nil
    }
    
    /// 获取当前阅读记录阅读页
    func getCurrentReadViewController(isUpdateFont:Bool = false) ->ReadViewController? {
        
        if ReadConfigure.shared.effectType != .scroll { // 滚动模式不需要创建
            
            if isUpdateFont {
                readModel.recordModel?.updateFont()
            }
            
            return getReadController(recordModel: readModel.recordModel?.copyModel)
        }
        
        return nil
    }
    
    /// 获取上一页控制器
    func getAboveReadViewController() ->UIViewController? {
        
        let recordModel = getAboveReadRecordModel(recordModel: readModel.recordModel)
        
        if recordModel == nil { return nil }
        
        return getReadController(recordModel: recordModel)
    }
    
    /// 获取仿真模式背面(只用于仿真模式背面显示)
    func getBackgroundController(recordModel:ReadRecordModel!, targetView:UIView? = nil) -> ReadViewBGController {
        
        let vc = ReadViewBGController()
        
        vc.recordModel = recordModel
        
        let targetView = targetView ?? getReadController(recordModel: recordModel)?.view
        
        vc.targetView = targetView
        
        return vc
    }
    
    
    /// 获取下一页控制器
    func getBelowReadViewController() ->UIViewController? {
        
        if let recordModel = getBelowReadRecordModel(recordModel: readModel.recordModel) {
            return getReadController(recordModel: recordModel)
        }
        else{
            return nil
        }
    }
    
    /// 跳转指定章节(指定页面)
    func goToChapter(chapterID: Int, toPage: Int = 0) {
        
        goToChapter(chapterID: chapterID, number: toPage, isLocation: false)
    }
    
    /// 跳转指定章节(指定坐标)
    func goToChapter(chapterID: Int, location: Int) {
        
        goToChapter(chapterID: chapterID, number: location, isLocation: true)
    }
    
    /// 跳转指定章节 number:页码或者坐标 isLocation:是页码(false)还是坐标(true)
    private func goToChapter(chapterID: Int, number: Int, isLocation: Bool) {
        
        // 复制阅读记录
        let recordModel = readModel.recordModel?.copyModel
        
        // 书籍ID
        guard let bookID = recordModel?.bookID else{
            return
        }
       
        // 检查是否存在章节内容
        // 存在
        if ReadChapterModel.isExist(bookID: bookID, chapterID: chapterID){
            if isLocation {
                
                // 坐标定位
                recordModel?.modifyLoc(chapterID: chapterID, location: number, isSave: false)
                
            }else{
                
                // 分页定位
                recordModel?.modify(chapterID: chapterID, toPage: number, isSave: false)
            }
            
            // 阅读阅读记录
            if let record = recordModel{
                update(read: record)
            }
            // 展示阅读
            creatPageController(displayController: getReadController(recordModel: recordModel))
            
        }

    }
    
    /// 获取当前记录上一页阅读记录
    func getAboveReadRecordModel(recordModel:ReadRecordModel!) ->ReadRecordModel? {
        
        // 阅读记录为空
        if recordModel.chapterModel == nil { return nil }
        
        // 复制
        let recordModel = recordModel.copyModel
        
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
    
    /// 获取当前记录下一页阅读记录
    func getBelowReadRecordModel(recordModel: ReadRecordModel!) -> ReadRecordModel?{
        
        // 阅读记录为空
        if recordModel.chapterModel == nil {
            return nil
        }
        
        // 复制
        let recordModel = recordModel.copyModel
        
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
    
    /// 更新阅读记录(左右翻页模式)
    func updateReadRecord(controller: ReadViewController) {
        if let record = controller.recordModel{
            update(read: record)
        }
    }
    
    /// 更新阅读记录(左右翻页模式)
    func update(read model:ReadRecordModel){
        readModel.recordModel = model
        
        readModel.recordModel?.save()
        
        Sand.readRecordCurrentChapterLocation = model.locationFirst
        
    }
}

