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
            let frame = getFrameRef(attrString: contentPage, rect: bounds)
            
            let lines = CTFrameGetLines(frame) as! [CTLine]
            if let last = lines.last{
                let range = CTLineGetStringRange(last)
                let index = range.location + range.length
                //  public typealias CFIndex = Int
                let char = contentPage.string[range.location..<index]
                print(char)
                let ch = contentPage.string[index-1]
                print(ch)
            }
            
            frameRef = frame
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




extension StringProtocol {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
    
    
    subscript(range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    
    
    
    subscript(range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    
    
    
    subscript(range: PartialRangeFrom<Int>) -> SubSequence { self[index(startIndex, offsetBy: range.lowerBound)...] }
    
    
    subscript(range: PartialRangeThrough<Int>) -> SubSequence { self[...index(startIndex, offsetBy: range.upperBound)] }
    
    
    
    
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence { self[..<index(startIndex, offsetBy: range.upperBound)] }
}
