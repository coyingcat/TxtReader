//
//  DZMReadCatalogView.swift

//
//  
//

import UIKit

@objc protocol DZMReadCatalogViewDelegate:NSObjectProtocol {
    
    /// 点击章节
    @objc func catalogViewClickChapter(catalogView:DZMReadCatalogView, chapterListModel:DZMReadChapterListModel)
}

class DZMReadCatalogView: UIView,UITableViewDelegate,UITableViewDataSource {

    /// 代理
    weak var delegate: DZMReadCatalogViewDelegate?
    
    /// 数据源
    var readModel: DZMReadModel?{
        
        didSet{
            
            tableView.reloadData()
            
            scrollRecord()
        }
    }
    
    private(set) var tableView = DZMTableView()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        tableView.delegate = self
        tableView.dataSource = self
        addSubview(tableView)
    }
    
    /// 滚动到阅读记录
    func scrollRecord() {
        
        if let read = readModel, let record = read.recordModel {
            
            tableView.reloadData()
       
            

            if let chapterListModel = (read.chapterListModels as NSArray).filtered(using: NSPredicate(format: "id == %@", record.chapterModel.id)).first as? DZMReadChapterListModel{

                tableView.scrollToRow(at: read.chapterListModels.firstIndex(of: chapterListModel)!.ip, at: .middle, animated: false)
            }
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        tableView.frame = bounds
    }
    
    // MARK: UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cnt = readModel?.chapterListModels.count
        return cnt.val
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = DZMReadCatalogCell.cell(tableView)
        guard let read = readModel else {
            return cell
        }
        // 章节
        let chapterListModel = read.chapterListModels[indexPath.row]
        
        // 章节名
        cell.chapterName.text = read.chapterListModels[indexPath.row].name
        
        // 日夜间
        if DZMUserDefaults.bool(READ_KEY_MODE_DAY_NIGHT) {
            
            cell.spaceLine.backgroundColor = COLOR_230_230_230.withAlphaComponent(0.1)
            
        }
        else{
            cell.spaceLine.backgroundColor = COLOR_230_230_230
            
        }
        
        // 阅读记录
        if let record = read.recordModel, record.chapterModel.id == chapterListModel.id {
            
            cell.chapterName.textColor = READ_COLOR_MAIN
            
        }
        else{
            cell.chapterName.textColor = COLOR_145_145_145
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return SPACE_SA_50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let read = readModel else {
            return
        }
        delegate?.catalogViewClickChapter(catalogView: self, chapterListModel: read.chapterListModels[indexPath.row])
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
