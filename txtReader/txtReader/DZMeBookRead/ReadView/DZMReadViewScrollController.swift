//
//  DZMReadViewScrollController.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class DZMReadViewScrollController: DZMViewController,UITableViewDelegate,UITableViewDataSource {

    /// 当前主控制器
    weak var vc:DZMReadController!
    
    /// 顶部状态栏
    private var topView = DZMReadViewStatusTopView()
    
    /// 阅读视图
    private var tableView = DZMTableView()
    
    /// 底部状态栏
    private var bottomView = DZMReadViewStatusBottomView()
    
    /// 当前阅读章节ID列表(只会存放本次阅读的列表)
    private var chapterIDs = [NSNumber]()
    
    /// 当前正在加载的章节
    private var loadChapterIDs = [NSNumber]()
    
    /// 当前阅读的章节列表,通过已有的章节ID列表,来获取章节模型。
    private var chapterModels = [String:DZMReadChapterModel]()
    
    /// 记录滚动坐标
    private var scrollPoint:CGPoint!
    
    /// 是否为向上滚动
    private var isScrollUp = true
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        guard let record = vc.readModel.recordModel else{
            return
        }
        // 阅读记录开始阅读
        chapterIDs.append(record.chapterModel.id)
        
        // 刷新阅读进度
        reloadProgress()
        
        // 定位上次阅读位置
        tableView.scrollToRow(at: record.page.ip, at: .top, animated: false)
        
        addSubviews()
    }
    
    func addSubviews() {
        
        // 阅读使用范围
        let readRect = READ_RECT
        
        // 顶部状态栏
        topView.bookName.text = vc.readModel.bookName
        if let record = vc.readModel.recordModel{
            topView.chapterName.text = record.chapterModel.name
        }
        
        view.addSubview(topView)
        topView.frame = CGRect(x: readRect.minX, y: readRect.minY, width: readRect.width, height: READ_STATUS_TOP_VIEW_HEIGHT)
        
        // 阅读视图
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.frame = READ_VIEW_RECT
        
        // 底部状态栏
        view.addSubview(bottomView)
        bottomView.frame = CGRect(x: readRect.minX, y: readRect.maxY - READ_STATUS_BOTTOM_VIEW_HEIGHT, width: readRect.width, height: READ_STATUS_BOTTOM_VIEW_HEIGHT)
    }
    
    // MARK: UITableViewDelegate,UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return chapterIDs.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let chapterID = chapterIDs[section]
        
        // 获取章节内容模型
        let chapterModel = GetChapterModel(chapterID: chapterID)
        
        // 有数据则返回页数
        let cnt = chapterModel?.pageCount
        return cnt.intVal
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let chapterID = chapterIDs[indexPath.section]
        
        let chapterModel = GetChapterModel(chapterID: chapterID)
        
        let pageModel = chapterModel!.pageModels[indexPath.row]
        
        // 是否为书籍首页
        if pageModel.isHomePage {
            
            let cell = DZMReadHomeViewCell.cell(tableView)
            
            cell.homeView.readModel = vc.readModel
            
            return cell
            
        }else{
            
            let cell = DZMReadViewCell.cell(tableView)
            
            cell.pageModel = pageModel
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let chapterID = chapterIDs[indexPath.section]
        
        let chapterModel = GetChapterModel(chapterID: chapterID)
        
        return chapterModel!.pageModels[indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return SPACE_MIN_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let chapterModel = chapterModels[chapterIDs[section].stringValue]
        
        // 预加载上一章
        preloadingPrevious(chapterModel)
        
        // 预加载下一章
        preloadingNext(chapterModel)
    }
    
    /// 书籍首页将要出现
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard indexPath.row == 0 else{ return }
        
        let chapterID = chapterIDs[indexPath.section]
        
        let chapterModel = GetChapterModel(chapterID: chapterID)
        
        let pageModel = chapterModel!.pageModels[indexPath.row]
        
        if pageModel.isHomePage {
            
            topView.isHidden = true
            
            bottomView.isHidden = true
        }
    }
    
    /// 书籍首页消失
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == 0 else{ return }
        
        let chapterID = chapterIDs[indexPath.section]
        
        let chapterModel = GetChapterModel(chapterID: chapterID)
        
        let pageModel = chapterModel!.pageModels[indexPath.row]
        
        if pageModel.isHomePage {
            
            topView.isHidden = false
            
            bottomView.isHidden = false
        }
    }
    
    
    // MARK: 监控滚动以及拖拽
    
    // 开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
 
        // 隐藏菜单
        vc.readMenu.showMenu(isShow: false)
        
        // 重置属性
        isScrollUp = true
        scrollPoint = CGPoint.zero
    }
    
    // 结束拖拽
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // 更新阅读记录
        updateReadRecord(isRollingUp: isScrollUp)
    }
    
    // 开始减速
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        // 更新阅读记录
        updateReadRecord(isRollingUp: isScrollUp)
    }
    
    // 结束减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // 更新阅读记录
        updateReadRecord(isRollingUp: isScrollUp)
    }
    
    // 正在滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollPoint == nil { return }
        
        let point = scrollView.panGestureRecognizer.translation(in: scrollView)
        
        if point.y < scrollPoint.y { // 上滚
            
            isScrollUp = true
            
        }else if point.y > scrollPoint.y { // 下滚
            
            isScrollUp = false
            
        }else{ }
        
        // 记录坐标
        scrollPoint = point
    }
    
    // MARK: 阅读记录以及进度
    
    /// 更新阅读记录(滚动模式) isRollingUp:是否为往上滚动
    private func updateReadRecord(isRollingUp:Bool) {
        
        // 异步更新(推荐使用异步)
        DispatchQueue.global().async { [weak self] () in
            
            if let ips = self?.tableView.indexPathsForVisibleRows, !ips.isEmpty, let record = self?.vc.readModel.recordModel {
                    
                    let indexPath:IndexPath = isRollingUp ? ips.last! : ips.first!
                    
                    let chapterID = self?.chapterIDs[indexPath.section]
                    
                    let chapterModel = self?.GetChapterModel(chapterID: chapterID!)
                    
                    record.modify(chapterModel: chapterModel, page: indexPath.row)
                    
                    Sand.readRecordCurrentChapterLocation = record.locationFirst.intValue
                        
                    DispatchQueue.main.async { [weak self] () in
                        
                        self?.topView.chapterName.text = chapterModel?.name
                        
                        self?.reloadProgress()
                    }
            }
        }
    }
    
    /// 刷新阅读进度显示
    private func reloadProgress() {
        switch DZMReadConfigure.shared.progressType {
        case .total:
            // 总进度
            
            // 当前阅读进度
            let progress:Float = vc.readModel.progress(readTotal: vc.readModel.recordModel)
            
            // 显示进度
            bottomView.progress.text = progress.readTotalProgress 
        default:
            // 分页进度
            if let record = vc.readModel.recordModel{
                bottomView.progress.text = "\(record.page.intValue + 1)/\(record.chapterModel!.pageCount.intValue)"
            }
            // 显示进度
            
            
        }
      
    }
    
    // MARK: 获得阅读数据
    
    /// 获取章节内容模型
    private func GetChapterModel(chapterID:NSNumber) ->DZMReadChapterModel? {
        
        var chapterModel:DZMReadChapterModel? = nil
        
        if chapterModels.keys.contains(chapterID.stringValue) { // 内存中存在章节内容
            
            chapterModel = chapterModels[chapterID.stringValue]
            
        }else{ // 内存中不存在章节列表
            
            // 检查是否存在章节内容

            // 存在
            if DZMReadChapterModel.isExist(bookID: vc.readModel.bookID, chapterID: chapterID){
                
                chapterModel = DZMReadChapterModel.model(bookID: vc.readModel.bookID, chapterID: chapterID)
                
                chapterModels[chapterID.stringValue] = chapterModel
            }
        }
        
        return chapterModel
    }
    
    
    // MARK: 预加载数据
    
    /// 预加载上一个章节
    private func preloadingPrevious(_ chapterModel:DZMReadChapterModel!) {
   
        // 章节ID
        let chapterID = chapterModel.previousChapterID
        
        // 是否有章节 || 是否为第一章 || 是否正在加载 || 是否已经存在阅读列表
        if (chapterModel == nil) || chapterModel.isFirstChapter || loadChapterIDs.contains(chapterID!) || chapterIDs.contains(chapterID!) { return }
        
        // 加入加载列表
        loadChapterIDs.append(chapterID!)
        
        // 书籍ID
        let bookID = chapterModel.bookID
        
        // 预加载下一章
        DispatchQueue.global().async { [weak self] () in
            
            // 检查是否存在章节内容
            let isExist = DZMReadChapterModel.isExist(bookID: bookID, chapterID: chapterID)
            
            // 存在
            if isExist{
                
                // 章节内容
                var tempChapterModel:DZMReadChapterModel!
                
                // 获取章节数据
                if !isExist {
                
                    tempChapterModel = DZMReadTextFastParser.parser(readModel: self?.vc.readModel, chapterID: chapterID)
                    
                }else{

                    tempChapterModel = DZMReadChapterModel.model(bookID: bookID, chapterID: chapterID!)
                }
            
                // 加入阅读内容列表
                self?.chapterModels[chapterID!.stringValue] = tempChapterModel
                
                DispatchQueue.main.async { [weak self] () in
                    
                    if self != nil {
                        
                        // 当前章节索引
                        let previousIndex = max(0, (self!.chapterIDs.firstIndex(of: chapterModel.id)! - 1))
                        
                        // 加载列表索引
                        let loadIndex = self!.loadChapterIDs.firstIndex(of: chapterID!)!
                        
                        // 阅读章节ID列表加入
                        self?.chapterIDs.insert(chapterID!, at: previousIndex)
                        
                        // 移除加载列表
                        self?.loadChapterIDs.remove(at: loadIndex)
                        
                        // 刷新
                        self?.tableView.reloadData()
                        
                        // 定位
                        self?.tableView.contentOffset = CGPoint(x: 0, y: self!.tableView.contentOffset.y + tempChapterModel.pageTotalHeight)
                    }
                }
                
            }
        }
    }
    
    /// 预加载下一个章节
    private func preloadingNext(_ chapterModel:DZMReadChapterModel!) {
        
        // 章节ID
        let chapterID = chapterModel.nextChapterID
        
        // 是否有章节 || 是否为最后一章 || 是否正在加载 || 是否已经存在阅读列表
        if (chapterModel == nil) || chapterModel.isLastChapter || loadChapterIDs.contains(chapterID!) || chapterIDs.contains(chapterID!) { return }
        
        // 加入加载列表
        loadChapterIDs.append(chapterID!)
        
        // 书籍ID
        let bookID = chapterModel.bookID
        
        // 预加载下一章
        DispatchQueue.global().async { [weak self] () in
            
            // 检查是否存在章节内容
            let isExist = DZMReadChapterModel.isExist(bookID: bookID, chapterID: chapterID)
            
            // 存在
            if isExist{
                
                // 章节内容
                var tempChapterModel:DZMReadChapterModel!
                
                // 获取章节数据
                if !isExist {
                
                    tempChapterModel = DZMReadTextFastParser.parser(readModel: self?.vc.readModel, chapterID: chapterID)
                
                }else{

                    tempChapterModel = DZMReadChapterModel.model(bookID: bookID, chapterID: chapterID!)
                }
                
                // 加入阅读内容列表
                self?.chapterModels[chapterID!.stringValue] = tempChapterModel
                
                DispatchQueue.main.async { [weak self] () in
                    
                    if self != nil {
                        
                        // 当前章节索引
                        let nextIndex = self!.chapterIDs.firstIndex(of: chapterModel.id)! + 1
                        
                        // 加载列表索引
                        let loadIndex = self!.loadChapterIDs.firstIndex(of: chapterID!)!
                        
                        // 阅读章节ID列表加入
                        self?.chapterIDs.insert(chapterID!, at: nextIndex)
                        
                        // 移除加载列表
                        self?.loadChapterIDs.remove(at: loadIndex)
                        
                        // 刷新
                        self?.tableView.insertSections(IndexSet(integer: nextIndex), with: .none)
                    }
                }
                
            }
        }
    }
}
