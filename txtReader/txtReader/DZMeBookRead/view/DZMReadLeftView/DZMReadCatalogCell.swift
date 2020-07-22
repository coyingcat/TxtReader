//
//  ReadCatalogCell.swift

//
//  
//

import UIKit

class ReadCatalogCell: UITableViewCell {

    private(set) var chapterName = UILabel()
    
    private(set) lazy var spaceLine = SpaceLine(contentView, COLOR_230_230_230)
    
    class func cell(_ tableView:UITableView) ->ReadCatalogCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ReadCatalogCell")
        
        if cell == nil {
            
            cell = ReadCatalogCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "ReadCatalogCell")
        }
        
        return cell as! ReadCatalogCell
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = UIColor.clear
        
        chapterName.font = FONT_SA_14
        chapterName.textColor = COLOR_145_145_145
        contentView.addSubview(chapterName)

    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let w = frame.size.width
        let h = frame.size.height
        
        chapterName.frame = CGRect(x: SPACE_SA_15, y: 0, width: w - SPACE_SA_30, height: h)
        
        spaceLine.frame = CGRect(x: SPACE_SA_15, y: h - SPACE_LINE, width: w - SPACE_SA_30, height: SPACE_LINE)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
