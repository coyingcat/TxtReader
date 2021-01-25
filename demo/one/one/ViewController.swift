//
//  ViewController.swift
//  one
//
//  Created by Jz D on 2021/1/25.
//

import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet weak var content: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.white
        let info = "近重阳偏多风雨，绝怜此日暄明。666666666666666问秋香浓未，待携客、出西城。666666666666666"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        paragraphStyle.lineBreakMode = .byCharWrapping
     
        let property: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.magenta,
             .paragraphStyle: paragraphStyle]
        content.numberOfLines = 0
        content.attributedText = NSAttributedString(string: info, attributes: property)
    }


}

