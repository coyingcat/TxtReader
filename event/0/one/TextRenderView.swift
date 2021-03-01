//
//  TextRenderView.swift
//  petit
//
//  Created by Jz D on 2021/2/25.
//  Copyright © 2021 swift. All rights reserved.
//

import UIKit
import CoreText




func parserRect(with index: Int, in source: String, frame textFrame: CTFrame) -> CGPoint?{
    var result: CGPoint? = nil
    guard let lines = CTFrameGetLines(textFrame) as? [CTLine] else{
        return result
    }
    let lineCount = lines.count
    guard lineCount > 0 else {
        return result
    }
    var origins = [CGPoint](repeating: CGPoint.zero, count: lineCount)
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), &origins)
    for i in 0..<lineCount{
        let baselineOrigin = origins[i]
        let line = lines[i]
        var ascent: CGFloat = 0
        var descent: CGFloat = 0
        var linegap: CGFloat = 0
        CTLineGetTypographicBounds(line, &ascent, &descent, &linegap)
        let range = CTLineGetStringRange(line)
        if range.location + range.length >= index{
            let xStart = CTLineGetOffsetForStringIndex(line, index, nil)
            result = CGPoint(x: baselineOrigin.x+xStart, y:  baselineOrigin.y + (ascent - descent)/2)
            break
        }
    }
    return result
}


class TextRenderView: UIView {

    let frameRef:CTFrame
    let theSize: CGSize
    
    let keyOne = "《会员服务协议》"
    let keyTwo = "咨询客服"
    
    let rawTxt: String
    let contentPage: NSAttributedString
    let keyLocation: [Int]
    let points: [CGPoint?]
    override init(frame: CGRect){
        rawTxt = "若开通会员即表示同意\(keyOne)，本产品为虚拟内容服务，支付后无法提供退款服务，查看用户协议与隐私政策如有疑问可\(keyTwo)"
        let rangeOne = rawTxt.range(ns: keyOne)
        let rangeTwo = rawTxt.range(ns: keyTwo)
        keyLocation = [rangeOne.location + rangeOne.length / 2, rangeTwo.location + rangeTwo.length / 2]
        contentPage = NSAttributedString(string: rawTxt, attributes: [NSAttributedString.Key.font: UIFont.regular(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xC3C3C3)])
        let calculatedSize = contentPage.boundingRect(with: CGSize(width: UI.std.width - 15 * 2, height: UI.std.height), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size
        let padding: CGFloat = 10
        theSize = CGSize(width: calculatedSize.width, height: calculatedSize.height + padding)
        let framesetter = CTFramesetterCreateWithAttributedString(contentPage)
        let path = CGPath(rect: CGRect(origin: CGPoint.zero, size: theSize), transform: nil)
        frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        var pts = [CGPoint?]()
        for index in keyLocation{
            pts.append(parserRect(with: index, in: rawTxt, frame: frameRef))
        }
        points = pts
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
    }
    
    
    required init?(coder: NSCoder) {
        rawTxt = "若开通会员即表示同意\(keyOne)，本产品为虚拟内容服务，支付后无法提供退款服务，查看用户协议与隐私政策如有疑问可\(keyTwo)"
        let rangeOne = rawTxt.range(ns: keyOne)
        let rangeTwo = rawTxt.range(ns: keyTwo)
        keyLocation = [rangeOne.location + rangeOne.length / 2, rangeTwo.location + rangeTwo.length / 2]
        contentPage = NSAttributedString(string: rawTxt, attributes: [NSAttributedString.Key.font: UIFont.regular(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xC3C3C3)])
        let calculatedSize = contentPage.boundingRect(with: CGSize(width: UI.std.width - 15 * 2, height: UI.std.height), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size
        let padding: CGFloat = 10
        theSize = CGSize(width: calculatedSize.width, height: calculatedSize.height + padding)
        let framesetter = CTFramesetterCreateWithAttributedString(contentPage)
        let path = CGPath(rect: CGRect(origin: CGPoint.zero, size: theSize), transform: nil)
        frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        var pts = [CGPoint?]()
        for index in keyLocation{
            pts.append(parserRect(with: index, in: rawTxt, frame: frameRef))
        }
        points = pts
        super.init(coder: coder)
        backgroundColor = UIColor.white
    }
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else{
            return
        }
        ctx.textMatrix = CGAffineTransform.identity
        ctx.translateBy(x: 0, y: bounds.size.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        CTFrameDraw(frameRef, ctx)
        if points.count > 0{
            let path = UIBezierPath()
            path.lineWidth = 5
            for dot in points{
                if let pt = dot{
                    ctx.move(to: pt)
                    ctx.addLine(to: pt)
                    ctx.setLineCap(.round)
                    ctx.setBlendMode(.normal)
                    ctx.setLineWidth(10)
                    ctx.setStrokeColor(UIColor.magenta.cgColor)
                    ctx.strokePath()
                }
                
            }
            
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else{
            return
        }
        let pt = touch.location(in: self)
        let eventPt = CGPoint(x: pt.x, y: (bounds.size.height - pt.y))
        if let one = points[0], one.within(point: eventPt){
            print("hello")
        }
        else if let two = points[1], two.within(point: eventPt){
            print("ddd")
        }
        
    }
    
    
    
    
    
}


extension CGPoint{
    func within(point pt: CGPoint) -> Bool{
        return (pt.x - x).square + (pt.y - y).square < 60
    }
    
    
}


extension CGFloat{
    var square: CGFloat{
        self * self
    }
}


extension String {

    func range(ns inner: String) -> NSRange{
        return (self as NSString).range(of: inner)
    }
    
}
