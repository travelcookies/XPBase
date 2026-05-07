import UIKit

/// 跑马灯视图滚动方向
public enum XPMarqueeDirection {
    /// 向上滚动
    case upward
    /// 向左滚动
    case leftward
}

/// 跑马灯数据源协议
public protocol XPMarqueeViewDataSource: AnyObject {
    /// 返回数据项数量
    func numberOfItems(in marqueeView: XPMarqueeView) -> Int
    /// 返回指定位置的视图
    func marqueeView(_ marqueeView: XPMarqueeView, viewForItemAt index: Int) -> UIView
}

/// 跑马灯代理协议
public protocol XPMarqueeViewDelegate: AnyObject {
    /// 选中某一项时回调
    func marqueeView(_ marqueeView: XPMarqueeView, didSelectItemAt index: Int)
}

/// 跑马灯视图
/// 支持向上和向左两种滚动方向，支持自定义数据和点击事件
/// 
/// 使用示例：
/// ```swift
/// // 创建跑马灯视图（向左滚动）
/// let marqueeView = XPMarqueeView(direction: .leftward)
/// marqueeView.dataSource = self
/// marqueeView.delegate = self
/// marqueeView.timeInterval = 3 // 滚动间隔时间
/// marqueeView.itemSpacing = 10 // 间距
/// view.addSubview(marqueeView)
/// 
/// // 开始滚动
/// marqueeView.start()
/// 
/// // 暂停滚动
/// marqueeView.pause()
/// 
/// // MARK: - XPMarqueeViewDataSource
/// func numberOfItems(in marqueeView: XPMarqueeView) -> Int {
///     return dataArray.count
/// }
/// 
/// func marqueeView(_ marqueeView: XPMarqueeView, viewForItemAt index: Int) -> UIView {
///     let label = UILabel()
///     label.text = dataArray[index]
///     return label
/// }
/// 
/// // MARK: - XPMarqueeViewDelegate
/// func marqueeView(_ marqueeView: XPMarqueeView, didSelectItemAt index: Int) {
///     print("选中第 \(index) 项")
/// }
/// ```
public class XPMarqueeView: UIView {
    /// 数据源
    public weak var dataSource: XPMarqueeViewDataSource?
    /// 代理
    public weak var delegate: XPMarqueeViewDelegate?
    
    /// 滚动间隔时间（秒），默认 3 秒
    public var timeInterval: TimeInterval = 3
    /// 滚动速度，默认 50
    public var scrollSpeed: CGFloat = 50
    /// 项间距，默认 10
    public var itemSpacing: CGFloat = 10
    /// 数据少于等于 1 时是否停止滚动，默认 false
    public var stopWhenLessData: Bool = false
    /// 是否支持点击，默认 true
    public var touchEnabled: Bool = true
    
    private let direction: XPMarqueeDirection
    private var timer: Timer?
    private var currentIndex: Int = 0
    private var itemViews: [UIView] = []
    
    /// 初始化方法
    /// - Parameter direction: 滚动方向
    public init(direction: XPMarqueeDirection) {
        self.direction = direction
        super.init(frame: .zero)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        direction = .leftward
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        clipsToBounds = true
    }
    
    /// 开始滚动动画
    public func start() {
        stopTimer()
        reloadData()
        
        guard let dataSource = dataSource else { return }
        let count = dataSource.numberOfItems(in: self)
        
        if count > 0 && (!stopWhenLessData || count > 1) {
            scheduleTimer()
        }
    }
    
    public func pause() {
        stopTimer()
    }
    
    public func reloadData() {
        itemViews.forEach { $0.removeFromSuperview() }
        itemViews.removeAll()
        
        guard let dataSource = dataSource else { return }
        let count = dataSource.numberOfItems(in: self)
        
        for i in 0..<count {
            let itemView = dataSource.marqueeView(self, viewForItemAt: i)
            itemView.tag = i
            addSubview(itemView)
            
            if touchEnabled {
                let tap = UITapGestureRecognizer(target: self, action: #selector(itemTapped(_:)))
                itemView.addGestureRecognizer(tap)
                itemView.isUserInteractionEnabled = true
            }
            
            itemViews.append(itemView)
        }
        
        layoutItems()
    }
    
    private func layoutItems() {
        guard !itemViews.isEmpty else { return }
        
        if direction == .leftward {
            layoutHorizontalItems()
        } else {
            layoutVerticalItems()
        }
    }
    
    private func layoutHorizontalItems() {
        var x: CGFloat = 0
        
        for (index, view) in itemViews.enumerated() {
            view.frame = CGRect(x: x, y: 0, width: view.frame.width, height: bounds.height)
            x += view.frame.width + itemSpacing
            
            if index < itemViews.count - 1 {
                let nextView = dataSource?.marqueeView(self, viewForItemAt: index + 1)
                view.frame.size.width = nextView?.frame.width ?? view.frame.width
            }
        }
    }
    
    private func layoutVerticalItems() {
        var y: CGFloat = 0
        
        for view in itemViews {
            view.frame = CGRect(x: 0, y: y, width: bounds.width, height: view.frame.height)
            y += view.frame.height
        }
    }
    
    private func scheduleTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            self?.scroll()
        }
        timer?.fire()
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
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
    
    private func scrollLeftward() {
        guard let firstView = itemViews.first else { return }
        
        UIView.animate(withDuration: 0.3) {
            for view in self.itemViews {
                view.frame.origin.x -= firstView.frame.width + self.itemSpacing
            }
        } completion: { [weak self] _ in
            guard let self = self else { return }
            
            self.itemViews.removeFirst()
            let newIndex = (self.currentIndex + 1) % dataSource.numberOfItems(in: self)
            let newView = dataSource.marqueeView(self, viewForItemAt: newIndex)
            newView.tag = newIndex
            newView.frame.origin.x = self.bounds.width
            self.itemViews.append(newView)
            self.addSubview(newView)
            self.currentIndex = newIndex
        }
    }
    
    private func scrollUpward() {
        guard let firstView = itemViews.first else { return }
        
        UIView.animate(withDuration: 0.3) {
            for view in self.itemViews {
                view.frame.origin.y -= firstView.frame.height
            }
        } completion: { [weak self] _ in
            guard let self = self else { return }
            
            self.itemViews.removeFirst()
            let newIndex = (self.currentIndex + 1) % dataSource.numberOfItems(in: self)
            let newView = dataSource.marqueeView(self, viewForItemAt: newIndex)
            newView.tag = newIndex
            newView.frame.origin.y = self.bounds.height
            self.itemViews.append(newView)
            self.addSubview(newView)
            self.currentIndex = newIndex
        }
    }
    
    @objc private func itemTapped(_ tap: UITapGestureRecognizer) {
        if let view = tap.view {
            delegate?.marqueeView(self, didSelectItemAt: view.tag)
        }
    }
    
    deinit {
        stopTimer()
    }
}