//
//  ReadViewCell.swift

//
//  
//

import UIKit

class ReadViewCell: UITableViewCell {

    /// 阅读视图
    private var readView = ReadView()
    
    var pageModel:ReadPageModel?{
        didSet{
            
            readView.pagingModel = pageModel
            
            setNeedsLayout()
        }
    }
    
    class func cell(_ tableView:UITableView) ->ReadViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ReadViewCell")
        
        if cell == nil {
            
            cell = ReadViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "ReadViewCell")
        }
        
        return cell as! ReadViewCell
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = UIColor.clear
        
        
        
        // 阅读视图
        contentView.addSubview(readView)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
      
        // 分页顶部高度
        let y = pageModel?.headTypeHeight ?? SPACE_MIN_HEIGHT
        
        // 内容高度
        let h = pageModel?.contentSize.height ?? SPACE_MIN_HEIGHT

        readView.frame = CGRect(x: 0, y: y, width: READ_VIEW_RECT.width, height: h)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
