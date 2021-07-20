//
//  ColumnListController.swift
//  petit
//
//  Created by Jz D on 2021/6/8.
//  Copyright © 2021 swift. All rights reserved.
//

import UIKit


import NSObject_Rx

import RxSwift

import RxCocoa


class ColumnListController: UIViewController {
    
    var tableHeaderH: CGFloat = 330
    
    var tableHeadExpanded: CGFloat?
    
    var selected = [Int]()
    
    
    var dels: [Int]{
        if let d = received{
            return selected.map { item in
                d.content[item].contentID
            }
        }
        else{
            return []
        }
    }
        
        
        
    var showSelect: Bool = false {
        didSet {
            if showSelect{
                settingsTb.allowsSelection = false
            }
        }
    }
    
    
    lazy var lhsArrow = UIImageView(image: UIImage(named: "preacher_1001"))
   

    
    lazy var tbHead: ColumnListHeader = {
        let h = ColumnListHeader(frame: CGRect(x: 0, y: -tableHeaderH, width: UI.std.width, height: tableHeaderH))
        h.delegate = self
        return h
    }()
    
    
    lazy var settingsTb: UITableView = {
        let tb = UITableView(frame: CGRect(x: 0, y: 0, width: UI.std.width, height: UI.std.height))
        
  //      tb.tableHeaderView = nil
        tb.contentInset = UIEdgeInsets(top: tableHeaderH, left: 0, bottom: 0, right: 0)
        tb.contentOffset = CGPoint(x: 0, y: -tableHeaderH)
        tb.register(for: ColumnListCel.self)

    
        tb.separatorStyle = UITableViewCell.SeparatorStyle.none
        tb.backgroundColor = UIColor.clear
        tb.delegate = self
        tb.dataSource = self
        return tb
    }()
    
    
    let key: Int
    
    
    var received: Column_detail?
    

    init(key k: Int){
        key = k
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubs([ settingsTb, lhsArrow])
        
        
        let side: CGFloat = 32
        lhsArrow.frame = CGRect(x: 16, y: 34, width: side, height: side)
        lhsArrow.isUserInteractionEnabled = true
        
        

        settingsTb.addSubview(tbHead)
        
    
        
        doEvents()
        
        reqColumnList()
        
    }
    
    
    
    
    
    
    func doEvents(){
        
        
        let tapBack = UITapGestureRecognizer()
        lhsArrow.addGestureRecognizer(tapBack)
        tapBack.rx.event.bind { (event) in
            
            self.xForce()
            
        }.disposed(by: rx.disposeBag)
        
        

        
        ///
        
        
        NotificationCenter.default.rx
            .notification(.columnExpand)
            .takeUntil(self.rx.deallocated).subscribeOo(onNext: { (noti) in
                guard let h = noti.object as? CGFloat else{
                    return
                }
                self.tableHeadExpanded = self.tableHeaderH + h - 60
                
        }).disposed(by: rx.disposeBag)
    }

}







extension ColumnListController{
    
    func xForce() {
        navigationController?.popViewController(animated: true)
    }
    

}




extension ColumnListController: UITableViewDelegate{
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 88
    }
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
  
        var headerRect = CGRect(x: 0, y: -tableHeaderH, width: UI.std.width, height: tableHeaderH)
        // 决定拉动的方向
        if settingsTb.contentOffset.y < -tableHeaderH{
            // 就是改 frame
            headerRect.origin.y = settingsTb.contentOffset.y
            headerRect.size.height = -settingsTb.contentOffset.y
        }
        tbHead.frame = headerRect
 
    }
}




extension ColumnListController: UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dat = received{
            return dat.content.count
        }
        else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let item = tableView.dequeue(for: ColumnListCel.self, ip: indexPath)
        item.delegate = self
        var choosen: Bool? = nil
        
        if showSelect{
            choosen = false
        }
            
        if selected.contains(row){
            choosen = true
        }
        if let dat = received{
            item.data(config: dat.content[row], index: row, selected: choosen)
        }
        
        return item
        
    }
    
    
}




extension ColumnListController: ColumnListHeaderProxy{
    
    
    
    
    
    func expand(columnHeader show: Bool){
        
        
        if show{
            
            guard let h_h = tableHeadExpanded else {
                return
            }
            tbHead.frame = CGRect(x: 0, y: h_h.neg, width: UI.std.width, height: h_h)
            settingsTb.contentInset = UIEdgeInsets(top: h_h, left: 0, bottom: 0, right: 0)
            settingsTb.contentOffset = CGPoint(x: 0, y: h_h.neg)
        }
        else{
            
            resetH()
        }
        
        
        
    }
    
    
    
    
    func toggleClick(columnHeader show: Bool){
        if show == false{
            selected.removeAll()
        }
        showSelect = show
        settingsTb.reloadData()
        
    }
    
    
    
    
    
    
    
}









extension ColumnListController: ColumnListCelProxy{
    
    func click(columnCel idx: Int) {
        
        selected.keep(many: idx)

        settingsTb.reloadRows(at: [IndexPath(row: idx, section: 0)], with: .automatic)
    }
    

    
}



extension Array where Element == Int{
    
    mutating
    func keep(many idx: Int){
        if contains(idx){
            removeAll { ele in
                ele == idx
            }
        }
        else{
            append(idx)
        }
    }
    
    
}
