//
//  RMFontTypeView.swift

//
//  
//

import UIKit

class RMFontTypeView: RMBaseView {

    private var fontNames = ["系统","黑体","楷体","宋体"]
    
    private var items = [UIButton]()
    
    private var selectItem: UIButton?
    
    override init(frame: CGRect){
        super.init(frame: frame)

        
        backgroundColor = UIColor.clear
        
        let count = fontNames.count
        
        for i in 0..<count {
            
            let fontName = fontNames[i]
            
            let item = UIButton(type: .custom)
            item.tag = i
            item.layer.cornerRadius = SPACE_SA_6
            item.layer.borderColor = READ_COLOR_MENU_COLOR.cgColor
            item.layer.borderWidth = SPACE_SA_1
            item.titleLabel?.font = FONT_SA_12
            item.setTitle(fontName, for: .normal)
            item.setTitleColor(READ_COLOR_MENU_COLOR, for: .normal)
            item.setTitleColor(READ_COLOR_MAIN, for: .selected)
            item.addTarget(self, action: #selector(clickItem(_:)), for: .touchUpInside)
            addSubview(item)
            items.append(item)
            
            if i == ReadConfigure.shared.fontIndex.intValue {
                selectItem(item)
                
            }
        }
    }
    
    private func selectItem(_ item:UIButton) {
        
        selectItem?.isSelected = false
        
        selectItem?.layer.borderColor = READ_COLOR_MENU_COLOR.cgColor
        
        item.isSelected = true
        
        item.layer.borderColor = READ_COLOR_MAIN.cgColor
        
        selectItem = item
    }
    
    @objc private func clickItem(_ item:UIButton) {
        
        if selectItem == item { return }
        
        selectItem(item)
        
        ReadConfigure.shared.fontIndex = NSNumber(value: item.tag)
        
        ReadConfigure.shared.save()
        
        readMenu?.delegate?.readMenuClickFont(readMenu: readMenu)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let count = fontNames.count
        
        let w = frame.size.width
        let h = frame.size.height
        
        let itemW = SPACE_SA_70
        let itemH = SPACE_SA_30
        let itemY = (h - itemH) / 2
        let itemSpaceW = (w - CGFloat(count) * itemW) / (CGFloat(count - 1))
        
        for i in 0..<count {
            
            let item = items[i]
            item.frame = CGRect(x: CGFloat(i) * (itemW + itemSpaceW), y: itemY, width: itemW, height: itemH)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
