//
//  ColumnListHeader.swift
//  petit
//
//  Created by Jz D on 2021/6/8.
//  Copyright © 2021 swift. All rights reserved.
//

import UIKit


import CoreText

import SnapKit

protocol ColumnListHeaderProxy: AnyObject {

    func expand(columnHeader show: Bool)

}



class ColumnListHeader: UIView {
    
    
    weak var delegate: ColumnListHeaderProxy?
    
    
    lazy var top = UIImageView()
    lazy var avatar = UIImageView()
    lazy var nick = UILabel()
    
    lazy var rhsBottom = UILabel()
    lazy var midTitle = UILabel()
    lazy var midTxt = FrameLabel()
    
    
    lazy var playTotalL = UILabel()
    
    
    lazy var cancelB: UIButton = {
        let b = UIButton()
        b.isHidden = true
        b.setTitle("取消", for: .normal)
        b.titleLabel?.font = UIFont.regular(ofSize: 14)
        b.setTitleColor(UIColor(rgb: 0xC3C3C3), for: .normal)
        return b
    }()
    
    
    
    
    lazy var tinyMark = UIImageView(image: UIImage(named: "1_1001_tiny_Bookmarks"))
    lazy var tinyPlay = UIImageView(image: UIImage(named: "1_1001_tiny_play"))
    
    var top_theBottomConstraint: ConstraintMakerEditable?
    
    var topX_bottomY: CGFloat = 170
    
    var topX_bottomY_second: CGFloat?
    
    lazy var expandB: UIButton = {
        let b = UIButton()
        b.isHidden = true
        b.setTitle("展开", for: .normal)
        b.setTitle("收起", for: .selected)
        b.setTitleColor(UIColor(rgb: 0x0080FF), for: .normal)
        b.titleLabel?.font = UIFont.regular(ofSize: 14)
        return b
    }()
    
    
    
    var changed = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layouts()
        
        events()
    }
    
    
    
    func layouts(){
        backgroundColor = UIColor.white
        let belowTitle = UILabel()
        belowTitle.text = "内容列表"
        belowTitle.font = UIFont.semibold(ofSize: 16)
        belowTitle.textColor = UIColor(rgb: 0x1A1B1C)
        
        
        
        let lineBg = UIView()
        lineBg.backgroundColor = UIColor(rgb: 0xF9F9F9)
        
       // top.layer.debug()
        rhsBottom.text = "66"
        top.clipsToBounds = true
        top.contentMode = .scaleAspectFill
        
        avatar.clipsToBounds = true
        avatar.contentMode = .scaleAspectFill
        
        
        midTitle.textColor = UIColor(rgb: 0x1A1B1C)
        midTitle.font = UIFont.regular(ofSize: 20)
        
        
        nick.textColor = UIColor.white
        nick.font = UIFont.regular(ofSize: 14)
        
        
        
        playTotalL.textColor = UIColor.white
        
        playTotalL.font = UIFont.regular(ofSize: 14)
        
        
        playTotalL.textAlignment = .left
        
        
        addSubs([ belowTitle, lineBg, top,
                  cancelB,
                  midTxt, midTitle, expandB ])
        top.addSubs([ rhsBottom, tinyMark, tinyPlay,
                      avatar , nick , playTotalL])
        
        
        top.snp.makeConstraints { m in
            m.leading.top.trailing.equalToSuperview()
          //  m.height.equalTo(160)
            top_theBottomConstraint = m.bottom.equalToSuperview().offset(topX_bottomY.neg)
        }
        
        
        belowTitle.snp.makeConstraints { m in
            m.leading.equalToSuperview().offset(16)
            m.bottom.equalToSuperview().offset(-8)
        }
        
        midTitle.snp.makeConstraints { m in
            m.leading.equalToSuperview().offset(16)
            m.trailing.equalToSuperview().offset(-16)
            m.top.equalTo(top.snp.bottom).offset(16)
            m.height.equalTo(28)
        }
        
        lineBg.snp.makeConstraints { m in
            m.height.equalTo(8)
            m.leading.trailing.equalToSuperview()
            m.bottom.equalToSuperview().offset(-46)
        }
        
        
   
        
        cancelB.snp.makeConstraints { m in
            m.centerY.equalTo(belowTitle)
            m.trailing.equalToSuperview().offset(-16)
        }
        

        let offset: CGFloat = 16
        midTxt.snp.makeConstraints { m in
            m.leading.trailing.equalTo(midTitle)
            m.bottom.equalTo(lineBg.snp.top).offset(offset.neg)
            m.top.equalTo(midTitle.snp.bottom).offset(offset)
        }
        

        
        avatar.snp.makeConstraints { m in
            m.leading.equalToSuperview().offset(16)
            m.bottom.equalToSuperview().offset(16.neg)
            m.size.equalTo(CGSize(width: 32, height: 32))
        }
        
        nick.snp.makeConstraints { m in
            m.leading.equalTo(avatar.snp.trailing).offset(8)
            m.bottom.equalTo(avatar)
        }
        
        
  
        playTotalL.snp.makeConstraints { m in
            m.leading.equalTo(tinyPlay.snp.trailing)
            m.trailing.equalToSuperview().offset(-16)
            m.centerY.equalTo(tinyPlay)
        }
        
        
        tinyPlay.snp.makeConstraints { m in
            m.trailing.equalToSuperview().offset(-39)
            m.bottom.equalToSuperview().offset(-18)
            m.size.equalTo(CGSize(width: 14, height: 14))
        }
        
        
        expandB.snp.makeConstraints { m in
            m.trailing.equalToSuperview().offset(29.neg)
            m.bottom.equalTo(lineBg.snp.top).offset(offset.neg)
            m.size.equalTo(CGSize(width: 28, height: 20))
        }
    }
    
    
    
    
    
    
    func events(){
        
        

        

        expandB.rx.tap.subscribeOo { () in
            
            let choosenBefore = self.expandB.isSelected
                
            self.midTxt.zero.isHidden = (choosenBefore == false)
            self.midTxt.one.isHidden = choosenBefore
            
            self.expandB.isSelected.toggle()
            self.delegate?.expand(columnHeader: (choosenBefore == false))
            if choosenBefore{
                self.top_theBottomConstraint?.constraint.update(offset: self.topX_bottomY.neg)
            }
            else if let h = self.topX_bottomY_second{
                    self.top_theBottomConstraint?.constraint.update(offset: h.neg)
            }
            self.layoutIfNeeded()
            
        }.disposed(by: rx.disposeBag)
        
        
        
        NotificationCenter.default.rx
            .notification(.columnExpand)
            .takeUntil(self.rx.deallocated).subscribeOo(onNext: { (noti) in
                guard let h = noti.object as? CGFloat else{
                    return
                }
                self.topX_bottomY_second = (self.topX_bottomY + h - 60)
        }).disposed(by: rx.disposeBag)
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}







extension ColumnListHeader{
    
    func update(dat m: Column_detail){
        
        midTitle.text = m.title
        

        if let intro = m.introduction{
            
            let page = intro.plainX
            let calculatedSize = page.height(bound: 3000)
            let siZ = CGSize(width: UI.std.width - CGFloat( 16 * 2 ), height: calculatedSize.height * 3)
            
            // 建立 core text 文本
            let framesetter = CTFramesetterCreateWithAttributedString(page)
            let path = CGPath(rect: CGRect(origin: CGPoint.zero, size: siZ), transform: nil)
            let frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
            
            if let lines = CTFrameGetLines(frameRef) as? [CTLine], lines.count > 2{
                    topX_bottomY += 20
                    top_theBottomConstraint?.constraint.update(offset: topX_bottomY.neg)
                
                    let toHid = (  lines.count <= 3  )
                
                    midTxt.zero.showDot = (  toHid == false  )
                    expandB.isHidden = toHid
                    changed = true
            }
            
            print("9999999", siZ  )
            midTxt.one.frame = CGRect(x: 0, y: 0, width: siZ.width, height: siZ.height)
            
            
            midTxt.frameRef = frameRef
            midTxt.content = intro
            midTxt.zero.frame = CGRect(x: 0, y: 0, width: siZ.width, height: siZ.height)
            
            ///
            
            
            ///
            
        }
        
        /*
        
        top.kf.imgX(with: m.cover)
        nick.text = m.netname
        avatar.kf.imgX(with: m.profile_photo)
        
        playTotalL.text = String(m.playTotal)
        
        
        ///
        let hidMK = (m.hidMk || m.content.count == 0)
        columnHeadBtn.isHidden = hidMK
        
        
        */
        
    }
    
    
    
}










extension NSAttributedString{
   

    func height(bound h: CGFloat) -> CGSize{
        return boundingRect(with: CGSize(width: UI.std.width - CGFloat( 16*2 ), height: h), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size
    }
    
}
