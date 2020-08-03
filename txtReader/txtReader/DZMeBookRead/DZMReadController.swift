//
//  ReadController.swift

//
//  
//

import UIKit

class ReadController: ViewController{

    // MARK: 数据相关
    
    /// 阅读对象
    let readModel:ReadModel
    
    
    // MARK: UI相关
    
    /// 阅读主视图
    var contentView = ReadContentView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
    
    /// 章节列表
    var leftView = ReadLeftView(frame: CGRect(x: -READ_LEFT_VIEW_WIDTH, y: 0, width: READ_LEFT_VIEW_WIDTH, height: ScreenHeight))
    
    /// 阅读菜单
    // 初始化菜单
    lazy var readMenu = ReadMenu(vc: self, delegate: self)
    
    /// 翻页控制器 (仿真)
    var pageViewController:UIPageViewController!
    
    /// 翻页控制器 (滚动)
    var scrollController:ReadViewScrollController!
    
    /// 翻页控制器 (无效果,覆盖)
    var coverController:CoverController!
    
    /// 非滚动模式时,当前显示 ReadViewController
    var currentDisplayController:ReadViewController?
    
    /// 用于区分正反面的值(勿动)
    
    var tempNumber = 1
    
    
    
    init(reading model: ReadModel) {
        readModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 初始化书籍阅读记录
        if let record = readModel.recordModel{
            update(read: record)
        }
        
        // 隐藏导航栏
        fd_prefersNavigationBarHidden = true
        
        // 禁止手势返回
        fd_interactivePopDisabled = true
        // 背景颜色
        view.backgroundColor = ReadConfigure.shared.bgColor
        
        // 初始化控制器
        creatPageController(displayController: getCurrentReadViewController(isUpdateFont: true))
        
        // 监控阅读长按视图通知
        monitorReadLongPressView()
        addSubviews()
    }
    


    func addSubviews(){
        
        // 目录侧滑栏
        leftView.catalogView.readModel = readModel
        leftView.catalogView.delegate = self
        leftView.markView.readModel = readModel
        leftView.markView.delegate = self
        
        view.addSubview(leftView)
        
        // 阅读视图
        
        contentView.delegate = self
        view.addSubview(contentView)
    }
    
    // MARK: 监控阅读长按视图通知
    
    // 监控阅读长按视图通知
    private func monitorReadLongPressView() {
        
        if ReadConfigure.shared.openLongPress {
            
            /// 监控阅读长按视图通知
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(longPressViewNotification(notification:)), name: .readLongPress, object: nil)
        }
    }
    
    // 处理通知
    @objc private func longPressViewNotification(notification:Notification) {
        
        // 隐藏菜单
        readMenu.showMenu(isShow: false)
        
        // 解析状态
        if let isOpen = notification.readLongPress.isOpen{
            coverController?.gestureRecognizerEnabled = isOpen
            pageViewController?.gestureRecognizerEnabled = isOpen
            readMenu.singleTap.isEnabled = isOpen
        }
    }
    
    
    
    deinit {
        
        // 移除阅读长按视图监控
        NotificationCenter.default.removeObserver(self, name: .readLongPress, object: nil)
        // 清理阅读控制器
        clearPageController()
    }
}



extension ReadController: ReadCatalogViewDelegate{
 
    
    // MARK: ReadCatalogViewDelegate
    
    /// 章节目录选中章节
    func catalogViewClickChapter(catalogView: ReadCatalogView, chapterListModel: ChapterBriefModel) {
        
        showLeftView(isShow: false)
        
        contentView.showCover(isShow: false)
        
        guard let record = readModel.recordModel, record.chapterModel.id != chapterListModel.id  else { return }
        
        goToChapter(chapterID: chapterListModel.id)
    }
 
}



    // MARK: ReadMarkViewDelegate
extension ReadController: ReadMarkViewDelegate{
    /// 书签列表选中书签
    func markViewClickMark(markView: ReadMarkView, markModel: ReadMarkModel) {
        
        showLeftView(isShow: false)
        
        contentView.showCover(isShow: false)
        
        goToChapter(chapterID: markModel.chapterID, location: markModel.location)
    }
}
    



extension ReadController: ReadContentViewDelegate{
    // MARK: ReadContentViewDelegate
    
    /// 点击遮罩
    func contentViewClickCover(contentView: ReadContentView) {
        
        showLeftView(isShow: false)
    }
}
    
    
extension ReadController: ReadMenuDelegate{
    
    // MARK: ReadMenuDelegate
    
    /// 菜单将要显示
    func readMenuWillDisplay(readMenu: ReadMenu) {
        
        // 检查当前内容是否包含书签
        readMenu.topView.checkForMark()
        
        // 刷新阅读进度
        readMenu.bottomView.progressView.reloadProgress()
    }
    
    /// 点击返回
    func readMenuClickBack(readMenu: ReadMenu) {
        
        // 清空坐标
        Sand.readRecordCurrentChapterLocation = nil
        
        // 返回
        navigationController?.popViewController(animated: true)
    }
    
    /// 点击书签
    func readMenuClickMark(readMenu: ReadMenu, topView: RMTopView, markButton: UIButton) {
        
        markButton.isSelected = !markButton.isSelected
        
        if markButton.isSelected {
            readModel.insetMark()
            
        }
        else{
            readModel.removeMark()
            
        }
        
        topView.updateMarkButton()
    }
    
    /// 点击目录
    func readMenuClickCatalogue(readMenu:ReadMenu) {
        
        showLeftView(isShow: true)
        
        contentView.showCover(isShow: true)
        
        readMenu.showMenu(isShow: false)
    }
    

    
    /// 点击上一章
    func readMenuClickPreviousChapter(readMenu: ReadMenu) {
        let first = readModel.recordModel?.isFirstChapter
        if first.ok == false, let record = readModel.recordModel, let previous = record.chapterModel.previousChapterID{
            
            goToChapter(chapterID: previous)
            
            // 检查当前内容是否包含书签
            readMenu.topView.checkForMark()
            
            // 刷新阅读进度
            readMenu.bottomView.progressView.reloadProgress()
        }
    }
    
    /// 点击下一章
    func readMenuClickNextChapter(readMenu: ReadMenu) {
        let last = readModel.recordModel?.isLastChapter
        if last.ok == false, let chapter = readModel.recordModel?.chapterModel.nextChapterID{
            goToChapter(chapterID: chapter)
            // 检查当前内容是否包含书签
            readMenu.topView.checkForMark()
            
            // 刷新阅读进度
            readMenu.bottomView.progressView.reloadProgress()
        }
    }
    
    /// 拖拽阅读记录
    func readMenuDraggingProgress(readMenu: ReadMenu, toPage: Int) {
        
        if readModel.recordModel?.page != toPage{
            
            readModel.recordModel?.page = toPage
            
            creatPageController(displayController: getCurrentReadViewController())
            
            // 检查当前内容是否包含书签
            readMenu.topView.checkForMark()
        }
    }
    
    /// 拖拽章节进度(总文章进度,网络文章也可以使用)
    func readMenuDraggingProgress(readMenu: ReadMenu, toChapterID: Int, toPage: Int) {

        // 不是当前阅读记录章节
        if toChapterID != readModel.recordModel?.chapterModel.id{
            
            goToChapter(chapterID: toChapterID, toPage: toPage)
            
            // 检查当前内容是否包含书签
            readMenu.topView.checkForMark()
        }
    }
    
    /// 切换进度显示(分页 || 总进度)
    func readMenuClickDisplayProgress(readMenu: ReadMenu) {
        
        creatPageController(displayController: getCurrentReadViewController())
    }
    
    /// 点击切换背景颜色
    func readMenuClickBGColor(readMenu: ReadMenu) {
        
        view.backgroundColor = ReadConfigure.shared.bgColor
        
        creatPageController(displayController: getCurrentReadViewController())
    }
    
    /// 点击切换字体
    func readMenuClickFont(readMenu: ReadMenu) {
        
        creatPageController(displayController: getCurrentReadViewController(isUpdateFont: true))
    }
    
    /// 点击切换字体大小
    func readMenuClickFontSize(readMenu: ReadMenu) {
        
        creatPageController(displayController: getCurrentReadViewController(isUpdateFont: true))
    }
    
    /// 点击切换间距
    func readMenuClickSpacing(readMenu: ReadMenu) {
        
        creatPageController(displayController: getCurrentReadViewController(isUpdateFont: true))
    }
    
    /// 点击切换翻页效果
    func readMenuClickEffect(readMenu: ReadMenu) {
        
        creatPageController(displayController: getCurrentReadViewController())
    }
    
    
    // MARK: 展示动画
    
    /// 辅视图展示
    func showLeftView(isShow:Bool, completion:AnimationCompletion? = nil) {
     
        if isShow { // leftView 将要显示
            
            // 刷新UI 
            leftView.updateUI()
            
            // 滚动到阅读记录
            leftView.catalogView.scrollRecord()
            
            // 允许显示
            leftView.isHidden = false
        }
        
        UIView.animate(withDuration: UnifySetting.animaTime, delay: 0, options: .curveEaseOut, animations: { [weak self] () in
            
            if isShow {
                
                self?.leftView.frame.origin = CGPoint.zero
                
                self?.contentView.frame.origin = CGPoint(x: READ_LEFT_VIEW_WIDTH, y: 0)
                
            }
            else{
                
                self?.leftView.frame.origin = CGPoint(x: -READ_LEFT_VIEW_WIDTH, y: 0)
                
                self?.contentView.frame.origin = CGPoint.zero
            }
            
        }) { [weak self] (isOK) in
            
            if !isShow {
                self?.leftView.isHidden = true
                
            }
            
            completion?()
        }
    }
    
    
}
