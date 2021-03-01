//
//  TextRenderView.swift
//  petit
//
//  Created by Jz D on 2021/2/25.
//  Copyright © 2021 swift. All rights reserved.
//

import UIKit
import CoreText

class TextRenderView: UIView {

    
    var maNiCao: (() -> Void)?
    let frameRef:CTFrame
    let theSize: CGSize
    
    let keyOne = "Willy's Wonderland"
    let keyTwo = "威利的仙境"
    
    let rawTxt: String
    let contentPage: NSAttributedString
    let keyRanges: [Range<String.Index>]
    
    override init(frame: CGRect){
        rawTxt = "When his car breaks down, a quiet loner (Nic Cage) agrees to clean an abandoned family fun center in exchange for repairs. He soon finds himself waging war against possessed animatronic mascots while trapped inside \(keyOne).\n\n 当他的汽车发生故障时，一个安静的独行侠（Nic Cage）同意清洗一个废弃的家庭娱乐中心，以换取修理费。他很快发现自己被困在\(keyTwo)中，与拥有的电子吉祥物发动了战争。"
        var tempRanges = [Range<String.Index>]()
        if let rangeOne = rawTxt.range(of: keyOne){
            tempRanges.append(rangeOne)
        }
        if let rangeTwo = rawTxt.range(of: keyTwo){
            tempRanges.append(rangeTwo)
        }
        keyRanges = tempRanges
        contentPage = NSAttributedString(string: rawTxt, attributes: [NSAttributedString.Key.font: UIFont.regular(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xC3C3C3)])
        let calculatedSize = contentPage.boundingRect(with: CGSize(width: UI.std.width - 15 * 2, height: UI.std.height), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size
        let padding: CGFloat = 10
        theSize = CGSize(width: calculatedSize.width, height: calculatedSize.height + padding)
        let framesetter = CTFramesetterCreateWithAttributedString(contentPage)
        let path = CGPath(rect: CGRect(origin: CGPoint.zero, size: theSize), transform: nil)
        frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func draw(_ rect: CGRect) {
        
        guard let ctx = UIGraphicsGetCurrentContext() else{
            return
        }
        ctx.textMatrix = CGAffineTransform.identity
        ctx.translateBy(x: 0, y: bounds.size.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        CTFrameDraw(frameRef, ctx)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else{
            return
        }
        let pt = touch.location(in: self)
        guard let offset = parserRect(with: pt, frame: frameRef), let pos = rawTxt.index(rawTxt.startIndex, offsetBy: offset, limitedBy: rawTxt.endIndex) else{
            return
        }
        if keyRanges[0].contains(pos){
            maNiCao?()
        }
        else if keyRanges[1].contains(pos){
            print("111")
        }
        
    }
    
    
    func parserRect(with point: CGPoint, frame textFrame: CTFrame) -> Int?{
        var result: Int? = nil
        let path: CGPath = CTFrameGetPath(textFrame)
        let bounds = path.boundingBox
        guard let lines = CTFrameGetLines(textFrame) as? [CTLine] else{
            return result
        }
        let lineCount = lines.count
        guard lineCount > 0 else {
            return result
        }
        var origins = [CGPoint](repeating: CGPoint.zero, count: lineCount)
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), &origins)
        for i in 0..<lineCount{
            let baselineOrigin = origins[i]
            let line = lines[i]
            var ascent: CGFloat = 0
            var descent: CGFloat = 0
            var linegap: CGFloat = 0
            let lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &linegap)
            let lineFrame = CGRect(x: baselineOrigin.x, y: bounds.height-baselineOrigin.y-ascent, width: CGFloat(lineWidth), height:  ascent+descent+linegap + 10)
            if lineFrame.contains(point){
                result = CTLineGetStringIndexForPosition(line, point)
                break
            }
        }
        return result
    }
}





extension String {

    func range(ns inner: String) -> NSRange{
        return (self as NSString).range(of: inner)
    }
    
}
