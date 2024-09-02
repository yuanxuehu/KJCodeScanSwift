//
//  KJScanViewStyle.swift
//  KJCodeScanSwift
//
//  Created by TigerHu on 2024/9/1.
//

import UIKit

/// 扫码区域动画效果
public enum KJScanViewAnimationStyle {
    case LineMove // 线条上下移动
    case NetGrid // 网格
}

public struct KJScanViewStyle {
    
    //MARK: - 动画效果

    /// 扫码动画效果:线条或网格
    public var anmiationStyle = KJScanViewAnimationStyle.LineMove

    /// 动画效果的图像，如线条或网格的图像
    public var animationImage: UIImage?

    public init() {
        
    }
    
}
