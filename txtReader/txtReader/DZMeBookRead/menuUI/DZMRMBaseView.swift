//
//  RMBaseView.swift

//
//  
//

import UIKit

class RMBaseView: UIView {

    /// 菜单对象
    weak var readMenu:ReadMenu!
    
    /// 系统初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = READ_COLOR_MENU_BG_COLOR
    }
    
    /// 初始化
    convenience init(readMenu:ReadMenu!) {
        
        self.init(frame: CGRect.zero)
        
        self.readMenu = readMenu

    }
  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
