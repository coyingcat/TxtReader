//
//  RMFuncView.swift

//
//  
//

import UIKit

class RMFuncView: RMBaseView {

    /// 目录
    private var catalogue:UIButton!
    
    /// 设置
    private var setting:UIButton!

    
    override init(frame: CGRect) { super.init(frame: frame) }
    
    override func addSubviews() {
        
        super.addSubviews()
        
        backgroundColor = UIColor.clear
        
        // 目录
        catalogue = UIButton(type:.custom)
        catalogue.setImage(UIImage(named:"bar_0")?.withRenderingMode(.alwaysTemplate), for: .normal)
        catalogue.addTarget(self, action: #selector(clickCatalogue), for: .touchUpInside)
        catalogue.tintColor = READ_COLOR_MENU_COLOR
        addSubview(catalogue)
        
 
        
        // 设置
        setting = UIButton(type: .custom)
        setting.setImage(UIImage(named:"bar_1")!.withRenderingMode(.alwaysTemplate), for: .normal)
        setting.addTarget(self, action: #selector(clickSetting), for: .touchUpInside)
        setting.tintColor = READ_COLOR_MENU_COLOR
        addSubview(setting)
    }
    
    /// 点击目录
    @objc private func clickCatalogue() {
        
        readMenu?.delegate?.readMenuClickCatalogue(readMenu: readMenu)
    }

    
    /// 点击设置
    @objc private func clickSetting() {
        
        readMenu.showTopView(isShow: false)
        
        readMenu.showBottomView(isShow: false)
        
        readMenu.showSettingView(isShow: true)
    }
    

    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let wh = frame.size.height
        
        catalogue.frame = CGRect(x: 0, y: SPACE_SA_3, width: wh, height: wh)
        
        
        setting.frame = CGRect(x: frame.size.width - wh, y: SPACE_SA_3, width: wh, height: wh)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
