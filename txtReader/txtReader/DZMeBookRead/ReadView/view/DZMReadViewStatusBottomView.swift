//
//  DZMReadViewStatusBottomView.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

/// bottomView 高度
let READ_STATUS_BOTTOM_VIEW_HEIGHT:CGFloat =  SPACE_SA_30

class DZMReadViewStatusBottomView: UIView {
    
    /// 进度
    private(set) var progress = UILabel()
    
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
  
        // 进度
        progress.font = FONT_SA_10
        progress.textColor = DZMReadConfigure.shared.statusTextColor
        addSubview(progress)
        
 
    }
   
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let h = frame.size.height
        
        // 进度
        progress.frame = CGRect(x: 0, y: 0, width: SPACE_SA_50, height: h)
    }
    
    // MARK: -- 时间相关
    

    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
