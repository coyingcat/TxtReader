//
//  ViewController.swift
//  one
//
//  Created by Jz D on 2021/1/25.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate{

    
    
    lazy var content = TextRenderView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        textView.backgroundColor = UIColor.white
        content.frame = CGRect(origin: .zero, size: content.theSize)
        content.center = CGPoint(x: UI.std.width / 2, y: UI.std.height / 2)
        view.addSubview(content)
        let link = "https://baike.baidu.com/item/%E5%B0%BC%E5%8F%A4%E6%8B%89%E6%96%AF%C2%B7%E5%87%AF%E5%A5%87/1295347?fromtitle=%E5%B0%BC%E5%8F%A4%E6%8B%89%E6%96%AF%E5%87%AF%E5%A5%87&fromid=415246&fr=aladdin"
        let src = "cage 电影，\(link)"
        let attributedString = NSMutableAttributedString(string: src)
        attributedString.addAttribute(.link, value: link, range: src.range(ns: link))
        textView.attributedText = attributedString
    }


    @IBOutlet var textView: UITextView!


    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
