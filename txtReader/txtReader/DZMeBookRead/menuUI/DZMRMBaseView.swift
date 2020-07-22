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
    override init(frame: CGRect) { super.init(frame: frame) }
    
    /// 初始化
    convenience init(readMenu:ReadMenu!) {
        
        self.init(frame: CGRect.zero)
        
        self.readMenu = readMenu
        
        addSubviews()
    }
    
    func addSubviews() {
        
        backgroundColor = READ_COLOR_MENU_BG_COLOR
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
