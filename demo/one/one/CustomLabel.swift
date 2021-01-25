//
//  CustomLabel.swift
//  one
//
//  Created by Jz D on 2021/1/25.
//

import UIKit

class CustomLabel: UIView {

    var contentPage:NSAttributedString! {
        
        didSet{
            frameRef = getFrameRef(attrString: contentPage, rect: bounds)
        }
    }
    
    /// CTFrame
    var frameRef:CTFrame? {
        
        didSet{
            
            if frameRef != nil { setNeedsDisplay() }
        }
    }
    
    func getFrameRef(attrString:NSAttributedString, rect:CGRect) ->CTFrame {
        let framesetter = CTFramesetterCreateWithAttributedString(attrString)
        let path = CGPath(rect: rect, transform: nil)
        return CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path = UIBezierPath(rect: rect)
        UIColor.orange.setStroke()
        path.stroke()
        
        guard let frame = frameRef, let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        ctx.textMatrix = CGAffineTransform.identity
        ctx.translateBy(x: 0, y: bounds.size.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        CTFrameDraw(frame, ctx)
    }
    

}
