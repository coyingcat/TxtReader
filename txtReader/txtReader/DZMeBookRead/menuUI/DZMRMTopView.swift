//
//  RMTopView.swift

//
//  
//

import UIKit

/// topView 高度
let READ_MENU_TOP_VIEW_HEIGHT:CGFloat = NavgationBarHeight

class RMTopView: RMBaseView {
    
    /// 返回
    private var back = UIButton(type:.custom)
    
    /// 书签
    private var mark = UIButton(type:.custom)

    override init(read menu: ReadMenu) {
        super.init(read: menu)
        // 返回
        back.setImage(UIImage(named:"back")!.withRenderingMode(.alwaysTemplate), for: .normal)
        back.addTarget(self, action: #selector(clickBack), for: .touchUpInside)
        back.tintColor = READ_COLOR_MENU_COLOR
        addSubview(back)
        
        // 书签
        mark.contentMode = .center
        mark.setImage(UIImage(named:"mark")!.withRenderingMode(.alwaysTemplate), for: .normal)
        mark.addTarget(self, action: #selector(clickMark(_:)), for: .touchUpInside)
        mark.tintColor = READ_COLOR_MENU_COLOR
        addSubview(mark)
        updateMarkButton()
    }
    
    /// 点击返回
    @objc private func clickBack() {
        
        readMenu?.delegate?.readMenuClickBack(readMenu: readMenu)
    }
    
    /// 点击书签
    @objc private func clickMark(_ button:UIButton) {
        
        readMenu?.delegate?.readMenuClickMark(readMenu: readMenu, topView: self, markButton: button)
    }
    
    /// 检查是否存在书签
    func checkForMark() {
        
        mark.isSelected = (readMenu.vc.readModel.isExistMark() != nil)
        
        updateMarkButton()
    }
    
    /// 刷新书签按钮显示状态
    func updateMarkButton() {
        
        if mark.isSelected {
            mark.tintColor = READ_COLOR_MAIN
            
        }else{
            mark.tintColor = READ_COLOR_MENU_COLOR
            
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let y = StatusBarHeight
        
        let wh = NavgationBarHeight - y
        
        back.frame = CGRect(x: 0, y: y, width: wh, height: wh)
        
        mark.frame = CGRect(x: frame.size.width - wh, y: y, width: wh, height: wh)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
