//
//  DZMReadHomeViewCell.swift

//
//  
//

import UIKit

class DZMReadHomeViewCell: UITableViewCell {

    /// 书籍首页视图
    private(set) var homeView = DZMReadHomeView()
    
    class func cell(_ tableView:UITableView) ->DZMReadHomeViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "DZMReadHomeViewCell")
        
        if cell == nil {
            
            cell = DZMReadHomeViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DZMReadHomeViewCell")
        }
        
        return cell as! DZMReadHomeViewCell
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = UIColor.clear
        
        
        
        // 书籍首页
        contentView.addSubview(homeView)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        homeView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
