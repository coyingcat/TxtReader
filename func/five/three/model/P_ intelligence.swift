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
    
    let renderGrid: [Coupling]
    
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
        var current: Coupling?
        for jujube in list{
            switch jujube.type{
            case 4:
                if var c = current{
                    let reduceTmp = c.string + " " + jujube.string
                    if reduceTmp.fourW >= TextContentConst.widthInUse{
                        info.append(c)
                        current = jujube
                    }
                    else{
                        c.string = reduceTmp
                        current = c
                    }
                }
                else{
                    current = jujube
                }
            default:
                if let c = current{
                    info.append(c)
                    current = nil
                }
                info.append(jujube)
            }
        }
        if let c = current{
            info.append(c)
        }
        renderGrid = info
        
    }
}



extension NetData{
    
    
    var page: NSAttributedString?{
        renderGrid.page
    }

    
    var textRender: TxtRenderInfo{
        var pronounceY = [Int]()
        var pairs = [Int]()
        
        var wArr = [Int]()
        var sucks = [String]()
        let cnt = renderGrid.count
        var i = 0
        var index = 0
        var startIdx: Int? = nil
        while i < cnt {
            let ri = renderGrid[i]
            switch ri.type {
            case 1:
                index += 2
                pronounceY.append(index)
            case 3:
                index += 1
                wArr.append(index)
            case 4:
                index += 1
                if startIdx == nil{
                    startIdx = index
                }
                pairs.append(index)
                sucks.append(ri.string)
            default:
                index += 1
            }
            i += 1
        }
        return TxtRenderInfo(pronounce: pronounceY, phrase: pairs, writerX: wArr, strs: sucks, kao: startIdx)
    }
    
    
    
    
    
}



struct TxtRenderInfo {
    
    private
    let author: [Int]
    fileprivate
    let pronounceY: [Int]
    
    
    let pronounceX: [Int]
    let writerX: [Int]
    
    //
    let eightY: [Int]
    
    let phraseY: [Int]
    
    let strs: [String]
    let startIdx: Int?
    
    init(pronounce pronInfo: [Int], phrase pairs: [Int], writerX wArr: [Int], strs sucks: [String], kao beginIdx: Int?){
        pronounceY = pronInfo
        pronounceX = pronounceY.map { (idx) -> Int in
            return idx - 1
        }
        author = []
        eightY = author + pronounceY
        phraseY = pairs
        writerX = wArr
        strs = sucks
        startIdx = beginIdx
    }
    
}



extension TxtRenderInfo{
    func contains(pair k: Int) -> Bool{
        var isOK = false
        if writerX.contains(k) || pronounceY.contains(k){
            isOK = true
        }
        return isOK
    }
    
    
}



struct Coupling: Decodable {
    var string: String
    let type: Int
}


struct Node_intelligence: Decodable {

    let wav_lengths: [TimeInterval]
    let node: [Federal_tag]?
    
}



struct Federal_tag: Decodable{
    let index: Int
    let title: String
}








struct P_Bureau: Decodable {

    let list: [Coupling]
    let title: String
    let content: String
    let audio_path: String
    let language: String
    
    let nodes: WoX_intelligence
    
    let next: Int
    
    let pre: Int
    
    
    private enum CodingKeys : String, CodingKey {
        case list,  title, audio_path = "audio"
        case nodes, content, language
        case pre = "prev_id", next = "next_id"
    }
    
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



extension P_Bureau{
    
    
    var page: NSAttributedString?{
        list.page
    }
    
    
    
    var nodeX: [TimeInterval]{
        nodes.wav_lengths
    }
    
    
    var lan: LanOpt{
        if language == "chinese"{
            return .ch
        }
        else{
            return .en
        }
    }
}



struct WoX_intelligence: Decodable {

    let wav_lengths: [TimeInterval]
    
    
}



extension Array where Element == Coupling{
    
    var page: NSAttributedString?{
        let info = NSMutableAttributedString()
        
        for jujube in self{
            switch jujube.type {
            case 0:
                info.append(jujube.string.richTitle)
            case 4:
                info.append(jujube.string.money)
            default:
                // 2
                info.append(jujube.string.richBody)
            }
        }
        return info.cp
    }
    
}




struct StartPlayIdxInfo {
    
    let interval: TimeInterval = 3
    let repeatTime = 1
    
    
    static let std = StartPlayIdxInfo()
}




extension String{
    var fourW: CGFloat{
        CGFloat(count) * 40
    }
}
