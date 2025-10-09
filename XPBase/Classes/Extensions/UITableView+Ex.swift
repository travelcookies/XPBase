//
//  UITableView+Ex.swift
//  SZParking
//
//  Created by 林小鹏 on 2023/3/11.
//  Copyright © 2023 ningbokubin. All rights reserved.
//

import Foundation
import UIKit

public struct TableViewCellAppearance {
    // 边框样式枚举
    enum BorderStyle {
        case solid
        case dashed(pattern: [NSNumber] = [4, 4]) // 默认4点实线，4点空白
        case dotted
    }

    var cornerRadius: CGFloat = 8.0
    var backgroundColor: UIColor = .white
    var strokeColor: UIColor = .lightGray
    var borderWidth: CGFloat = 1.0
    var horizontalInset: CGFloat = 15.0
    var borderStyle: BorderStyle = .solid

    static func `default`() -> TableViewCellAppearance {
        return TableViewCellAppearance()
    }
}

public extension XP where Base == UITableView {
    func rTableView(willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath, _ radius: CGFloat = 8.0, _ color: UIColor, dx: CGFloat = 16) {
        rTableView(willDisplay: cell, forRowAt: indexPath, radius, color, color, dx: dx)
    }

    func rTableViewAppearance(willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var appearance = TableViewCellAppearance.default()
        appearance.cornerRadius = 6.0
        appearance.strokeColor = .white
        rTableView(willDisplay: cell, forRowAt: indexPath, appearance: appearance)
    }

    func rTableView(willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath, _ radius: CGFloat = 8.0, _ color: UIColor, _ strokeColor: UIColor, dx: CGFloat = 16) {
        // 圆角弧度半径
        let cornerRadius: CGFloat = radius
        // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
        cell.backgroundColor = UIColor.clear
        // 创建一个shapeLayer
        let layer = CAShapeLayer()

        // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
        let pathRef = CGMutablePath()
        // 获取cell的size
        // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
        let bounds = cell.bounds.insetBy(dx: dx, dy: 0)
        // 用来显示中间线
        _ = false
        // CGRectGetMinY：返回对象顶点坐标
        // CGRectGetMaxY：返回对象底点坐标
        // CGRectGetMinX：返回对象左边缘坐标
        // CGRectGetMaxX：返回对象右边缘坐标
        // CGRectGetMidX: 返回对象中心点的X坐标
        // CGRectGetMidY: 返回对象中心点的Y坐标

        // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
        if indexPath.row == 0 && indexPath.row == base.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.addRoundedRect(in: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        } else if indexPath.row == 0 {
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.maxY), transform: .identity)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.minY), radius: cornerRadius, transform: .identity)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius, transform: .identity)
            pathRef.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY), transform: .identity)
        } else if indexPath.row == (base.numberOfRows(inSection: indexPath.section) - 1) {
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.minY), transform: .identity)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: cornerRadius, transform: .identity)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius, transform: .identity)
            pathRef.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY), transform: .identity)
        } else {
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.minY), transform: .identity)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: 0, transform: .identity)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: 0, transform: .identity)
            pathRef.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY), transform: .identity)
        }
        // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
        layer.path = pathRef
        // 颜色修改
        layer.fillColor = color.cgColor
        layer.strokeColor = strokeColor.cgColor
        let testView = UIView(frame: bounds)
        testView.layer.insertSublayer(layer, at: 0)
        testView.backgroundColor = UIColor.clear
        cell.backgroundView = testView
    }

    func rTableView(willDisplay cell: UITableViewCell,
                    forRowAt indexPath: IndexPath,
                    appearance: TableViewCellAppearance? = nil) {
        cell.backgroundColor = .clear

        let appearance = appearance ?? TableViewCellAppearance()
        let bounds = cell.bounds.insetBy(dx: appearance.horizontalInset, dy: 0)

        // 创建背景图层（只填充，不描边）
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.fillColor = appearance.backgroundColor.cgColor
        backgroundLayer.strokeColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = 0

        // 创建边框图层（只描边，不填充）
        let borderLayer = CAShapeLayer()
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = appearance.strokeColor.cgColor
        borderLayer.lineWidth = appearance.borderWidth

        // 设置边框样式
        switch appearance.borderStyle {
        case let .dashed(pattern):
            borderLayer.lineDashPattern = pattern
        case .dotted:
            borderLayer.lineDashPattern = [1, 1]
        case .solid:
            break
        }

        let backgroundPath = CGMutablePath()
        let borderPath = CGMutablePath()

        let isFirstRow = indexPath.row == 0
        let isLastRow = indexPath.row == base.numberOfRows(inSection: indexPath.section) - 1

        switch (isFirstRow, isLastRow) {
        case (true, true):
            // 只有一个cell的情况 - 绘制完整的圆角矩形
            let rect = bounds
            backgroundPath.addRoundedRect(in: rect, cornerWidth: appearance.cornerRadius, cornerHeight: appearance.cornerRadius)
            borderPath.addRoundedRect(in: rect, cornerWidth: appearance.cornerRadius, cornerHeight: appearance.cornerRadius)

        case (true, false):
            // 第一个cell - 只绘制顶部圆角，底部平直
            configureFirstRowPath(backgroundPath: backgroundPath, borderPath: borderPath,
                                  bounds: bounds, cornerRadius: appearance.cornerRadius)

        case (false, true):
            // 最后一个cell - 只绘制底部圆角，顶部平直
            configureLastRowPath(backgroundPath: backgroundPath, borderPath: borderPath,
                                 bounds: bounds, cornerRadius: appearance.cornerRadius)

        case (false, false):
            // 中间cell - 矩形，没有圆角
            configureMiddleRowPath(backgroundPath: backgroundPath, borderPath: borderPath,
                                   bounds: bounds)
        }

        backgroundLayer.path = backgroundPath
        borderLayer.path = borderPath

        let backgroundView = UIView(frame: bounds)
        backgroundView.layer.addSublayer(backgroundLayer)
        backgroundView.layer.addSublayer(borderLayer)
        backgroundView.backgroundColor = .clear
        cell.backgroundView = backgroundView
    }

    // 修正的辅助方法
    private func configureFirstRowPath(backgroundPath: CGMutablePath, borderPath: CGMutablePath,
                                       bounds: CGRect, cornerRadius: CGFloat) {
        // 背景路径 - 完整的矩形（包括底部边框区域）
        let backgroundRect = CGRect(x: bounds.minX, y: bounds.minY,
                                    width: bounds.width, height: bounds.height + cornerRadius)
        backgroundPath.addRect(backgroundRect)

        // 边框路径 - 只绘制顶部和两侧，不绘制底部
        let path = CGMutablePath()
        let minX = bounds.minX
        let maxX = bounds.maxX
        let minY = bounds.minY
        let maxY = bounds.maxY

        // 左上角
        path.move(to: CGPoint(x: minX, y: minY + cornerRadius))
        path.addArc(center: CGPoint(x: minX + cornerRadius, y: minY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: .pi,
                    endAngle: .pi * 1.5,
                    clockwise: false)

        // 顶部
        path.addLine(to: CGPoint(x: maxX - cornerRadius, y: minY))

        // 右上角
        path.addArc(center: CGPoint(x: maxX - cornerRadius, y: minY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: .pi * 1.5,
                    endAngle: 0,
                    clockwise: false)

        // 右侧
        path.addLine(to: CGPoint(x: maxX, y: maxY))

        // 左侧
        path.addLine(to: CGPoint(x: minX, y: maxY))
        path.closeSubpath()

        borderPath.addPath(path)
    }

    private func configureLastRowPath(backgroundPath: CGMutablePath, borderPath: CGMutablePath,
                                      bounds: CGRect, cornerRadius: CGFloat) {
        // 背景路径 - 完整的矩形（包括顶部边框区域）
        let backgroundRect = CGRect(x: bounds.minX, y: bounds.minY - cornerRadius,
                                    width: bounds.width, height: bounds.height + cornerRadius)
        backgroundPath.addRect(backgroundRect)

        // 边框路径 - 只绘制底部和两侧，不绘制顶部
        let path = CGMutablePath()
        let minX = bounds.minX
        let maxX = bounds.maxX
        let minY = bounds.minY
        let maxY = bounds.maxY

        // 左下角
        path.move(to: CGPoint(x: minX, y: maxY - cornerRadius))
        path.addArc(center: CGPoint(x: minX + cornerRadius, y: maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: .pi,
                    endAngle: .pi * 0.5,
                    clockwise: true)

        // 底部
        path.addLine(to: CGPoint(x: maxX - cornerRadius, y: maxY))

        // 右下角
        path.addArc(center: CGPoint(x: maxX - cornerRadius, y: maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: .pi * 0.5,
                    endAngle: 0,
                    clockwise: true)

        // 右侧
        path.addLine(to: CGPoint(x: maxX, y: minY))

        // 左侧
        path.addLine(to: CGPoint(x: minX, y: minY))
        path.closeSubpath()

        borderPath.addPath(path)
    }

    private func configureMiddleRowPath(backgroundPath: CGMutablePath, borderPath: CGMutablePath,
                                        bounds: CGRect) {
        // 背景路径 - 完整的矩形
        backgroundPath.addRect(bounds)

        // 边框路径 - 只绘制左右两侧，不绘制上下
        let path = CGMutablePath()
        let minX = bounds.minX
        let maxX = bounds.maxX
        let minY = bounds.minY
        let maxY = bounds.maxY

        path.move(to: CGPoint(x: minX, y: minY))
        path.addLine(to: CGPoint(x: minX, y: maxY))
        path.addLine(to: CGPoint(x: maxX, y: maxY))
        path.addLine(to: CGPoint(x: maxX, y: minY))
        path.closeSubpath()

        borderPath.addPath(path)
    }
}
