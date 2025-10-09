//
//  YProgressView.swift
//  SZParking
//
//  Created by nbfujx on 2020/10/12.
//  Copyright © 2020 ningbokubin. All rights reserved.
//

import UIKit

class YProgressView: UIView {

    class func initView() -> YProgressView {
        return Bundle.main.loadNibNamed("YProgressView", owner: nil, options: nil)?.first as! YProgressView
    }

    @IBOutlet weak var imageView: UIImageView!

    lazy var images:[UIImage] = {
        var images = [UIImage]()
        for i in 1...81 {
            let imageName = String(format: "driving-animation-%d", i) // 补零到5位数
            let img=UIImage(named: imageName)
            images.append((img ?? UIImage(named: "driving-animation-1")!))
        }
        return images
    }()

    func showProgress() {
        imageView.animationImages = images
        // 设置循环次数，0无限循环
        imageView.animationRepeatCount = 0
        imageView.animationDuration = 2.5
        imageView.startAnimating()
    }

    func hidden() {
        self.removeFromSuperview()
        imageView.stopAnimating()
    }
}
