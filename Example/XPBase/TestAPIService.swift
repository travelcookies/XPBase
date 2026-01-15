//
//  TestAPIService.swift
//  XPBase
//
//  Created by roc-mini on 2026/1/15.
//

import Moya
import HandyJSON

// 测试API服务枚举
enum TestAPIService {
    case getTestList(page: Int, pageSize: Int)
}

// MARK: - TargetType Protocol Implementation
extension TestAPIService: TargetType {
    var baseURL: URL {
        // 使用JSONPlaceholder作为测试API
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        switch self {
        case .getTestList:
            return "/posts"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTestList:
            return .get
        }
    }
    
    var sampleData: Data {
        // 提供模拟数据
        let mockData = [
            ["userId": 1, "id": 1, "title": "Test Title 1", "body": "Test Body 1"],
            ["userId": 1, "id": 2, "title": "Test Title 2", "body": "Test Body 2"]
        ]
        return try! JSONSerialization.data(withJSONObject: mockData, options: [])
    }
    
    var task: Task {
        switch self {
        case let .getTestList(page, pageSize):
            return .requestParameters(parameters: ["_page": page, "_limit": pageSize], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}

// 测试数据模型
struct TestItem: HandyJSON {
    var userId: Int?
    var id: Int?
    var title: String?
    var body: String?
}

// 测试数据列表模型
struct TestListModel: HandyJSON {
    var list: [TestItem]?
}
