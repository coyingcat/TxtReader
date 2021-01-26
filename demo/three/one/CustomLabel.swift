//
//  CustomLabel.swift
//  one
//
//  Created by Jz D on 2021/1/25.
//

import UIKit

class CustomLabel: UIView {
    
    var dots: NSAttributedString?
    
    

    var contentPage:NSAttributedString! {
        
        didSet{
            print(bounds)
            let f = bounds.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
            let frame = getFrameRef(attrString: contentPage, rect: f)
            
            let lines = CTFrameGetLines(frame) as! [CTLine]
            if let last = lines.last{
                let range = CTLineGetStringRange(last)
                let index = range.location + range.length
                //  public typealias CFIndex = Int
                
                /*
                let char = contentPage.string[range.location..<index]
                print(char)
                let ch = contentPage.string[index-1]
                print(ch)
                */
                var lineAscent:CGFloat = 0
                var lineDescent:CGFloat = 0
                var leading:CGFloat = 0
                let width = CTLineGetTypographicBounds(last, &lineAscent, &lineDescent, &leading)
                let wid = CGFloat(width)
                var idx = index
                let offset = bounds.width - 10 - wid
                
                // 最多再 - 2 个字
                let left = max(0, 1 - Int(offset/3))
                idx = max(0, index - left)
                let property = contentPage.attributes(at: 0, effectiveRange: nil)
                
                let newContent = String(contentPage.string[0..<idx])
                dots = NSAttributedString(string: "...", attributes: property)
                frameRef = getFrameRef(attrString: NSAttributedString(string: newContent, attributes: property), rect: f)
            }
            else{
                frameRef = frame
            }
            
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
        contentPage.draw(with: rect, options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin] , context: nil)
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
