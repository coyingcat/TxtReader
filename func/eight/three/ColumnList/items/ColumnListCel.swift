//
//  ColumnListCel.swift
//  petit
//
//  Created by Jz D on 2021/6/8.
//  Copyright © 2021 swift. All rights reserved.
//

import UIKit

import NSObject_Rx




class ColumnListCel: UITableViewCell {
    
    
    
    @IBOutlet weak var selectedImg: UIButton!

    
    var hasChoosen: Bool?
    
    
    var index: Int?
    
    
    
    
    
    @IBOutlet weak var img: UIImageView!
    
    
    
    @IBOutlet weak var title: UILabel!
    
    
    
    @IBOutlet weak var modifyTimeL: UILabel!
    
    
    
    @IBOutlet weak var playTotalL: UILabel!
    
    
    
    
    func data(config m: Column_detail_oreo, index idx: Int, selected choosen: Bool?){
        
        
        ///
        
        // img.kf.imgX(with: m.cover)
        title.text = m.title
        
        
        modifyTimeL.text = m.modifyTime
        playTotalL.text = String(m.playTotal)
        
        ///
        
        index = idx
        
        if let clicked = choosen{
            selectedImg.isHidden = false
            selectedImg.isSelected = clicked
        }
        else{
            selectedImg.isHidden = true
        }
        
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        selectedImg.isHidden = true
        selectedImg.setImage(UIImage(named: "1001_dot_blank"), for: .normal)
        
        selectedImg.setImage(UIImage(named: "1001_dot_blank_selected"), for: .selected)
        

        
        modifyTimeL.font = UIFont.regular(ofSize: 12)
        modifyTimeL.textColor = UIColor(rgb: 0x9397A1)
        
        
        playTotalL.font = UIFont.regular(ofSize: 12)
        playTotalL.textColor = UIColor(rgb: 0x9397A1)
        
        
        title.font = UIFont.regular(ofSize: 16)
        title.textColor = UIColor(rgb: 0x1A1B1C)
        
        
        ///
        
        ///
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
}
