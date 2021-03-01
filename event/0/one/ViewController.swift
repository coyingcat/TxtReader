//
//  ViewController.swift
//  one
//
//  Created by Jz D on 2021/1/25.
//

import UIKit

class ViewController: UIViewController {

    
    
    var content = TextRenderView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        content.frame = CGRect(origin: .zero, size: content.theSize)
        content.center = CGPoint(x: UI.std.width / 2, y: UI.std.height / 2)
        view.addSubview(content)
        
        
    }

    
}

