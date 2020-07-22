//
//  ReadContentView.swift

//
//  
//

import UIKit




@objc protocol ReadContentViewDelegate:NSObjectProtocol {
    
    /// 点击遮罩
    @objc optional func contentViewClickCover(contentView:ReadContentView)
}

class ReadContentView: UIView {

    /// 代理
    weak var delegate:ReadContentViewDelegate!
    
    /// 遮盖
    private var cover = UIControl()
    
    /// 是否显示遮盖
    private var isShowCover = false
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        cover.alpha = 0
        cover.isUserInteractionEnabled = false
        cover.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        cover.addTarget(self, action: #selector(clickCover), for: .touchUpInside)
        addSubview(cover)
    }
    
    @objc private func clickCover() {
        
        cover.isUserInteractionEnabled = false
        
        delegate?.contentViewClickCover?(contentView: self)
        
        showCover(isShow: false)
    }
    
    /// 遮盖展示
    func showCover(isShow:Bool) {
        
        if isShowCover == isShow { return }
        
        if isShow {
            
            bringSubviewToFront(cover)
            
            cover.isUserInteractionEnabled = true
        }
        
        isShowCover = isShow
        
        UIView.animate(withDuration: READ_AD_TIME) { [weak self] () in
            
            self?.cover.alpha = CGFloat(NSNumber(value: isShow).floatValue)
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        cover.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
