//
//  FrameLabel.swift
//  SwiftSocket
//
//  Created by Jz D on 2021/7/20.
//  Copyright © 2021 swift. All rights reserved.
//

import UIKit

import CoreText


protocol DrawDoneProxy: AnyObject {
    func done(height h: CGFloat)
}


class FrameLabel: UIView {

    
    lazy var one = FrameOneLabel()
    
    
    lazy var zero = FrameZeroLabel()
    
    
    var frameRef: CTFrame?{
        didSet{
            one.frameRef = frameRef
            one.setNeedsDisplay()
        }
    }
    

    var content: String?{
        didSet{
            zero.frameRef = frameRef
            zero.contentInfo = content
            zero.setNeedsDisplay()
        }
    }
    
    
    init() {
        
        
        
        super.init(frame: CGRect.zero)
        
        clipsToBounds = true
        
        subs(zero, one)
        
        
        
        
        one.delegate = self
        
        
    }
    

    
    
    required init?(coder: NSCoder) {
        fatalError()
        
        
        
    }
    
    
    
    
    
}



extension FrameLabel: DrawDoneProxy{
    func done(height h: CGFloat) {
        
        NotificationCenter.default.post(name: .columnExpand, object: h)
    }
    
    
}




class FrameOneLabel: UIView {

    var frameRef: CTFrame?
    
    weak var delegate: DrawDoneProxy?
    
    init() {
        super.init(frame: CGRect.zero)
        
        isHidden = true
        backgroundColor = UIColor.white
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
        
    }
    
    override func draw(_ rect: CGRect){
       guard let ctx = UIGraphicsGetCurrentContext(), let f = frameRef else{
           return
       }
        
       let xHigh = bounds.size.height
       ctx.textMatrix = CGAffineTransform.identity
       ctx.translateBy(x: 0, y: xHigh)
       ctx.scaleBy(x: 1.0, y: -1.0)
       guard let lines = CTFrameGetLines(f) as? [CTLine] else{
           return
       }
       let lineCount = lines.count
       guard lineCount > 0 else {
           return
       }

       var originsArray = [CGPoint](repeating: CGPoint.zero, count: lineCount)
       //用于存储每一行的坐标
       CTFrameGetLineOrigins(f, CFRangeMake(0, 0), &originsArray)
        var lastY: CGFloat = 0
        var final: CGFloat = 0
        var first: CGFloat? = nil
        
        var frameY:CGFloat              = 0
        
       for (i,line) in lines.enumerated(){
                var lineAscent:CGFloat      = 0
                var lineDescent:CGFloat     = 0
                var lineLeading:CGFloat     = 0
                CTLineGetTypographicBounds(line , &lineAscent, &lineDescent, &lineLeading)
                
                var lineOrigin = originsArray[i]
                print(lineOrigin, "   666  ")
                
                switch i {
                case 0:
                    frameY = lineOrigin.y
                default:
                    lastY -= 1
                    frameY = frameY - (lineAscent + lineDescent)
                    //减去一个行间距，再减去第二行，字形的上部分 （循环）
                    lineOrigin.y = frameY
                }
                        
                lineOrigin.y += lastY
               // 调整成所需要的坐标
                ctx.textPosition = lineOrigin
                
                CTLineDraw(line, ctx)
                
                if first == nil{
                    first = lineOrigin.y
                }
                let typoH = lineAscent + lineDescent
                final = lineOrigin.y - typoH
       }
        let one: CGFloat = first ?? 0
        let h = one - final
        delegate?.done(height: h)
    }
}




class FrameZeroLabel: UIView{

    
    var frameRef: CTFrame?
    
    
    var contentInfo: String?
    
    
    
    var showDot = false
    
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.white

    }
    
    
    
    override func draw(_ rect: CGRect) {
        
        
        guard let ctx = UIGraphicsGetCurrentContext(), let f = frameRef, let content = contentInfo else{
            return
        }
         
        let xHigh = bounds.size.height
        ctx.textMatrix = CGAffineTransform.identity
        ctx.translateBy(x: 0, y: xHigh)
        ctx.scaleBy(x: 1.0, y: -1.0)
        guard let lines = CTFrameGetLines(f) as? [CTLine] else{
            return
        }
        let lineCount = lines.count
        guard lineCount > 0 else {
            return
        }
        
        
        let total = max(lineCount, 3)
        
        var originsArray = [CGPoint](repeating: CGPoint.zero, count: lineCount)
        //用于存储每一行的坐标
        CTFrameGetLineOrigins(f, CFRangeMake(0, 0), &originsArray)
         var lastY: CGFloat = 0
         
         var frameY:CGFloat              = 0
         
        for i in 0..<total{
                 var lineAscent:CGFloat      = 0
                 var lineDescent:CGFloat     = 0
                 var lineLeading:CGFloat     = 0
                 CTLineGetTypographicBounds(lines[i] , &lineAscent, &lineDescent, &lineLeading)
                 
                 var lineOrigin = originsArray[i]
                 print(lineOrigin, "   666  ")
                 
                 switch i {
                 case 0:
                     frameY = lineOrigin.y
                 default:
                     lastY -= 1
                     frameY = frameY - (lineAscent + lineDescent)
                     //减去一个行间距，再减去第二行，字形的上部分 （循环）
                     lineOrigin.y = frameY
                 }
                         
                 lineOrigin.y += lastY
                // 调整成所需要的坐标
                 ctx.textPosition = lineOrigin
                 
                 
                 switch i {
                 case 0, 1:
                    
                    CTLineDraw(lines[i], ctx)
                    
                 default:
                
                    // 2
                    if showDot{
                        
                        let lineRange = CTLineGetStringRange(lines[i])
                                            
                        let range = NSMakeRange(lineRange.location == kCFNotFound ? NSNotFound : lineRange.location, lineRange.length)
                        // 找到对应的文本范围
                        
                        let sub = content[range.location..<(range.location + range.length)]
                        let new = String(sub)
                        
                        ///
                        
                        let page = new.plainX
                        
                        let calculatedSize = page.height(bound: 1000)
                        let offsetRhs: CGFloat = 28 + 29 + 10 + 5
                        let siZ = CGSize(width: UI.std.width - 16 - offsetRhs, height: calculatedSize.height * 3)
                        
                        let framesetter = CTFramesetterCreateWithAttributedString(page)
                        let path = CGPath(rect: CGRect(origin: CGPoint.zero, size: siZ), transform: nil)
                        let frameInner = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
                        
                        if let lns = CTFrameGetLines(frameInner) as? [CTLine], lns.count > 0{
                            let lineRangeSecond = CTLineGetStringRange(lns[0])
                            let rangeSecond = NSMakeRange(lineRangeSecond.location == kCFNotFound ? NSNotFound : lineRangeSecond.location, lineRangeSecond.length)
                            // 找到对应的文本范围
                            
                            let subSecond = new[rangeSecond.location..<(rangeSecond.location + rangeSecond.length)]
                            let newSecond = String(subSecond) + "..."
                            
                            let lnSecond = CTLineCreateWithAttributedString(newSecond.plainX)
                            CTLineDraw(lnSecond, ctx)
                        }
                        
                    }
                    else{
                        
                        
                        CTLineDraw(lines[i], ctx)
                    }
                    
                    
                    
                }
        }
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError()
        
        
        
    }
    
    
    

}




extension String{
    
    var plainX: NSAttributedString{
        
        let headC = UIColor(rgb: 0xC3C3C3)
        
        let headAttri: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : headC,
            NSAttributedString.Key.font : UIFont.regular(ofSize: 14) ]
        
        return NSAttributedString(string: self, attributes: headAttri)
        
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

