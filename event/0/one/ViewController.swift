//
//  ViewController.swift
//  one
//
//  Created by Jz D on 2021/1/25.
//

import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet weak var content: TextRenderView!
    
    
    lazy var text = { () -> NSAttributedString in
        let info = "近重阳偏多风雨，绝怜此日暄明。问秋香浓未，待携客、出西城。"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        paragraphStyle.lineBreakMode = .byCharWrapping
     
        let property: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.magenta,
             .paragraphStyle: paragraphStyle,
             .font: UIFont.systemFont(ofSize: 18) ]
        return NSAttributedString(string: info, attributes: property)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.white
        
        
    }

    
}

