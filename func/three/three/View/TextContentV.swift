//
//  TextContentV.swift
//  petit
//
//  Created by Jz D on 2021/3/17.
//  Copyright © 2021 swift. All rights reserved.
//

import UIKit

struct TextContentConst {
    static let padding = CGFloat(40)
    static let fBgTypoImg = CGRect(origin: CGPoint(x: 40, y: 0), size: CGSize(width: 40, height: 40))
    static let offsetP = CGPoint(x: 10, y: 5)
}

protocol DrawDoneProxy: class {
    func done(height h: CGFloat)
}

class InnerTextView: UIView{
    
    
    var frameRef:CTFrame?
    var textRender: TxtRenderInfo?
    var s: CGSize?
    
    let bgGrip = UIImage(named: "6_typo_grip")
    weak var delegate: DrawDoneProxy?
    
    var contentPage: NSAttributedString?{
        didSet{
            guard let page = contentPage else{
                return
            }
            
            // 计算文本框大小，因为 UIView 没有 UILabel 的 intrinsic  size
            let widthInUse = UI.std.width - TextContentConst.padding * 2
            let calculatedSize = page.boundingRect(with: CGSize(width: widthInUse, height: 3000), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size
            let siZ = CGSize(width: widthInUse, height: calculatedSize.height * 3)
            
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
       guard let ctx = UIGraphicsGetCurrentContext(), let f = frameRef, let info = textRender else{
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
       var frameY:CGFloat              = 0

       var originsArray = [CGPoint](repeating: CGPoint.zero, count: lineCount)
       //用于存储每一行的坐标
       CTFrameGetLineOrigins(f, CFRangeMake(0, 0), &originsArray)
        var lastY: CGFloat = 0
        var final: CGFloat = 0
        var first: CGFloat? = nil
        
       for (i,line) in lines.enumerated(){
               var lineAscent:CGFloat      = 0
               var lineDescent:CGFloat     = 0
               var lineLeading:CGFloat     = 0
               let sentenceW = CTLineGetTypographicBounds(line , &lineAscent, &lineDescent, &lineLeading)
               
                var lineOrigin = originsArray[i]
                lineOrigin.x = TextContentConst.padding
                if info.eightY.contains(i){
                    lastY -= 8
                }
                else{
                    switch i {
                    case 1:
                        lastY -= TextContentConst.padding
                    default:
                        lastY -= 20
                    }
                }
        
                if info.pronounceX.contains(i){
                    let makeUp = TextContentConst.fBgTypoImg.width - CGFloat(sentenceW)
                    lineOrigin.x += makeUp / 2
                }
        
                switch i {
                case 0:
                    frameY = lineOrigin.y
                default:
                    frameY = frameY - (lineAscent + lineDescent)
                    lineOrigin.y = frameY
                }
                
                lineOrigin.y += lastY
                let yOffset = lineOrigin.y - lineDescent - 20
                if i == 0{
                    ctx.draw(line: yOffset)
                }
                ctx.textPosition = lineOrigin
                if info.contains(pair: i){
                    drawPairs(context: ctx, ln: line, startPoint: lineOrigin, ascent: lineAscent)
                }
                else{
                    CTLineDraw(line, ctx)
                }
                if first == nil{
                    first = lineOrigin.y
                }
                let typoH = lineAscent + lineDescent
                final = lineOrigin.y - typoH
       }
        let one: CGFloat = first ?? 0
        let h = one - final + 75 + TextContentConst.offsetP.y
        delegate?.done(height: h)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func drawPairs(context ctx: CGContext, ln line: CTLine,startPoint lineOrigin: CGPoint, ascent lineAscent: CGFloat){
        if let pieces = CTLineGetGlyphRuns(line) as? [CTRun]{
            let pieceCnt = pieces.count
            var zeroP = lineOrigin
            zeroP.y -= 5
            for j in 0..<pieceCnt{
                switch j {
                case 0:
                    var frame = TextContentConst.fBgTypoImg
                    frame.origin.y = lineOrigin.y + lineAscent - TextContentConst.fBgTypoImg.size.height + TextContentConst.offsetP.y
                    bgGrip?.draw(in: frame)
                    zeroP.x += TextContentConst.offsetP.x
                case 1:
                    zeroP.x = 92
                default:
                    ()
                }
                ctx.textPosition = zeroP
                CTRunDraw(pieces[j], ctx, CFRange(location: 0, length: 0))
            }
        }
    }
    
}


class TextContentV: UIScrollView {

    lazy var contentV = InnerTextView()
    
    var s: CGSize?
    
    var contentPage: NSAttributedString?{
        didSet{
            contentV.textRender = textRender
            contentV.contentPage = contentPage
            s = contentV.s
        }
    }
    var textRender: TxtRenderInfo?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bounces = false
        contentV.delegate = self
        addSubs([contentV])
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    func refresh(){
        if let sCont = s{
            contentV.frame = CGRect(x: 0, y: 0, width: UI.std.width, height: sCont.height)
            contentSize = sCont
        }
        contentV.setNeedsDisplay()
    }
}


extension TextContentV: DrawDoneProxy{
    func done(height h: CGFloat) {
        let s = contentSize
        contentSize = CGSize(width: s.width, height: h)
    }
}




extension CGContext{
    
    func draw(line y: CGFloat){
        let xOffset: CGFloat = 40
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



extension CTLine{
    var lnSize: CGSize{
        var lnAscent:CGFloat      = 0
        var lnDescent:CGFloat     = 0
        var lnLeading:CGFloat     = 0
        let glyphW = CTLineGetTypographicBounds(self , &lnAscent, &lnDescent, &lnLeading)
        let lnHeight = lnAscent + lnDescent + lnLeading
        return CGSize(width: CGFloat(glyphW), height: lnHeight)
    }
}
