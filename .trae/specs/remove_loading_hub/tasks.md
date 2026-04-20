# MoyaProvider 扩展优化 - 实现计划

## [ ] Task 1: 分析现有代码结构
- **Priority**: P0
- **Depends On**: None
- **Description**: 
  - 分析 MoyaProvider+Extension.swift 文件的现有结构
  - 确定 YProgressHub.share.loading() 和 YProgressHub.share.hidden() 的调用位置
  - 理解当前的加载状态管理逻辑
- **Acceptance Criteria Addressed**: AC-1, AC-3
- **Test Requirements**:
  - `programmatic` TR-1.1: 确认 YProgressHub 调用的准确位置
  - `human-judgement` TR-1.2: 理解现有代码逻辑和依赖关系
- **Notes**: 确保理解完整的加载状态管理流程

## [ ] Task 2: 设计加载状态管理接口
- **Priority**: P0
- **Depends On**: Task 1
- **Description**: 
  - 设计一个加载状态管理的闭包属性
  - 定义加载开始和结束的回调方法
  - 确保接口设计简洁且易于使用
- **Acceptance Criteria Addressed**: AC-2, AC-3
- **Test Requirements**:
  - `programmatic` TR-2.1: 接口设计符合 Swift 最佳实践
  - `human-judgement` TR-2.2: 接口使用方式清晰明了
- **Notes**: 考虑使用静态属性或单例模式来存储回调

## [ ] Task 3: 实现加载状态管理逻辑
- **Priority**: P0
- **Depends On**: Task 2
- **Description**: 
  - 在 MoyaProvider 扩展中添加加载状态管理属性
  - 修改 request 方法，使用回调代替硬编码的 YProgressHub 调用
  - 确保加载开始和结束时都调用相应的回调
- **Acceptance Criteria Addressed**: AC-1, AC-2, AC-3
- **Test Requirements**:
  - `programmatic` TR-3.1: 成功删除 YProgressHub 硬编码调用
  - `programmatic` TR-3.2: 加载状态回调被正确调用
  - `programmatic` TR-3.3: 现有 API 调用保持兼容
- **Notes**: 确保在网络请求开始时调用加载开始回调，在请求结束时调用加载结束回调

## [ ] Task 4: 测试和验证
- **Priority**: P1
- **Depends On**: Task 3
- **Description**: 
  - 测试修改后的代码是否正常工作
  - 验证现有 API 调用是否保持兼容
  - 测试自定义加载逻辑的注册和调用
- **Acceptance Criteria Addressed**: AC-1, AC-2, AC-3
- **Test Requirements**:
  - `programmatic` TR-4.1: 代码编译通过，无语法错误
  - `programmatic` TR-4.2: 网络请求正常执行
  - `programmatic` TR-4.3: 加载状态回调被正确触发
  - `human-judgement` TR-4.4: 代码可读性和可维护性良好
- **Notes**: 测试不同场景下的加载状态管理，包括成功和失败的情况