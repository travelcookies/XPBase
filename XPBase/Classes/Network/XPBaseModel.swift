//
//  XPBaseModel.swift
//  SZParking
//
//  Created by nbfujx on 2020/8/10.
//  Copyright © 2020 ningbokubin. All rights reserved.
//

import HandyJSON
import UIKit

/// 基础响应数据模型（XP 命名空间版本）
/// 用于解析服务端返回的通用JSON数据结构
///
/// 使用示例：
/// ```swift
/// // 定义自定义数据模型
/// struct XPUser: HandyJSON {
///     var id: Int?
///     var name: String?
/// }
///
/// // 使用基础模型解析响应
/// func handleResponse(jsonData: [String: Any]) {
///     if let model = JSONDeserializer<XPBaseModel<XPUser>>.deserializeFrom(dict: jsonData) {
///         if model.code == "1" {
///             let user = model.data
///             print("用户名称: \(user?.name ?? "")")
///         } else {
///             print("请求失败: \(model.msg ?? "")")
///         }
///     }
/// }
/// ```
public class XPBaseModel<T>: NSObject, HandyJSON {
    /// 响应状态码
    public var code: String?
    /// 错误码（备用字段）
    public var errCode: String?
    /// 服务器响应时间戳
    public var time: Int?
    /// 响应消息（用于展示错误提示等）
    public var msg: String?
    /// 响应数据（泛型类型，根据业务需求自定义）
    public var data: T?
    override public required init() {}
}

/// 简单的状态码消息模型（XP 命名空间版本）
/// 适用于只需要状态码和消息的场景，如删除、更新等操作
///
/// 使用示例：
/// ```swift
/// func handleSimpleResponse(jsonData: [String: Any]) {
///     if let model = JSONDeserializer<XPCodeMsgModel>.deserializeFrom(dict: jsonData) {
///         if model.code == 1 {
///             print("操作成功")
///         } else {
///             print("操作失败: \(model.msg ?? "")")
///         }
///     }
/// }
/// ```
public class XPCodeMsgModel: NSObject, HandyJSON {
    /// 状态码（默认-1表示未初始化）
    public var code: Int = -1
    /// 消息描述
    public var msg: String?
    override public required init() {}
}

/// 分页列表数据模型（XP 命名空间版本）
/// 用于解析服务端返回的分页数据结构
///
/// 使用示例：
/// ```swift
/// // 定义列表项模型
/// struct XPProduct: HandyJSON {
///     var id: Int?
///     var name: String?
///     var price: Double?
/// }
///
/// // 解析分页响应
/// func handleListResponse(jsonData: [String: Any]) {
///     if let model = JSONDeserializer<XPBaseListModel<XPProduct>>.deserializeFrom(dict: jsonData) {
///         let products = model.records
///         print("当前页数据量: \(products.count)")
///         print("总记录数: \(model.total)")
///         print("总页数: \(model.pages)")
///         print("当前页码: \(model.current)")
///         print("每页大小: \(model.size)")
///     }
/// }
/// ```
public class XPBaseListModel<T>: HandyJSON {
    /// 当前页数据列表
    public var records = [T]()
    /// 总页数
    public var pages: Int = 0
    /// 当前页码
    public var current: Int = 0
    /// 总记录数
    public var total: Int = 0
    /// 每页大小
    public var size: Int = 0

    public required init() {}
}