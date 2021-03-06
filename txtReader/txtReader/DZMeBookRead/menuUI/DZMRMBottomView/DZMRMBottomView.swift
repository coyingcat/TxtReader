//
//  RMBottomView.swift

//
//  
//

import UIKit

/// funcView 高度
let READ_MENU_FUNC_VIEW_HEIGHT:CGFloat = SPACE_SA_55

/// progressView 高度
let READ_MENU_PROGRESS_VIEW_HEIGHT:CGFloat = SPACE_SA_55

/// bottomView 高度 (TabBarHeight就包含了funcView高度, 所以只需要在上面在加progressView高度就好了)
let READ_MENU_BOTTOM_VIEW_HEIGHT:CGFloat = TabBarHeight + READ_MENU_PROGRESS_VIEW_HEIGHT

class RMBottomView: RMBaseView {
    
    /// 进度
    private(set)
    lazy var progressView = RMProgressView(read: readMenu)
    
    /// 功能
    private
    lazy var funcView = RMFuncView(read: readMenu)

    override init(read menu: ReadMenu) {
        super.init(read: menu)
        addSubview(progressView)
        
        addSubview(funcView)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        progressView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: READ_MENU_PROGRESS_VIEW_HEIGHT)
        
        funcView.frame = CGRect(x: 0, y: progressView.frame.maxY, width: frame.size.width, height: READ_MENU_FUNC_VIEW_HEIGHT)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
