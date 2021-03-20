//
//  ViewController.swift
//  three
//
//  Created by Jz D on 2021/3/20.
//

import UIKit





class ViewController: UIViewController {
    
    
    var pIntelliJ_std: P_intelligence?
    
    
    lazy var contentHan = TextContentV(frame: CGRect(x: 0, y: 0, width: UI.std.width, height: UI.std.height))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubs([contentHan])
        do{
            
            if let path = Bundle.main.url(forResource: "one", withExtension: "plist"){
                let data = try Data(contentsOf: path)
                let decoder = PropertyListDecoder()
                self.pIntelliJ_std = try decoder.decode(P_intelligence.self, from: data)
                self.textHan()
            }
        }
        catch let error as NSError{
            print(error)
        }

        
    }


    
    
    func textHan(){
        
        guard let dat = pIntelliJ_std else {
            return
        }
        let info = NSMutableAttributedString(attributedString: dat.title.richHead)
        if let p = dat.page{
            info.append(p)
        }
        contentHan.textRender = dat.textRender
        contentHan.contentPage = info.cp
        contentHan.refresh()
    }
}

