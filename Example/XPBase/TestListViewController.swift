//
//  TestListViewController.swift
//  XPBase
//
//  Created by roc-mini on 2026/1/15.
//

import UIKit
import Moya
import SnapKit

class TestListViewController: UIViewController {
    
    // MARK: - Properties
    
    // 表格视图
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        if #available(iOS 14.0, *) {
            tableView.dataSource = self
        } else {
            // Fallback on earlier versions
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TestCell")
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
        return tableView
    }()
    
    // 数据列表
    private var dataList: [TestItem] = []
    
    // 当前页码
    private var currentPage: Int = 1
    
    // 每页数量
    private let pageSize: Int = 10
    
    // Moya Provider
    private let provider = MoyaProvider<TestAPIService>()
    
    // 刷新控件
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        // 设置导航栏标题
        title = "API Test List"
        
        // 添加表格视图
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        // 添加刷新控件
        tableView.addSubview(refreshControl)
    }
    
    // MARK: - Data Loading
    
    // 刷新数据
    @objc private func refreshData() {
        currentPage = 1
        loadData()
    }
    
    // 加载更多数据
    private func loadMoreData() {
        currentPage += 1
        loadData()
    }
    
    // 加载数据
    private func loadData() {
        // 调用API获取数据
        provider.request(.getTestList(page: currentPage, pageSize: pageSize), model: [TestItem].self, showLoading: true) { [weak self] (result) in
            guard let self = self else { return }
            
            // 停止刷新动画
            self.refreshControl.endRefreshing()
            
            if let items = result {
                if self.currentPage == 1 {
                    // 刷新数据
                    self.dataList = items
                } else {
                    // 加载更多数据
                    self.dataList.append(contentsOf: items)
                }
                
                // 刷新表格
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource

@available(iOS 14.0, *)
extension TestListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath)
        let item = dataList[indexPath.row]
        
        // 设置单元格内容
        var content = cell.defaultContentConfiguration()
        content.text = item.title
        content.secondaryText = item.body
        cell.contentConfiguration = content
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TestListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 点击单元格的处理
        let item = dataList[indexPath.row]
        let alert = UIAlertController(title: item.title, message: item.body, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 当滚动到最后一行时加载更多数据
        if indexPath.row == dataList.count - 1 {
            loadMoreData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
