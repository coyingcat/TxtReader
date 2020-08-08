//
//  ReadView.swift

//
//  
//

import UIKit

class ReadView: UIView {
    
    /// 当前页模型(使用contentSize绘制)
    var pagingModel:ReadPageModel! {
        
        didSet{
            
            frameRef = CoreText.GetFrameRef(attrString: pagingModel.showContent, rect: CGRect(origin: CGPoint.zero, size: pagingModel.contentSize))
        }
    }
    
    /// 当前页内容(使用固定范围绘制)
    var contentPage:NSAttributedString! {
        
        didSet{
            
            frameRef = CoreText.GetFrameRef(attrString: contentPage, rect: CGRect(origin: CGPoint.zero, size: READ_VIEW_RECT.size))
        }
    }
    
    /// CTFrame
    var frameRef:CTFrame? {
        
        didSet{
            
            if frameRef != nil { setNeedsDisplay() }
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        // 正常使用
        backgroundColor = UIColor.clear
        
    }
    
    /// 绘制
    override func draw(_ rect: CGRect) {
        guard let frame = frameRef, let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        ctx.textMatrix = CGAffineTransform.identity
        ctx.translateBy(x: 0, y: bounds.size.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        CTFrameDraw(frame, ctx)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
