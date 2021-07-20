//
//  ColumnListCtrl_req.swift
//  SwiftSocket
//
//  Created by Jz D on 2021/6/29.
//  Copyright © 2021 swift. All rights reserved.
//

import UIKit



extension ColumnListController{
    
    
    
    func reqColumnList(){
       
        /*
            self.received = m
            
            
            self.editImg.isHidden = m.hidMk
            self.delImg.isHidden = m.hidMk
            
            self.tbHead.update(dat: m)
            if self.tbHead.changed{
                self.tableHeaderH = 330 + 20
                
                self.resetH()
            }
            self.settingsTb.reloadData()
        */
    }
    
    
    
    
    func resetH(){
        
        self.tbHead.frame = CGRect(x: 0, y: tableHeaderH.neg, width: UI.std.width, height: tableHeaderH)
        self.settingsTb.contentInset = UIEdgeInsets(top: tableHeaderH, left: 0, bottom: 0, right: 0)
        self.settingsTb.contentOffset = CGPoint(x: 0, y: tableHeaderH.neg)
    }
    
    

    
    
}







