//
//  DZMReadViewStatusTopView.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

/// topView 高度
let READ_STATUS_TOP_VIEW_HEIGHT:CGFloat =  SPACE_SA_40

class DZMReadViewStatusTopView: UIView {

    /// 书名
    private(set) var bookName = UILabel()
    
    /// 章节名
    private(set) var chapterName = UILabel()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubviews()
    }
    
    private func addSubviews() {
        
        // 书名
        bookName.font = FONT_SA_10
        bookName.textColor = DZMReadConfigure.shared.statusTextColor
        bookName.textAlignment = .left
        addSubview(bookName)
        
        // 章节名
        chapterName.font = FONT_SA_10
        chapterName.textColor = DZMReadConfigure.shared.statusTextColor
        chapterName.textAlignment = .right
        addSubview(chapterName)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let w = frame.size.width
        let h = frame.size.height
        let labelW = (w - SPACE_SA_15) / 3
        
        // 书名
        bookName.frame = CGRect(x: 0, y: 0, width: labelW, height: h)
        
        let rhsW = labelW * 2
        // 章节名
        chapterName.frame = CGRect(x: w - rhsW, y: 0, width: rhsW, height: h)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
