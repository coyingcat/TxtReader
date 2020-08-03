//
//  ReadHomeViewCell.swift

//
//  
//

import UIKit

class ReadHomeViewCell: UITableViewCell {

    /// 书籍首页视图
    private(set) var homeView = ReadHomeView()
    
    class func cell(_ tableView:UITableView) ->ReadHomeViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ReadHomeViewCell")
        
        if cell == nil {
            
            cell = ReadHomeViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "ReadHomeViewCell")
        }
        
        return cell as! ReadHomeViewCell
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
