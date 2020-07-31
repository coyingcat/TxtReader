//
//  ReadMenu.swift

//
//  
//

import UIKit

@objc protocol ReadMenuDelegate:NSObjectProtocol {
    
    /// 菜单将要显示
    @objc func readMenuWillDisplay(readMenu:ReadMenu)
    
    /// 点击返回
    @objc func readMenuClickBack(readMenu:ReadMenu)
    
    /// 点击书签
    @objc func readMenuClickMark(readMenu:ReadMenu, topView:RMTopView, markButton:UIButton)
    
    /// 点击目录
    @objc func readMenuClickCatalogue(readMenu:ReadMenu)
    

    /// 点击上一章
    @objc func readMenuClickPreviousChapter(readMenu:ReadMenu)
    
    /// 点击下一章
    @objc func readMenuClickNextChapter(readMenu:ReadMenu)
    
    /// 拖拽章节进度(分页进度)
    @objc func readMenuDraggingProgress(readMenu:ReadMenu, toPage: Int)
    
    /// 拖拽章节进度(总文章进度,网络文章也可以使用)
    @objc func readMenuDraggingProgress(readMenu:ReadMenu, toChapterID:NSNumber, toPage: Int)
    

    /// 点击切换字体
    @objc func readMenuClickFont(readMenu:ReadMenu)
    
    /// 点击切换字体大小
    @objc func readMenuClickFontSize(readMenu:ReadMenu)
    
    /// 切换进度显示(分页 || 总进度)
    @objc func readMenuClickDisplayProgress(readMenu:ReadMenu)
    
    /// 点击切换间距
    @objc func readMenuClickSpacing(readMenu:ReadMenu)
    
    /// 点击切换翻页效果
    @objc func readMenuClickEffect(readMenu:ReadMenu)
}








class ReadMenu: NSObject,UIGestureRecognizerDelegate {

    /// 控制器
    private(set) weak var vc:ReadController!
    
    /// 阅读主视图
    private(set) weak var contentView:ReadContentView!
    
    /// 代理
    private(set) weak var delegate:ReadMenuDelegate!
    
    /// 菜单显示状态
    private(set) var isMenuShow:Bool = false
    
    /// 单击手势
    private(set) var singleTap:UITapGestureRecognizer!
    
    /// TopView
    private(set) var topView:RMTopView!
    
    /// BottomView
    private(set) var bottomView:RMBottomView!
    
    /// SettingView
    private(set) var settingView:RMSettingView!
    
  
    
    /// 禁用系统初始化
    private override init() { super.init() }
    
    /// 初始化
    convenience init(vc:ReadController!, delegate:ReadMenuDelegate!) {
        
        self.init()
        
        // 记录
        self.vc = vc
        self.contentView = vc.contentView
        self.delegate = delegate

        // 允许获取电量信息
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        
        
        // 添加单机手势
        initTapGestureRecognizer()
        

        
        // 初始化TopView
        initTopView()
        
        // 初始化SettingView
        initSettingView()
        
        // 初始化BottomView
        initBottomView()
    }
    
    // MARK: -- 添加单机手势
    
    /// 添加单机手势
    private func initTapGestureRecognizer() {
        
        // 单击手势
        singleTap = UITapGestureRecognizer(target: self, action: #selector(touchSingleTap))
        singleTap.numberOfTapsRequired = 1
        singleTap.delegate = self
        vc.contentView.addGestureRecognizer(singleTap)
    }
    
    // 触发单击手势
    @objc private func touchSingleTap() {
        
        showMenu(isShow: !isMenuShow)
    }
    
    // MARK: -- UIGestureRecognizerDelegate
    
    /// 点击这些控件不需要执行手势
    private let ClassStrings:[String] = ["RMTopView","RMBottomView","RMSettingView","RMFontSizeView", "RMFontTypeView","RMLightView","RMSpacingView","RMEffectTypeView","RMBGColorView","RMFuncView","RMProgressView","UIControl","UISlider","ASValueTrackingSlider"]
    
    /// 手势拦截
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var condition = true
        if let v = touch.view{
            let classString = String(describing: type(of: v))
            if ClassStrings.contains(classString) {
                condition = false
            }
        }
        return condition
    }
    

    
    // MARK: -- TopView
    
    /// 初始化TopView
    private func initTopView() {
        
        topView = RMTopView(read: self)
        
        topView.isHidden = !isMenuShow
        
        contentView.addSubview(topView)
        
        let y = isMenuShow ? 0 : -READ_MENU_TOP_VIEW_HEIGHT
        
        topView.frame = CGRect(x: 0, y: y, width: ScreenWidth, height: READ_MENU_TOP_VIEW_HEIGHT)
    }
    
    // MARK: -- BottomView
    
    /// 初始化BottomView
    private func initBottomView() {
        
        bottomView = RMBottomView(read: self)
    
        bottomView.isHidden = !isMenuShow
        
        contentView.addSubview(bottomView)
        
        let y = isMenuShow ? (ScreenHeight - READ_MENU_BOTTOM_VIEW_HEIGHT) : ScreenHeight
        
        bottomView.frame = CGRect(x: 0, y: y, width: ScreenWidth, height: READ_MENU_BOTTOM_VIEW_HEIGHT)
        
        
        // 绘制中间虚线(如果不需要虚线可以去掉自己加个分割线)
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.bounds = bottomView.bounds
        
        shapeLayer.position = CGPoint(x: bottomView.frame.width / 2, y: bottomView.frame.height / 2)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.strokeColor = READ_COLOR_MENU_COLOR.cgColor
        
        shapeLayer.lineWidth = SPACE_LINE
        
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        shapeLayer.lineDashPhase = 0
        
        shapeLayer.lineDashPattern = [NSNumber(value: 1), NSNumber(value: 2)]
        
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: 0, y: READ_MENU_PROGRESS_VIEW_HEIGHT))
        
        path.addLine(to: CGPoint(x: bottomView.frame.width, y: READ_MENU_PROGRESS_VIEW_HEIGHT))
        
        shapeLayer.path = path
        
        bottomView.layer.addSublayer(shapeLayer)
    }
    
    // MARK: -- SettingView
    
    /// 初始化SettingView
    private func initSettingView() {
        
        settingView = RMSettingView(read: self)
        
        settingView.isHidden = true
        
        contentView.addSubview(settingView)
        
        settingView.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: READ_MENU_SETTING_VIEW_TOTAL_HEIGHT)
    }
    
    // MARK: 菜单展示
    
    /// 动画是否完成
    private var isAnimateComplete:Bool = true
    
    func showMenu(isShow:Bool) {
        
        if isMenuShow == isShow || !isAnimateComplete {return}
        
        isAnimateComplete = false
        
        if isShow {
            delegate?.readMenuWillDisplay(readMenu: self)
        }
        
        isMenuShow = isShow
        
        showBottomView(isShow: isShow)

        showSettingView(isShow: false)
        
        showTopView(isShow: isShow) { [weak self] () in
            
            self?.isAnimateComplete = true
        }
    }
    
    /// TopView展示
    func showTopView(isShow:Bool, completion:AnimationCompletion? = nil) {
        
        if isShow { topView.isHidden = false }
        
        UIView.animate(withDuration: UnifySetting.animaTime, delay: 0, options: .curveEaseOut, animations: { [weak self] () in
            
            let y = isShow ? 0 : -READ_MENU_TOP_VIEW_HEIGHT
            
            self?.topView.frame.origin = CGPoint(x: 0, y: y)
            
        }) { [weak self] (isOK) in
            
            if !isShow { self?.topView.isHidden = true }
            
            completion?()
        }
    }
    
    /// BottomView展示
    func showBottomView(isShow:Bool, completion:AnimationCompletion? = nil) {
  
        if isShow { bottomView.isHidden = false }

        UIView.animate(withDuration: UnifySetting.animaTime, animations: { [weak self] () in
            
            let y = isShow ? (ScreenHeight - READ_MENU_BOTTOM_VIEW_HEIGHT) : ScreenHeight
            
            self?.bottomView.frame.origin = CGPoint(x: 0, y: y)
            
        }) { [weak self] (isOK) in
            
            if !isShow { self?.bottomView.isHidden = true }
            
            completion?()
        }
    }
    
    /// SettingView展示
    func showSettingView(isShow:Bool, completion:AnimationCompletion? = nil) {
      
        if isShow { settingView.isHidden = false }
        
        UIView.animate(withDuration: UnifySetting.animaTime, delay: 0, options: .curveEaseOut, animations: { [weak self] () in
            
            let y = isShow ? (ScreenHeight - READ_MENU_SETTING_VIEW_TOTAL_HEIGHT) : ScreenHeight
            
            self?.settingView.frame.origin = CGPoint(x: 0, y: y)
            
        }) { [weak self] (isOK) in
            
            if !isShow { self?.settingView.isHidden = true }
            
            completion?()
        }
    }
}
