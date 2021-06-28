//
//  ViewController.swift
//  three
//
//  Created by Jz D on 2021/3/20.
//

import UIKit

class ViewController: UIViewController {
    

    
    
    lazy var contentSong = ReadScrollV()
        

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cyan
        view.addSubs([contentSong])


        
    }


    
}

