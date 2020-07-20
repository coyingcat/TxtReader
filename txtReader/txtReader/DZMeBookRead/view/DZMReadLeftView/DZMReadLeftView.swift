//
//  DZMReadLeftView.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

/// leftView 宽高度
let READ_LEFT_VIEW_WIDTH:CGFloat = SPACE_SA_335


/// leftView headerView 高度
let READ_LEFT_HEADER_VIEW_HEIGHT:CGFloat = SPACE_SA_50

class DZMReadLeftView: UIView {

    // 功能栏
    private var segmentedControl = DZMSegmentedControl(frame: CGRect(x: 0, y: SA(isX: StatusBarHeight, 0), width: READ_LEFT_VIEW_WIDTH, height: READ_LEFT_HEADER_VIEW_HEIGHT))
    
    // 分割线
    private lazy var spaceLine = SpaceLine(self, COLOR_230_230_230)
    
    // 目录
    private(set) var catalogView = DZMReadCatalogView()
    
    // 书签
    private(set) var markView = DZMReadMarkView()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        isHidden = true
        // 工具栏
        
        segmentedControl.delegate = self
        segmentedControl.normalFont = FONT_SA_14
        segmentedControl.normalColor = COLOR_145_145_145
        segmentedControl.selectFont = FONT_SA_14
        segmentedControl.selectColor = READ_COLOR_MAIN
        segmentedControl.sliderColor = READ_COLOR_MAIN
        segmentedControl.sliderWidth = SPACE_SA_30
        segmentedControl.sliderHeight = SPACE_SA_2
        addSubview(segmentedControl)
        segmentedControl.reloadTitles(["目录","书签"])
        
        // 分割线
        
        spaceLine.frame = CGRect(x: 0, y: segmentedControl.frame.maxY, width: READ_LEFT_VIEW_WIDTH, height: SPACE_LINE)
        
        // 目录
        addSubview(catalogView)
        catalogView.frame = CGRect(x: 0, y: spaceLine.frame.maxY, width: READ_LEFT_VIEW_WIDTH, height: ScreenHeight - spaceLine.frame.maxY)
        
        // 书签
        addSubview(markView)
        markView.frame = catalogView.frame
        
        // 更新当前UI
        updateUI()
    }
    
    /// 刷新UI 例如: 日夜间可以根据需求判断修改目录背景颜色,文字颜色等等
    func updateUI() {
        
        // 日夜间切换修改
        if DZMUserDefaults.bool(READ_KEY_MODE_DAY_NIGHT) {
            
            spaceLine.backgroundColor = COLOR_230_230_230.withAlphaComponent(0.2)
            
            backgroundColor = COLOR_46_46_46
            
        }else{
            
            spaceLine.backgroundColor = COLOR_230_230_230
            
            backgroundColor = UIColor.white
        }
        
        // 刷新分割线颜色(如果不需要刷新分割线颜色可以去掉,目前我是做了日夜间修改分割线颜色的操作)
        catalogView.tableView.reloadData()
        markView.tableView.reloadData()
    }
    
 
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}



extension DZMReadLeftView: DZMSegmentedControlDelegate{
    
    
    // MARK: DZMSegmentedControlDelegate
    func segmentedControl(_ segmentedControl: DZMSegmentedControl, click index: Int) {
         
         UIView.animate(withDuration: READ_AD_TIME) { [weak self] () in
             
             if index == 0 { // 显示目录
                 
                 self?.bringSubviewToFront(self!.catalogView)
                 self?.catalogView.alpha = 1
                 self?.markView.alpha = 0
                 
             }else{ // 显示书签
                 
                 self?.bringSubviewToFront(self!.markView)
                 self?.catalogView.alpha = 0
                 self?.markView.alpha = 1
             }
         }
     }
    
}
