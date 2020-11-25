//
//  TabBar.swift
//  Sample3
//
//  Created by 이우진 on 2020/02/07.
//  Copyright © 2020 asakura. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
    }

    func setupStyle() {
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.4, x: 0, y: 0, blur: 12)
    }                                               //0,3      0    0        12
}

extension CALayer {
    // Sketch 스타일의 그림자를 생성하는 유틸리티 함수
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,     //0.5
        x: CGFloat = 0,
        y: CGFloat = 2,     //2
        blur: CGFloat = 4       //4
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0       //2.0
    }
}

extension UITabBar {
    // 기본 그림자 스타일을 초기화해야 커스텀 스타일을 적용할 수 있다.
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor(displayP3Red: 193/255, green: 247/255, blue: 213/255, alpha: 1)
    }
}
