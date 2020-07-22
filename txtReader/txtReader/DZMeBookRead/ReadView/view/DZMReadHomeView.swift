//
//  ReadHomeView.swift

//
//  
//

import UIKit

class ReadHomeView: UIView {
    
    /// 书籍名称
    private var name = UILabel()
    
    /// 当前阅读模型
    var readModel:ReadModel! {
        
        didSet{
            
            name.text = readModel.bookName
        }
    }

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        
        
        // 书籍名称
        name.textAlignment = .center
        name.font = FONT_BOLD_SA(50)
        name.textColor = ReadConfigure.shared.textColor
        addSubview(name)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        name.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
