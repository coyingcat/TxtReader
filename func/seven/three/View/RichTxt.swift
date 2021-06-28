//
//  RichTxt.swift
//  petit
//
//  Created by Jz D on 2020/11/9.
//  Copyright © 2020 swift. All rights reserved.
//

import UIKit


extension String{
    
    var richHead: NSAttributedString{
        let headC = UIColor(rgb: 0x313836)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 40
        
        let headAttri: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : headC,
            NSAttributedString.Key.font : UIFont.semibold(ofSize: 20),
            NSAttributedString.Key.paragraphStyle : paragraphStyle
                ]
        
        return NSAttributedString(string: "\(self)\n", attributes: headAttri)
        
    }
    
    var richTitle: NSAttributedString{
        let headC = UIColor(rgb: 0x313836)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 30
        
        let headAttri: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : headC,
             NSAttributedString.Key.font : UIFont.semibold(ofSize: 20),
             NSAttributedString.Key.paragraphStyle : paragraphStyle
            ]
        return NSAttributedString(string: "\(self):\n", attributes: headAttri)
        
    }
    
    
    var richBody: NSAttributedString{
        let contentC = UIColor(rgb: 0x404248)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 20
        
        let contentAttri: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : contentC,
             NSAttributedString.Key.font : UIFont.regular(ofSize: 16),
             NSAttributedString.Key.paragraphStyle : paragraphStyle
            ]
        
        var gg = "\(self)"
        let isOK = "\n"
        if gg.hasSuffix(isOK) == false{
            gg += isOK
        }
        return NSAttributedString(string: gg, attributes: contentAttri)
    }
    
}


extension String{
    var six: NSAttributedString{
        let contentC = UIColor(rgb: 0x1A1B1C)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let contentAttri: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : contentC,
             NSAttributedString.Key.font : UIFont.semibold(ofSize: 18),
             NSAttributedString.Key.paragraphStyle : paragraphStyle
            ]
        return NSAttributedString(string: "\(self)\n", attributes: contentAttri)
    }
    
    
    func seven(toBreak brk: Bool) -> NSAttributedString{
        var tmp = self
        if brk{
            tmp += "\n"
        }
        let contentC = UIColor(rgb: 0x1A1B1C)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let contentAttri: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : contentC,
             NSAttributedString.Key.font : UIFont.regular(ofSize: 16),
             NSAttributedString.Key.paragraphStyle : paragraphStyle
            ]
        return NSAttributedString(string: tmp, attributes: contentAttri)
    }
    
    
    func eight(toBreak brk: Bool) -> NSAttributedString{
        var tmp = self
        if brk{
            tmp += "\n"
        }
        let contentC = UIColor(rgb: 0x9397A1)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let contentAttri: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : contentC,
             NSAttributedString.Key.font : UIFont.regular(ofSize: 16),
             NSAttributedString.Key.paragraphStyle : paragraphStyle
            ]
        return NSAttributedString(string: tmp, attributes: contentAttri)
    }
    
    
    
}
