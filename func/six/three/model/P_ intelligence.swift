//
//  P_ intelligence.swift
//  petit
//
//  Created by Jz D on 2020/10/30.
//  Copyright © 2020 swift. All rights reserved.
//

import Foundation
import UIKit



struct NetData: Decodable {
    
    let title: String
    
    private
    let list: [Coupling]
    let renderBritain: [Coupling]
    let renderEn: EnRenderInfo
    
    private enum CodingKeys : String, CodingKey {
        case list,  title
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
        if let value = try? container.decodeIfPresent([Coupling].self, forKey: .list){
            list = value
        }
        else{
            list = []
        }
        if let value = try? container.decodeIfPresent(String.self, forKey: .title){
            title = value
        }
        else{
            title = ""
        }
        
        
// MARK:- 进入 init , computer
        var info = [Coupling]()
        let product = "ha ha ha"
        var infoEn = [TxtRenderInfoEn]()
        var enLineIdx = 1
       
        var titlesBelowS = [Int]()
        var titleFirstS: Bool = false
        var restTitleS = [Int]()
        
        var acht = [Int]()
        var zehn = [Int]()
        for jujube in list{
            switch jujube.type{
            case 0:
                if titleFirstS{
                    restTitleS.append(enLineIdx)
                }
                titlesBelowS.append(enLineIdx + 1)
                titleFirstS = true
                info.append(jujube)
                enLineIdx += 1
            case 6:
                restTitleS.append(enLineIdx)
                info.append(jujube)
                enLineIdx += 1
            case 7:
                let contentC = UIColor(rgb: 0x1A1B1C)
                let contentAttri: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : contentC,
                     NSAttributedString.Key.font : UIFont.regular(ofSize: 16)
                    ]
                let belongStr = NSAttributedString(string: jujube.string, attributes: contentAttri)
                let lnTwo = CTLineCreateWithAttributedString(belongStr)
                let w = lnTwo.lnSize.width
                let cnt = w / TextContentConst.widthBritain
                var m = jujube
                let len = Int(ceil(cnt))
                if len > 1{
                    (1..<len).forEach {
                        acht.append($0 + enLineIdx)
                    }
                    m.subList = [String](repeating: product, count: len)
                    infoEn.append(TxtRenderInfoEn(lineIdx: enLineIdx, content: jujube.string, cnt: len, t: m.title ?? "", beBlack: true))
                }
                else{
                    m.type = 101
                }
                info.append(m)
                enLineIdx += len
            case 8:
                let contentC = UIColor(rgb: 0x9397A1)
                let contentAttri: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : contentC,
                     NSAttributedString.Key.font : UIFont.regular(ofSize: 16) ]
                let belongStr = NSAttributedString(string: jujube.string, attributes: contentAttri)
                let lnTwo = CTLineCreateWithAttributedString(belongStr)
                let w = lnTwo.lnSize.width
                let cnt = w / TextContentConst.widthBritain
                var m = jujube
                let len = Int(ceil(cnt))
                if len > 1{
                    (1..<len).forEach {
                        acht.append($0 + enLineIdx)
                    }
                    m.subList = [String](repeating: product, count: len)
                    infoEn.append(TxtRenderInfoEn(lineIdx: enLineIdx, content: jujube.string, cnt: len, t: m.title ?? "", beBlack: false))
                }
                else{
                    m.type = 102
                }
                info.append(m)
                zehn.append(enLineIdx)
                enLineIdx += len
            default:
                if jujube.string != "\\n"{
                    info.append(jujube)
                    enLineIdx += 1
                }
            }
        }
        renderBritain = info
        renderEn = EnRenderInfo(titlesBelowS: titlesBelowS, en: infoEn, restTitles: restTitleS, lineIndex: 0, eightY: acht, twelve: zehn)
        
    }
}



extension NetData{
    
    var page: NSAttributedString?{
        renderBritain.pageEn
    }

}





struct EnRenderInfo{
    
    let titlesBelowS: [Int]
    let en: [TxtRenderInfoEn]
    let restTitles: [Int]
    
    
    let lineIndex: Int
    let eightY: [Int]
    let twelve: [Int]
    
    
    init(titlesBelowS: [Int], en qiqi: [TxtRenderInfoEn], restTitles: [Int], lineIndex: Int, eightY: [Int], twelve: [Int]) {
        self.titlesBelowS = titlesBelowS
        self.restTitles = restTitles
        self.lineIndex = lineIndex
        self.eightY = eightY
        self.twelve = twelve
        
        en = qiqi.map({ (balle) in
            var leMonde = balle
            let dépression: NSAttributedString
            if balle.beBlack{
                dépression = balle.content.seven(toBreak: false)
            }
            else{
                dépression = balle.content.eight(toBreak: false)
            }
            let framesetter = CTFramesetterCreateWithAttributedString(dépression)
            let path = CGPath(rect: CGRect(origin: CGPoint.zero, size: CGSize(width: TextContentConst.widthBritain, height: 45 * CGFloat(balle.cnt))), transform: nil)
            let f = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
            guard let lines = CTFrameGetLines(f) as? [CTLine] else{
                return leMonde
            }
            leMonde.lines = lines
            return leMonde
        })
    }
}


struct TxtRenderInfoEn {
    let lineIdx: Int
    let content: String
    let cnt: Int
    
    let t: String
    let beBlack: Bool
    
    
    var lines = [CTLine]()
}



struct Coupling: Decodable {
    
    private
    let phrase: String?
    let word: String?
    
    var string: String
    
    var type: Int
    let pronounce: String?
    let title: String?

    var subList: [String]?
}



enum LanOpt{
    case en
    case ch
    
    
    var val: String{
        let src: String
        switch self {
        case .ch:
            src = "chinese"
        case .en:
            src = "english"
        }
        return src
    }
}






extension Array where Element == Coupling{
    
    var pageEn: NSAttributedString?{
        let info = NSMutableAttributedString()
        for jujube in self{
            switch jujube.type {
            case 0:
                info.append(jujube.string.richTitle)
            case 6:
                info.append(jujube.string.six)
            case 7:
                if let val = jujube.title{
                    info.append(val.seven(toBreak: false))
                }
                if let val = jujube.subList{
                    val.forEach {
                        info.append($0.seven(toBreak: true))
                    }
                }
            case 8:
                if let val = jujube.title{
                    info.append(val.eight(toBreak: false))
                }
                if let val = jujube.subList{
                    val.forEach {
                        info.append($0.eight(toBreak: true))
                    }
                }
            case 101:
                if let val = jujube.title{
                    info.append(val.seven(toBreak: false))
                }
                info.append(jujube.string.seven(toBreak: true))
            case 102:
                if let val = jujube.title{
                    info.append(val.eight(toBreak: false))
                }
                info.append(jujube.string.eight(toBreak: true))
            default:
                // 2
                info.append(jujube.string.richBody)
            }
        }
        return info.cp
    }
    
}
