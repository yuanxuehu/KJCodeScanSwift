//
//  KJScanView.swift
//  KJCodeScanSwift
//
//  Created by TigerHu on 2024/9/1.
//

import UIKit

open class KJScanView: UIView {
    
    // 扫码区域各种参数
    var viewStyle = KJScanViewStyle()
    
    // 线条扫码动画封装
    var scanLineAnimation: KJScanLineAnimation?
    
    /**
    初始化扫描界面
    - parameter frame:  界面大小，一般为视频显示区域
    - parameter vstyle: 界面效果参数
    
    - returns: instancetype
    */
    public init(frame: CGRect, vstyle: KJScanViewStyle) {
        viewStyle = vstyle

        switch viewStyle.anmiationStyle {
        case LBXScanViewAnimationStyle.LineMove:
            scanLineAnimation = LBXScanLineAnimation.instance()
        case LBXScanViewAnimationStyle.NetGrid:
            scanNetAnimation = LBXScanNetAnimation.instance()
        case LBXScanViewAnimationStyle.LineStill:
            scanLineStill = UIImageView()
            scanLineStill?.image = viewStyle.animationImage
        default:
            break
        }

        var frameTmp = frame
        frameTmp.origin = CGPoint.zero

        super.init(frame: frameTmp)

        backgroundColor = UIColor.clear
    }
    
    
}
