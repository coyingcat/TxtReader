//
//  ViewController.swift
//  three
//
//  Created by Jz D on 2021/3/20.
//

import UIKit

class ViewController: UIViewController {
    

    
    
    lazy var contentV = ReadScrollV_xxxx(frame: CGRect(x: 0, y: 100, width: UI.std.width, height: UI.std.height - 200))
        
    
    
    lazy var ln: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: TxtCustomConst.kLnTop + 100, width: UI.std.width, height: 4))
        v.backgroundColor = UIColor(rgb: 0xD2E8FF)
        v.alpha = 0.6
        return v
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cyan
        view.addSubs([contentV, ln])
        
        let t = "陌上花开"
        let body = "走着走着， 就散了， 回忆都淡了；\n看着看着，就累了，星光也暗了；\n听着听着，就醒了，开始埋怨了；\n回头发现，你不见了，突然我乱了。\n\n我的世界太过安静，静得可以听见自己心跳的声音。\n心房的血液慢慢流回心室，如此这般的轮回。\n聪明的人，喜欢猜心，也许猜对了别人的心，却也失去了自己的。\n傻气的人，喜欢给心，也许会被人骗，却未必能得到别人的。\n你以为我刀枪不入，我以为你百毒不侵。"
        
        
        let info = NSMutableAttributedString(attributedString: t.customHead)
    
        let p = NSAttributedString(attributedString: body.normalLn)
        info.append(p)
        
        contentV.renderIdx = 0
        contentV.contentPageLai = info.cp
        
    }


    
}

