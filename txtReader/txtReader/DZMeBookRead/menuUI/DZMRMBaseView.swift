//
//  RMBaseView.swift

//
//  
//

import UIKit

class RMBaseView: UIView {

    /// 菜单对象
    weak var readMenu: ReadMenu!
    
 
    /// 初始化
    init(read menu: ReadMenu) {
        readMenu = menu
        super.init(frame: CGRect.zero)
        
        backgroundColor = READ_COLOR_MENU_BG_COLOR
    }
  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
