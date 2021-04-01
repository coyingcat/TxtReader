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
    
    static var widthInUse: CGFloat{
           UI.std.width - TextContentConst.padding * 2
    }
    
    static var widthBritain: CGFloat{
           UI.std.width - TextContentConst.padding * 2 - 48
    }
}

protocol DrawDoneProxy: class {
    func done(height h: CGFloat)
}





class InnerTextViewEn: UIView{
    
    
    var frameRef:CTFrame?
    var textRenderX: EnRenderInfo?
    var s: CGSize?
    
    let bgGrip = UIImage(named: "6_typo_grip")
    weak var delegate: DrawDoneProxy?
    
    var contentPageX: NSAttributedString?{
        didSet{
            guard let page = contentPageX else{
                return
            }
            
            // 计算文本框大小，因为 UIView 没有 UILabel 的 intrinsic  size
            let calculatedSize = page.bound(height: 3000)
            let siZ = CGSize(width: TextContentConst.widthInUse, height: calculatedSize.height * 3)
            
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
       guard let ctx = UIGraphicsGetCurrentContext(), let f = frameRef, let info = textRenderX else{
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
        var index = 0
        let limit = info.en.count
        var fuk: Int? = nil
        let insetX = CGFloat(48)
       for (i,line) in lines.enumerated(){
                var lineAscent:CGFloat      = 0
                var lineDescent:CGFloat     = 0
                var lineLeading:CGFloat     = 0
                CTLineGetTypographicBounds(line , &lineAscent, &lineDescent, &lineLeading)
                var lineOrigin = originsArray[i]
                // print(lineOrigin)
                lineOrigin.x = TextContentConst.padding + lineOrigin.x
                if info.eightY.contains(i){
                    lastY -= 3
                }
                else if info.twelve.contains(i){
                    lastY -= 11
                }
                else if info.titlesBelowS.contains(i){
                    lastY -= 20
                }
                else if info.restTitles.contains(i){
                    lastY -= TextContentConst.padding
                }
                else{
                    switch i {
                    case info.lineIndex + 1:
                        lastY -= TextContentConst.padding
                    default:
                        lastY -= 20
                    }
                }
        
                switch i {
                case 0:
                    frameY = lineOrigin.y
                default:
                    frameY = frameY - (lineAscent + lineDescent)
                    //减去一个行间距，再减去第二行，字形的上部分 （循环）
                    lineOrigin.y = frameY
                }
                
                lineOrigin.y += lastY
               // 调整成所需要的坐标
                let yOffset = lineOrigin.y - lineDescent - 20
                if i == info.lineIndex{
                    ctx.draw(line: yOffset)
                }
                ctx.textPosition = lineOrigin
                var toDraw = false
                if let f = fuk{
                    if i >= f{
                        fuk = nil
                    }
                    else{
                        let biscuit = info.en[index - 1]
                        ctx.textPosition = CGPoint(x: lineOrigin.x + insetX, y: lineOrigin.y)
                        CTLineDraw(biscuit.lines[biscuit.cnt - (f - i)], ctx)
                        toDraw = true
                    }
                }
                if index < limit, info.en[index].lineIdx == i{
                    let biscuit = info.en[index]
                    let dépression: NSAttributedString
                    if biscuit.beBlack{
                        dépression = biscuit.t.seven(toBreak: false)
                    }
                    else{
                        dépression = biscuit.t.eight(toBreak: false)
                    }
                    let ln = CTLineCreateWithAttributedString(dépression)
                    CTLineDraw(ln, ctx)
                    ctx.textPosition = CGPoint(x: lineOrigin.x + insetX, y: lineOrigin.y)
                    CTLineDraw(biscuit.lines[0], ctx)
                    toDraw = true
                    fuk = i + biscuit.cnt
                    index += 1
                }
                if toDraw == false{
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
}





class TextContentV: UIScrollView {

    lazy var contentEnV = InnerTextViewEn()
    
    var s: CGSize?
    
    var contentPageEn: NSAttributedString?{
        didSet{
            contentEnV.textRenderX = enRender
            contentEnV.contentPageX = contentPageEn
            s = contentEnV.s
        }
    }
    var enRender: EnRenderInfo?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bounces = false
        contentEnV.delegate = self
        addSubs([contentEnV])
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    func refreshEn(){
        if let sCont = s{
            contentEnV.frame = CGRect(x: 0, y: 0, width: UI.std.width, height: sCont.height)
            contentSize = sCont
        }
        contentEnV.setNeedsDisplay()
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





extension NSAttributedString{
    func bound(height h: CGFloat) -> CGSize{
        return boundingRect(with: CGSize(width: TextContentConst.widthInUse, height: h), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size
    }
    
}
