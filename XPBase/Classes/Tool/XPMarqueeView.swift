import UIKit

/// 跑马灯视图滚动方向枚举
/// 
/// - upward: 向上滚动，适用于垂直列表滚动场景
/// - leftward: 向左滚动，适用于水平列表滚动场景
public enum XPMarqueeDirection {
    /// 向上滚动
    case upward
    /// 向左滚动
    case leftward
}

/// 跑马灯数据源协议
/// 
/// 用于为跑马灯视图提供数据支持，类似于 UITableViewDataSource
public protocol XPMarqueeViewDataSource: AnyObject {
    /// 返回数据项总数
    /// - Parameter marqueeView: 跑马灯视图实例
    /// - Returns: 数据项数量
    func numberOfItems(in marqueeView: XPMarqueeView) -> Int
    
    /// 返回指定位置的视图
    /// 
    /// 注意：该方法可能被复用机制调用，建议返回可复用的视图对象
    /// - Parameters:
    ///   - marqueeView: 跑马灯视图实例
    ///   - index: 数据项索引
    /// - Returns: 展示该数据项的视图
    func marqueeView(_ marqueeView: XPMarqueeView, viewForItemAt index: Int) -> UIView
}

/// 跑马灯代理协议
/// 
/// 用于响应跑马灯视图的用户交互事件
public protocol XPMarqueeViewDelegate: AnyObject {
    /// 选中某一项时回调
    /// - Parameters:
    ///   - marqueeView: 跑马灯视图实例
    ///   - index: 被选中的数据项索引
    func marqueeView(_ marqueeView: XPMarqueeView, didSelectItemAt index: Int)
}

/// 跑马灯视图组件
/// 
/// 支持向上和向左两种滚动方向，采用视图复用机制提升性能，支持自定义数据和点击事件。
/// 适用于公告滚动、轮播展示、消息通知等场景。
/// 
/// **核心特性：**
/// - 视图复用：滚动时复用已创建的视图，减少内存分配
/// - 尺寸缓存：缓存每个 item 的尺寸，避免重复计算
/// - 平滑动画：使用缓动曲线提升视觉体验
/// - 触摸支持：支持点击事件回调
/// 
/// **使用示例：**
/// ```swift
/// // 创建跑马灯视图（向左滚动）
/// let marqueeView = XPMarqueeView(direction: .leftward)
/// marqueeView.dataSource = self
/// marqueeView.delegate = self
/// marqueeView.timeInterval = 3 // 滚动间隔时间（秒）
/// marqueeView.itemSpacing = 10 // 项间距（点）
/// marqueeView.stopWhenLessData = false // 数据少于等于1时是否停止滚动
/// marqueeView.touchEnabled = true // 是否支持点击
/// view.addSubview(marqueeView)
/// 
/// // 开始滚动
/// marqueeView.start()
/// 
/// // 暂停滚动
/// marqueeView.pause()
/// 
/// // 重新加载数据
/// marqueeView.reloadData()
/// 
/// // MARK: - XPMarqueeViewDataSource
/// func numberOfItems(in marqueeView: XPMarqueeView) -> Int {
///     return dataArray.count
/// }
/// 
/// func marqueeView(_ marqueeView: XPMarqueeView, viewForItemAt index: Int) -> UIView {
///     let label = UILabel()
///     label.text = dataArray[index]
///     label.font = UIFont.systemFont(ofSize: 14)
///     label.textColor = .black
///     return label
/// }
/// 
/// // MARK: - XPMarqueeViewDelegate
/// func marqueeView(_ marqueeView: XPMarqueeView, didSelectItemAt index: Int) {
///     print("选中第 \(index) 项")
/// }
/// ```
public class XPMarqueeView: UIView {
    // MARK: - Public Properties
    
    /// 数据源，提供跑马灯所需的数据
    public weak var dataSource: XPMarqueeViewDataSource?
    
    /// 代理，响应跑马灯事件
    public weak var delegate: XPMarqueeViewDelegate?
    
    /// 滚动间隔时间（秒），默认 3 秒
    /// 
    /// 建议值：2-5 秒，根据内容复杂度和用户阅读需求调整
    public var timeInterval: TimeInterval = 3
    
    /// 滚动速度（点/秒），默认 50
    /// 
    /// 该属性目前预留，未来版本将支持基于速度的滚动模式
    public var scrollSpeed: CGFloat = 50
    
    /// 项间距（点），默认 10
    /// 
    /// 仅在向左滚动模式下生效，用于控制水平方向上相邻视图的间距
    public var itemSpacing: CGFloat = 10
    
    /// 数据少于等于 1 时是否停止滚动，默认 false
    /// 
    /// 设置为 true 时，当数据项数量 <= 1 时自动停止滚动
    public var stopWhenLessData: Bool = false
    
    /// 是否支持点击事件，默认 true
    /// 
    /// 设置为 true 时，每个视图会添加点击手势识别器
    public var touchEnabled: Bool = true
    
    // MARK: - Private Properties
    
    /// 滚动方向
    private let direction: XPMarqueeDirection
    
    /// 定时器，控制滚动节奏
    private var timer: Timer?
    
    /// 当前显示的起始索引
    private var currentIndex: Int = 0
    
    /// 当前显示在视图中的所有子视图
    private var itemViews: [UIView] = []
    
    /// 可复用视图池，用于缓存已移除的视图以提升性能
    private var reusableViews: [UIView] = []
    
    /// 缓存每个 item 的宽度（用于向左滚动模式）
    private var itemWidths: [CGFloat] = []
    
    /// 缓存每个 item 的高度（用于向上滚动模式）
    private var itemHeights: [CGFloat] = []
    
    // MARK: - Initialization
    
    /// 初始化方法
    /// - Parameter direction: 滚动方向
    public init(direction: XPMarqueeDirection) {
        self.direction = direction
        super.init(frame: .zero)
        setupView()
    }
    
    /// 从 Storyboard/XIB 初始化
    /// - Parameter coder: 编码对象
    public required init?(coder: NSCoder) {
        direction = .leftward
        super.init(coder: coder)
        setupView()
    }
    
    /// 设置视图基础属性
    private func setupView() {
        clipsToBounds = true
    }
    
    // MARK: - Public Methods
    
    /// 开始滚动动画
    /// 
    /// 调用此方法后，跑马灯将根据 `timeInterval` 设置的间隔自动滚动
    public func start() {
        stopTimer()
        reloadData()
        
        guard let dataSource = dataSource else { return }
        let count = dataSource.numberOfItems(in: self)
        
        if count > 0 && (!stopWhenLessData || count > 1) {
            scheduleTimer()
        }
    }
    
    /// 暂停滚动动画
    /// 
    /// 暂停后可以通过调用 `start()` 恢复滚动
    public func pause() {
        stopTimer()
    }
    
    /// 重新加载数据
    /// 
    /// 清空现有视图并从数据源重新获取数据，适用于数据更新场景
    public func reloadData() {
        stopTimer()
        
        // 将当前视图移到复用池
        itemViews.forEach {
            $0.removeFromSuperview()
            reusableViews.append($0)
        }
        itemViews.removeAll()
        itemWidths.removeAll()
        itemHeights.removeAll()
        
        guard let dataSource = dataSource else { return }
        let count = dataSource.numberOfItems(in: self)
        
        for i in 0..<count {
            // 优先从复用池获取视图，否则创建新视图
            let itemView = dequeueReusableView() ?? dataSource.marqueeView(self, viewForItemAt: i)
            configureView(itemView, at: i)
            addSubview(itemView)
            itemViews.append(itemView)
            
            // 缓存尺寸信息
            itemWidths.append(itemView.frame.width)
            itemHeights.append(itemView.frame.height)
        }
        
        layoutItems()
    }
    
    // MARK: - View Reuse
    
    /// 从复用池获取可复用的视图
    /// - Returns: 可复用的视图，如果复用池为空则返回 nil
    private func dequeueReusableView() -> UIView? {
        if reusableViews.isEmpty {
            return nil
        }
        return reusableViews.removeFirst()
    }
    
    /// 配置视图的通用属性
    /// 
    /// 设置视图的 tag 和点击手势（如果启用）
    /// - Parameters:
    ///   - view: 待配置的视图
    ///   - index: 视图对应的索引
    private func configureView(_ view: UIView, at index: Int) {
        view.tag = index
        
        if touchEnabled {
            // 避免重复添加手势识别器
            if view.gestureRecognizers?.isEmpty ?? true {
                let tap = UITapGestureRecognizer(target: self, action: #selector(itemTapped(_:)))
                view.addGestureRecognizer(tap)
            }
            view.isUserInteractionEnabled = true
        } else {
            view.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Layout
    
    /// 根据滚动方向执行布局
    private func layoutItems() {
        guard !itemViews.isEmpty else { return }
        
        if direction == .leftward {
            layoutHorizontalItems()
        } else {
            layoutVerticalItems()
        }
    }
    
    /// 水平方向布局（向左滚动模式）
    private func layoutHorizontalItems() {
        var x: CGFloat = 0
        
        for (index, view) in itemViews.enumerated() {
            let width = itemWidths[index]
            view.frame = CGRect(x: x, y: 0, width: width, height: bounds.height)
            x += width + itemSpacing
        }
    }
    
    /// 垂直方向布局（向上滚动模式）
    private func layoutVerticalItems() {
        var y: CGFloat = 0
        
        for (index, view) in itemViews.enumerated() {
            let height = itemHeights[index]
            view.frame = CGRect(x: 0, y: y, width: bounds.width, height: height)
            y += height
        }
    }
    
    // MARK: - Timer Management
    
    /// 启动定时器
    private func scheduleTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            self?.scroll()
        }
        timer?.fire()
    }
    
    /// 停止定时器
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Scroll Logic
    
    /// 执行滚动操作
    private func scroll() {
        guard let dataSource = dataSource else { return }
        let count = dataSource.numberOfItems(in: self)
        
        if count <= 1 { return }
        
        if direction == .leftward {
            scrollLeftward()
        } else {
            scrollUpward()
        }
    }
    
    /// 向左滚动
    private func scrollLeftward() {
        guard let firstView = itemViews.first, let dataSource = dataSource else { return }
        
        let scrollDistance = firstView.frame.width + itemSpacing
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            for view in self.itemViews {
                view.frame.origin.x -= scrollDistance
            }
        } completion: { [weak self] _ in
            guard let self = self else { return }
            
            // 将第一个视图移到复用池
            let removedView = self.itemViews.removeFirst()
            removedView.removeFromSuperview()
            self.reusableViews.append(removedView)
            
            // 计算新索引并获取视图
            let newIndex = (self.currentIndex + 1) % dataSource.numberOfItems(in: self)
            let reusedView = self.dequeueReusableView() ?? dataSource.marqueeView(self, viewForItemAt: newIndex)
            
            // 使用缓存的宽度设置新视图位置
            let requiredWidth = self.itemWidths[newIndex]
            reusedView.frame = CGRect(
                x: self.bounds.width,
                y: 0,
                width: requiredWidth,
                height: self.bounds.height
            )
            
            // 配置视图并添加到容器
            self.configureView(reusedView, at: newIndex)
            self.addSubview(reusedView)
            self.itemViews.append(reusedView)
            self.currentIndex = newIndex
        }
    }
    
    /// 向上滚动
    private func scrollUpward() {
        guard let firstView = itemViews.first, let dataSource = dataSource else { return }
        
        let scrollDistance = firstView.frame.height
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            for view in self.itemViews {
                view.frame.origin.y -= scrollDistance
            }
        } completion: { [weak self] _ in
            guard let self = self else { return }
            
            // 将第一个视图移到复用池
            let removedView = self.itemViews.removeFirst()
            removedView.removeFromSuperview()
            self.reusableViews.append(removedView)
            
            // 计算新索引并获取视图
            let newIndex = (self.currentIndex + 1) % dataSource.numberOfItems(in: self)
            let reusedView = self.dequeueReusableView() ?? dataSource.marqueeView(self, viewForItemAt: newIndex)
            
            // 使用缓存的高度设置新视图位置
            let requiredHeight = self.itemHeights[newIndex]
            reusedView.frame = CGRect(
                x: 0,
                y: self.bounds.height,
                width: self.bounds.width,
                height: requiredHeight
            )
            
            // 配置视图并添加到容器
            self.configureView(reusedView, at: newIndex)
            self.addSubview(reusedView)
            self.itemViews.append(reusedView)
            self.currentIndex = newIndex
        }
    }
    
    // MARK: - Event Handling
    
    /// 处理视图点击事件
    /// - Parameter tap: 点击手势识别器
    @objc private func itemTapped(_ tap: UITapGestureRecognizer) {
        if let view = tap.view {
            delegate?.marqueeView(self, didSelectItemAt: view.tag)
        }
    }
    
    // MARK: - Deinitialization
    
    /// 清理资源
    deinit {
        stopTimer()
        itemViews.forEach { $0.removeFromSuperview() }
        reusableViews.forEach { $0.removeFromSuperview() }
    }
}