//
//  MainController.swift

//
//  
//

import UIKit

class MainController: ViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        // 标题
        title = "BookRead"
        
        // 简介
        let hint = UITextView()
        hint.text = "如果需要单独测试【全文解析】跟【快速解析】,需要删除app重新点击\n"
        hint.textColor = UIColor.gray
        hint.font = UIFont.systemFont(ofSize: 15)
        hint.isEditable = false
        view.addSubview(hint)
        hint.frame = CGRect(x: SPACE_SA_15, y: NavgationBarHeight + SPACE_SA_15, width: ScreenWidth - SPACE_SA_30, height: SPACE_SA_350)
        
        // 全本解析
        let fullButton = UIButton(type: .custom)
        fullButton.setTitle("全本解析", for: .normal)
        fullButton.backgroundColor = UIColor.green
        fullButton.addTarget(self, action: #selector(fullRead), for: .touchDown)
        view.addSubview(fullButton)
        fullButton.frame = CGRect(x: (ScreenWidth / 2 - SPACE_SA_100) / 2, y: ScreenHeight - SPACE_SA_150 * 2, width: SPACE_SA_100, height: SPACE_SA_100)
        
        // 快速解析阅读
        let fastButton = UIButton(type: .custom)
        fastButton.setTitle("快速解析", for: .normal)
        fastButton.backgroundColor = UIColor.green
        fastButton.addTarget(self, action: #selector(fastRead), for: .touchDown)
        view.addSubview(fastButton)
        fastButton.frame = CGRect(x: ScreenWidth - SPACE_SA_100 - (ScreenWidth / 2 - SPACE_SA_100) / 2, y: ScreenHeight - SPACE_SA_150 * 2, width: SPACE_SA_100, height: SPACE_SA_100)
    }
    
    // 全本解析阅读
    @objc private func fullRead() {
        
        print("缓存文件地址:", Sand.readDocumentDirectoryPath)
        
        guard let url = Bundle.main.url(forResource: "三国演义", withExtension: "txt") else { return }
        
        print("全本解析开始时间:",TimerString("YYYY-MM-dd-HH-mm-ss"), Date().timeIntervalSince1970)
        
        ReadTextParser.resolve(url: url) { [weak self] (readModel) in
            
            print("全本解析结束时间:",TimerString("YYYY-MM-dd-HH-mm-ss"), Date().timeIntervalSince1970)

            self?.navigationController?.pushViewController(ReadController(reading: readModel), animated: true)
        }
    }
    
    // 快速解析阅读
    @objc private func fastRead() {
        
        print("缓存文件地址:", Sand.readDocumentDirectoryPath)
        
       
        
        guard let url = Bundle.main.url(forResource: "三国演义", withExtension: "txt") else { return }
        
        print("快速解析开始时间:",TimerString("YYYY-MM-dd-HH-mm-ss"), Date().timeIntervalSince1970)
        
        ReadTextFastParser.parser(url: url) { [weak self] (readModel) in
            
            print("快速解析结束时间:",TimerString("YYYY-MM-dd-HH-mm-ss"), Date().timeIntervalSince1970)
            
            self?.navigationController?.pushViewController(ReadController(reading: readModel), animated: true)
        }
    }
    
}
