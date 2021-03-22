//
//  ViewController.swift
//  two
//
//  Created by Jz D on 2021/3/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let v = CustomView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 200))
        view.addSubview(v)
        
    }


}

