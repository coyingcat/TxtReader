//
//  CustomView.swift
//  two
//
//  Created by Jz D on 2021/3/22.
//

import UIKit

class CustomView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        let attributed =  NSMutableAttributedString(string: "新丰美酒斗十千，咸阳游侠多少年。\n相逢意气为君饮，系马高楼垂柳边。\n出身仕汉羽林郎，初随骠骑战渔阳。\n孰知不向边庭苦，纵死犹闻侠骨香。");
        attributed.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)], range: NSMakeRange(0, attributed.length))
        attributed.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)], range: NSMakeRange(2, 2))
        attributed.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.orange], range: NSMakeRange(0, 7))
        attributed.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], range: NSMakeRange(8, 7))
        
        let strokePath = CGMutablePath()
        strokePath.addRect(CGRect(x: 1, y: 1, width: UIScreen.main.bounds.width-2, height: 1))
        ctx.addPath(strokePath)
        ctx.setStrokeColor(UIColor.purple.cgColor)
        ctx.strokePath()
        let path = CGMutablePath()
        path.addRect(bounds)
        let xHigh = bounds.size.height
        ctx.textMatrix = CGAffineTransform.identity
        ctx.translateBy(x: 0, y: xHigh)
        ctx.scaleBy(x: 1.0, y: -1.0)
        
           let ctFrameSetter = CTFramesetterCreateWithAttributedString(attributed)
           let ctFrame = CTFramesetterCreateFrame(ctFrameSetter, CFRangeMake(0, attributed.length), path, nil)
           let lines = CTFrameGetLines(ctFrame) as NSArray
           var originsArray = [CGPoint](repeating: CGPoint.zero, count: lines.count)
           CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), &originsArray)
           var frameY:CGFloat              = 0
           for (i,line) in lines.enumerated() {
               var lineAscent:CGFloat      = 0
               var lineDescent:CGFloat     = 0
               var lineLeading:CGFloat     = 0
               CTLineGetTypographicBounds(line as! CTLine, &lineAscent, &lineDescent, &lineLeading)
               var lineOrigin = originsArray[i]
               
               if i > 0{
                   frameY = frameY - lineAscent - lineDescent
                   lineOrigin.y = frameY
               }
               else{
                   frameY = lineOrigin.y
               }
               ctx.textPosition = lineOrigin
               CTLineDraw(line as! CTLine, ctx)
           }
       }
}
