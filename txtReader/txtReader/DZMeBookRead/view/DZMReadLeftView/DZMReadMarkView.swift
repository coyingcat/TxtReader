//
//  DZMReadMarkView.swift

//
//  
//

import UIKit

@objc protocol DZMReadMarkViewDelegate:NSObjectProtocol {
    
    /// 点击章节
    @objc func markViewClickMark(markView:DZMReadMarkView, markModel:DZMReadMarkModel)
}

class DZMReadMarkView: UIView{
    
    /// 代理
    weak var delegate: DZMReadMarkViewDelegate?
    
    /// 数据源
    var readModel:DZMReadModel?{
        didSet{
            tableView.reloadData()
        }
    }
    
    private(set) var tableView = DZMTableView()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        alpha = 0
        tableView.delegate = self
        tableView.dataSource = self
        addSubview(tableView)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        tableView.frame = bounds
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}



extension DZMReadMarkView: UITableViewDelegate,UITableViewDataSource{
    
    
    // MARK: UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cnt = readModel?.markModels.count
        return cnt.val
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = DZMReadMarkCell.cell(tableView)
        
        // 设置数据
        if let mark = readModel?.markModels[indexPath.row]{
            cell.markModel = mark
        }
        
        // 日夜间
        if DZMUserDefaults.bool(READ_KEY_MODE_DAY_NIGHT) {
            cell.spaceLine.backgroundColor = COLOR_230_230_230.withAlphaComponent(0.1)
        }
        else{
            cell.spaceLine.backgroundColor = COLOR_230_230_230
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return READ_MARK_CELL_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let mark = readModel{
            delegate?.markViewClickMark(markView: self, markModel: mark.markModels[indexPath.row])
        }
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        readModel?.removeMark(index: indexPath.row)
        let mark = readModel?.markModels
        if mark.none{
            tableView.reloadData()
        }
        else{
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
}
