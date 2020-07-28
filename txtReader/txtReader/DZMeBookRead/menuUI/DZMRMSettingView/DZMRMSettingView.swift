//
//  RMSettingView.swift

//
//  
//

import UIKit

/// 子视图高度
let READ_MENU_SETTING_SUB_VIEW_HEIGHT:CGFloat = SPACE_SA_50

/// settingView 内容高度
let READ_MENU_SETTING_VIEW_HEIGHT:CGFloat = READ_MENU_SETTING_SUB_VIEW_HEIGHT * 4

/// settingView 总高度(内容高度 + iphoneX情况下底部间距)
let READ_MENU_SETTING_VIEW_TOTAL_HEIGHT:CGFloat = SA(isX: READ_MENU_SETTING_VIEW_HEIGHT + SPACE_SA_20, READ_MENU_SETTING_VIEW_HEIGHT)

class RMSettingView: RMBaseView {
    
    /// 字体大小
    private var fontSizeView:RMFontSizeView!
    

    /// 翻页效果
    private var effectTypeView:RMEffectTypeView!
    
    /// 字体
    private var fontTypeView:RMFontTypeView!
    
    /// 间距
    private var spacingView:RMSpacingView!

    
    override init(read menu: ReadMenu) {
        super.init(read: menu)
    
        let x = SPACE_SA_15
        let w = ScreenWidth - SPACE_SA_30
        let h = READ_MENU_SETTING_SUB_VIEW_HEIGHT
        
 
        fontSizeView = RMFontSizeView(read: readMenu)
        addSubview(fontSizeView)
        fontSizeView.frame = CGRect(x: x, y: 0, width: w, height: h)
        
        effectTypeView = RMEffectTypeView(read: readMenu)
        addSubview(effectTypeView)
        effectTypeView.frame = CGRect(x: x, y: fontSizeView.frame.maxY, width: w, height: h)
        
        fontTypeView = RMFontTypeView(read: readMenu)
        addSubview(fontTypeView)
        fontTypeView.frame = CGRect(x: x, y: effectTypeView.frame.maxY, width: w, height: h)
        
 
        spacingView = RMSpacingView(read: readMenu)
        addSubview(spacingView)
        spacingView.frame = CGRect(x: x, y: fontTypeView.frame.maxY, width: w, height: h)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
