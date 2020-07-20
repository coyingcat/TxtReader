//
//  DZMReadController+EffectType.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

extension DZMReadController {

    // 创建阅读视图
    
    //  看到的内容是 ReadViewController
    func creatPageController(displayController:ReadViewController? = nil) {
        
        // 清理
        clearPageController()
        
        // 创建
        switch DZMReadConfigure.shared.effectType {
        case .simulation:
            // 仿真
            
            guard let displayCtrl = displayController else {
                return
            }
            
            // 创建
            let options = [UIPageViewController.OptionsKey.spineLocation : NSNumber(value: UIPageViewController.SpineLocation.min.rawValue)]
            
            pageViewController = UIPageViewController(transitionStyle: .pageCurl,navigationOrientation: .horizontal,options: options)
            
            pageViewController.delegate = self
            
            pageViewController.dataSource = self
            
            // 翻页背部带文字效果
            pageViewController.isDoubleSided = true
            
            contentView.insertSubview(pageViewController.view, at: 0)
            
            pageViewController.view.backgroundColor = UIColor.clear
            
            pageViewController.view.frame = contentView.bounds
            
            pageViewController.setViewControllers([displayCtrl], direction: .forward, animated: false, completion: nil)
        case .scroll:
            // 滚动
            scrollController = DZMReadViewScrollController()
            
            scrollController.vc = self
            
            contentView.insertSubview(scrollController.view, at: 0)
            
            scrollController.view.frame = contentView.bounds
            
            scrollController.view.backgroundColor = UIColor.clear
            
            addChild(scrollController)
        default:
             // 覆盖 无效果
            if displayController == nil { return }
            
            coverController = DZMCoverController()
            
            coverController!.delegate = self
            
            contentView.insertSubview(coverController.view, at: 0)
            
            coverController.view.frame = contentView.bounds
            
            coverController.view.backgroundColor = UIColor.clear
            
            coverController!.setController(displayController)
            
            if DZMReadConfigure.shared.effectType == .no {
                
                coverController!.openAnimate = false
            }
        }
        // 记录
        currentDisplayController = displayController
    }
    
    /// 清理所有阅读控制器
    func clearPageController() {
        
         currentDisplayController?.removeFromParent()
         currentDisplayController = nil
            
         pageViewController?.view.removeFromSuperview()
         
         pageViewController?.removeFromParent()
         
         pageViewController = nil
     
         
         coverController?.view.removeFromSuperview()
         
         coverController?.removeFromParent()
         
         coverController = nil
     
         
         scrollController?.view.removeFromSuperview()
         
         scrollController?.removeFromParent()
         
         scrollController = nil
        
    }
    
    /// 手动设置翻页(注意: 非滚动模式调用)
    func setViewController(displayController:ReadViewController!, isAbove:Bool, animated:Bool) {
        
        if displayController != nil {
            
            // 仿真
            if pageViewController != nil {
                
                let direction:UIPageViewController.NavigationDirection = isAbove ? .reverse : .forward
                
                pageViewController.setViewControllers([displayController, getBackgroundController(recordModel: displayController?.recordModel, targetView: displayController?.view)], direction: direction, animated: animated, completion: nil)
                
                return
            }
            
            // 覆盖 无效果
            if coverController != nil {
                
                coverController?.setController(displayController!, animated: animated, isAbove: isAbove)
                
                return
            }
            
            // 记录
            currentDisplayController = displayController
        }
    }
}





extension DZMReadController: DZMCoverControllerDelegate{
     
    // MARK: -- DZMCoverControllerDelegate
    
    /// 切换结果
    func coverController(_ coverController: DZMCoverController, currentController: UIViewController?, finish isFinish: Bool) {
        
        // 记录
        currentDisplayController = currentController as? ReadViewController
        
        // 更新阅读记录
        if let current = currentDisplayController{
            updateReadRecord(controller: current)
        }
        
    }
    
    /// 将要显示的控制器
    func coverController(_ coverController: DZMCoverController, willTransitionToPendingController pendingController: UIViewController?) {
        
        readMenu.showMenu(isShow: false)
    }
    
    /// 获取上一个控制器
    func coverController(_ coverController: DZMCoverController, getAboveControllerWithCurrentController currentController: UIViewController?) -> UIViewController? {
        
        return getAboveReadViewController()
    }
    
    /// 获取下一个控制器
    func coverController(_ coverController: DZMCoverController, getBelowControllerWithCurrentController currentController: UIViewController?) -> UIViewController? {
        
        return getBelowReadViewController()
    }
    
}

// MARK: -- UIPageViewControllerDelegate
   

extension DZMReadController: UIPageViewControllerDelegate{
   
    /// 切换结果
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // 记录
        currentDisplayController = pageViewController.viewControllers?.first as? ReadViewController
        
        // 更新阅读记录
        if let current = currentDisplayController{
            updateReadRecord(controller: current)
        }
        
    }
    
    /// 准备切换
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        readMenu.showMenu(isShow: false)
    }
    
    
    
}

// MARK: -- UIPageViewControllerDataSource

extension DZMReadController: UIPageViewControllerDataSource{
    /// 获取上一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // 翻页累计
        tempNumber -= 1
        
        // 获取当前页阅读记录
        var recordModel:DZMReadRecordModel? = (viewController as? ReadViewController)?.recordModel
        
        // 如果没有则从背面页面获取
        if recordModel == nil{
            recordModel = (viewController as? DZMReadViewBGController)?.recordModel
        }
        if abs(tempNumber) % 2 == 0 { // 背面
            recordModel = getAboveReadRecordModel(recordModel: recordModel)
            return getBackgroundController(recordModel: recordModel)
        }
        else{
             //   内容
            return getReadController(recordModel: recordModel)
        }
       
        
    }
    
    /// 获取下一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        tempNumber += 1
        
        // 获取当前页阅读记录
        var recordModel:DZMReadRecordModel? = (viewController as? ReadViewController)?.recordModel
        
        // 如果没有则从背面页面获取
        if recordModel == nil {
            
            recordModel = (viewController as? DZMReadViewBGController)?.recordModel
        }
        
        if abs(tempNumber) % 2 == 0 { // 背面
            return getBackgroundController(recordModel: recordModel)
        }
        else{
            // 内容
            recordModel = getBelowReadRecordModel(recordModel: recordModel)
            return getReadController(recordModel: recordModel)
        }
    }
}



