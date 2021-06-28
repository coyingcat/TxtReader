//
//  ReadScrollV.swift
//  petit
//
//  Created by Jz D on 2021/6/18.
//  Copyright © 2021 swift. All rights reserved.
//

import UIKit


protocol DrawDoneProxy: AnyObject {
    func done(height h: CGFloat)
}




struct TxtCustomConst {
    static let padding = CGFloat(16)

    static let kLnTop: CGFloat = 250
    
    static var widthInUse: CGFloat{
           UI.std.width - TxtCustomConst.padding * 2
    }
}




class TxtViewCustom_xxxx: UIView{
    
    
    var frameRef:CTFrame?
    var txtRenderX: Int?
    var s: CGSize?
    
    var criteria = TxtCustomConst.kLnTop
    
    weak var delegate: DrawDoneProxy?
    
    var contentPageX__h: NSAttributedString?{
        didSet{
            guard let page = contentPageX__h else{
                return
            }
            
            // 计算文本框大小，因为 UIView 没有 UILabel 的 intrinsic  size
            let calculatedSize = page.custom(bound: 3000)
            let siZ = CGSize(width: TxtCustomConst.widthInUse, height: calculatedSize.height * 3)
            
            // 建立 core text 文本
            let framesetter = CTFramesetterCreateWithAttributedString(page)
            let path = CGPath(rect: CGRect(origin: CGPoint.zero, size: siZ), transform: nil)
            frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
            s = siZ
            
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }

    
 
    // 绘制文本
    override func draw(_ rect: CGRect){
       guard let ctx = UIGraphicsGetCurrentContext(), let f = frameRef, let lineIndex = txtRenderX else{
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
        var final: CGFloat = 0
        var first: CGFloat? = nil
        var lastY: CGFloat = -16
        var toRender:Bool? = nil
       for (i,line) in lines.enumerated(){
                var lineAscent:CGFloat      = 0
                var lineDescent:CGFloat     = 0
                var lineLeading:CGFloat     = 0
                CTLineGetTypographicBounds(line , &lineAscent, &lineDescent, &lineLeading)
                var lineOrigin = originsArray[i]
                lineOrigin.x = TxtCustomConst.padding + lineOrigin.x
                
                lineOrigin.y += lastY
                
                if i == lineIndex{
                    let yOffset = lineOrigin.y - lineDescent - 20
                    ctx.line(draw: yOffset)
                }
                if i <= lineIndex{
                    lastY -= 11
                }
                else{
                    lastY -= 7
                }
                ctx.textPosition = lineOrigin
                
                if first == nil{
                    first = lineOrigin.y
                }
                let typoH = lineAscent + lineDescent
                final = lineOrigin.y - typoH
                let oneX: CGFloat = first ?? 0
                if toRender == nil, oneX - final + typoH >= criteria{   // 差不多吧
                    toRender = true
                }
        
                if let re = toRender, re{
                    toRender = false
                    let lineRange = CTLineGetStringRange(line)
                    
                    let range = NSMakeRange(lineRange.location == kCFNotFound ? NSNotFound : lineRange.location, lineRange.length)
                    
                    if let content = contentPageX__h{
                        let sub = content.string[range.location..<(range.location + range.length)]
                        let new = String(sub)
                        let lnTwo = CTLineCreateWithAttributedString(new.highLn)
                        CTLineDraw(lnTwo, ctx)
                    }
                }
                else{
                    CTLineDraw(line, ctx)
                }

        
                
                
       }
        let one: CGFloat = first ?? 0
        let h = one - final + 75
        delegate?.done(height: h)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}


class ReadScrollV_xxxx: UIScrollView {
    
    fileprivate lazy var ccc = TxtViewCustom_xxxx()
    
    var s: CGSize?
    
    var renderIdx: Int?
    
    
    var timerQu: Timer?
    
    
    var contentPageLai: NSAttributedString?{
        didSet{
            ccc.txtRenderX = renderIdx
            ccc.contentPageX__h = contentPageLai
            s = ccc.s
            if let sCont = s{
                let f = CGRect(x: 0, y: 0, width: UI.std.width, height: sCont.height)
                ccc.frame = f
                contentSize = f.size
            }
            ccc.setNeedsDisplay()
        }
    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    
    func setup(){
        bounces = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        
        backgroundColor = UIColor.white
        ccc.delegate = self
        
        
        subs(ccc)
        
        let t: TimeInterval = 0.1
        timerQu = Timer.scheduledTimer(timeInterval: t , target: self, selector: #selector(ReadScrollV_xxxx.loops), userInfo: nil, repeats: true)
        timerQu?.fire()
        if timerQu != nil{
            RunLoop.main.add( timerQu! , forMode: RunLoop.Mode.common)
        }
        
    }
    
    
    
    
    @objc func loops(){
        if isDragging || isTracking{
            ccc.criteria = contentOffset.y + TxtCustomConst.kLnTop
            ccc.setNeedsDisplay()
        }
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError()
        
    }

    
    func ggg(){
        timerQu?.invalidate()
        timerQu = nil
    }
    
    
}




extension ReadScrollV_xxxx: DrawDoneProxy{
    func done(height h: CGFloat) {
        
        let cccS = ccc.frame.size
       
        contentSize = CGSize(width: cccS.width, height: max(h, UI.std.height - CGFloat(64 * 2) - 40 + 8))
        
    }
}






extension NSAttributedString{
   
    func custom(bound h: CGFloat) -> CGSize{
        return boundingRect(with: CGSize(width: TxtCustomConst.widthInUse, height: h), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size
    }
    
    
    
}




extension CGContext{
    
    
    func line(draw y: CGFloat){
        let xOffset: CGFloat = 16
        setLineWidth(1.0)
        setStrokeColor(UIColor(rgb: 0xE8E8E8).cgColor)
        move(to: CGPoint(x: xOffset, y: y))
        addLine(to: CGPoint(x: UI.std.width - xOffset, y: y))
        strokePath()
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
