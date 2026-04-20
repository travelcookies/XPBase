# MoyaProvider 扩展优化 - 产品需求文档

## Overview
- **Summary**: 修改 MoyaProvider+Extension.swift 文件，删除硬编码的 YProgressHub.share.loading() 调用，同时保留接口供应用层自定义加载逻辑
- **Purpose**: 提高代码的灵活性和可复用性，避免对特定加载库的硬依赖
- **Target Users**: 项目开发者和维护者

## Goals
- 删除 YProgressHub.share.loading() 硬编码调用
- 保留加载状态管理的接口，允许应用层自定义实现
- 确保不影响现有功能的正常运行

## Non-Goals (Out of Scope)
- 不修改其他网络请求逻辑
- 不改变现有的错误处理机制
- 不影响网络状态判断逻辑

## Background & Context
- 当前 MoyaProvider 扩展中硬编码了 YProgressHub.share.loading() 调用
- 这种硬依赖限制了代码的可移植性和灵活性
- 需要提供一种机制让应用层能够自定义加载逻辑

## Functional Requirements
- **FR-1**: 删除 YProgressHub.share.loading() 硬编码调用
- **FR-2**: 提供加载状态管理的回调接口
- **FR-3**: 确保现有 API 调用方式保持兼容

## Non-Functional Requirements
- **NFR-1**: 代码修改应保持最小化，只涉及必要的更改
- **NFR-2**: 接口设计应简洁明了，易于使用
- **NFR-3**: 向后兼容性应得到保证

## Constraints
- **Technical**: 必须保持 MoyaProvider 扩展的现有 API 签名不变
- **Dependencies**: 不引入新的依赖库

## Assumptions
- 应用层有能力实现自定义的加载逻辑
- 删除 YProgressHub 依赖不会影响其他功能

## Acceptance Criteria

### AC-1: 删除硬编码的 YProgressHub 调用
- **Given**: MoyaProvider+Extension.swift 文件存在
- **When**: 执行代码修改
- **Then**: 文件中不再包含 YProgressHub.share.loading() 调用
- **Verification**: `programmatic`

### AC-2: 保留加载状态管理接口
- **Given**: 修改后的代码
- **When**: 调用 request 方法并设置 showLoading 为 true
- **Then**: 应用层能够接收到加载开始和结束的通知
- **Verification**: `programmatic`

### AC-3: 现有 API 调用保持兼容
- **Given**: 现有代码使用 MoyaProvider 的 request 方法
- **When**: 替换为修改后的代码
- **Then**: 现有调用无需修改即可正常工作
- **Verification**: `programmatic`

## Open Questions
- [ ] 应用层如何注册自定义的加载逻辑？
- [ ] 是否需要提供默认的空实现？