//
//  DZMRMSettingView.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/18.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

/// 子视图高度
let READ_MENU_SETTING_SUB_VIEW_HEIGHT:CGFloat = SPACE_SA_50

/// settingView 内容高度
let READ_MENU_SETTING_VIEW_HEIGHT:CGFloat = READ_MENU_SETTING_SUB_VIEW_HEIGHT * 4

/// settingView 总高度(内容高度 + iphoneX情况下底部间距)
let READ_MENU_SETTING_VIEW_TOTAL_HEIGHT:CGFloat = SA(isX: READ_MENU_SETTING_VIEW_HEIGHT + SPACE_SA_20, READ_MENU_SETTING_VIEW_HEIGHT)

class DZMRMSettingView: DZMRMBaseView {
    
    /// 字体大小
    private var fontSizeView:DZMRMFontSizeView!
    

    /// 翻页效果
    private var effectTypeView:DZMRMEffectTypeView!
    
    /// 字体
    private var fontTypeView:DZMRMFontTypeView!
    
    /// 间距
    private var spacingView:DZMRMSpacingView!

    override init(frame: CGRect) { super.init(frame: frame) }
    
    override func addSubviews() {
        
        super.addSubviews()
        
        let x = SPACE_SA_15
        let w = ScreenWidth - SPACE_SA_30
        let h = READ_MENU_SETTING_SUB_VIEW_HEIGHT
        
 
        fontSizeView = DZMRMFontSizeView(readMenu: readMenu)
        addSubview(fontSizeView)
        fontSizeView.frame = CGRect(x: x, y: 0, width: w, height: h)
        
        effectTypeView = DZMRMEffectTypeView(readMenu: readMenu)
        addSubview(effectTypeView)
        effectTypeView.frame = CGRect(x: x, y: fontSizeView.frame.maxY, width: w, height: h)
        
        fontTypeView = DZMRMFontTypeView(readMenu: readMenu)
        addSubview(fontTypeView)
        fontTypeView.frame = CGRect(x: x, y: effectTypeView.frame.maxY, width: w, height: h)
        
 
        spacingView = DZMRMSpacingView(readMenu: readMenu)
        addSubview(spacingView)
        spacingView.frame = CGRect(x: x, y: fontTypeView.frame.maxY, width: w, height: h)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
