//
//  ViewController.swift
//  three
//
//  Created by Jz D on 2021/3/20.
//

import UIKit

class ViewController: UIViewController {
    
    
    var netDat: NetData?
    
    
    lazy var contentSong = TextContentV(frame: CGRect(x: 0, y: 100, width: UI.std.width, height: UI.std.height - 200))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubs([contentSong])
        do{
            
            if let path = Bundle.main.url(forResource: "one", withExtension: "plist"){
                let data = try Data(contentsOf: path)
                let decoder = PropertyListDecoder()
                self.netDat = try decoder.decode(NetData.self, from: data)
                self.textSong()
            }
        }
        catch let error as NSError{
            print(error)
        }

        
    }


    
    
    func textSong(){
        
        guard let dat = netDat else {
            return
        }
        let info = NSMutableAttributedString(attributedString: dat.title.richHead)
        if let p = dat.page{
            info.append(p)
        }
        contentSong.textRender = dat.textRender
        contentSong.contentPage = info.cp
        contentSong.refresh()
    }
}

