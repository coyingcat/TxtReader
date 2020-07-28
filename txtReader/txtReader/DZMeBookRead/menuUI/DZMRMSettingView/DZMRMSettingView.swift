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
    private
    lazy var fontSizeView = RMFontSizeView(read: readMenu)
    

    /// 翻页效果
    private
    lazy var effectTypeView = RMEffectTypeView(read: readMenu)
    
    /// 字体
    private
    lazy var fontTypeView = RMFontTypeView(read: readMenu)
    
    /// 间距
    private
    lazy var spacingView = RMSpacingView(read: readMenu)
    
    override init(read menu: ReadMenu) {
        super.init(read: menu)
    
        let x = SPACE_SA_15
        let w = ScreenWidth - SPACE_SA_30
        let h = READ_MENU_SETTING_SUB_VIEW_HEIGHT
        
        addSubview(fontSizeView)
        fontSizeView.frame = CGRect(x: x, y: 0, width: w, height: h)
        
        addSubview(effectTypeView)
        effectTypeView.frame = CGRect(x: x, y: fontSizeView.frame.maxY, width: w, height: h)
        
        addSubview(fontTypeView)
        fontTypeView.frame = CGRect(x: x, y: effectTypeView.frame.maxY, width: w, height: h)
        
        addSubview(spacingView)
        spacingView.frame = CGRect(x: x, y: fontTypeView.frame.maxY, width: w, height: h)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
