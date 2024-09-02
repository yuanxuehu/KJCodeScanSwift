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
    // 网格扫码动画封装
    var scanNetAnimation: KJScanNetAnimation?
    
    // 记录动画状态
    var isAnimationing = false
    
    
    /**
    初始化扫描界面
    - parameter frame:  界面大小，一般为视频显示区域
    - parameter vstyle: 界面效果参数
    
    - returns: instancetype
    */
    public init(frame: CGRect, vstyle: KJScanViewStyle) {
        viewStyle = vstyle

        switch viewStyle.anmiationStyle {
        case KJScanViewAnimationStyle.LineMove:
            scanLineAnimation = KJScanLineAnimation.instance()
            break
        case KJScanViewAnimationStyle.NetGrid:
            scanNetAnimation = KJScanNetAnimation.instance()
            break

        default:
            break
        }

        var frameTmp = frame
        frameTmp.origin = CGPoint.zero

        super.init(frame: frameTmp)

        backgroundColor = UIColor.clear
    }
    
    override init(frame: CGRect) {
        var frameTmp = frame
        frameTmp.origin = CGPoint.zero

        super.init(frame: frameTmp)

        backgroundColor = UIColor.clear
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.init()
    }

    deinit {
        if scanLineAnimation != nil {
            scanLineAnimation!.stopStepAnimating()
        }
        if scanNetAnimation != nil {
            scanNetAnimation!.stopStepAnimating()
        }
    }
    
    // 开始扫描动画
    func startScanAnimation() {
        guard !isAnimationing else {
            return
        }
        isAnimationing = true

        let cropRect = CGRect(origin: CGPoint(x: 0, y: 100), size: CGSize(width: self.frame.width, height: 500))//getScanRectForAnimation()

        switch viewStyle.anmiationStyle {
        case .LineMove:
            scanLineAnimation?.startAnimatingWithRect(animationRect: cropRect,
                                                      parentView: self,
                                                      image: viewStyle.animationImage)
        case .NetGrid:
            scanNetAnimation?.startAnimatingWithRect(animationRect: cropRect,
                                                     parentView: self,
                                                     image: viewStyle.animationImage)
        break

        default:
            break
        }
    }
    
    // 停止扫描动画
    func stopScanAnimation() {
        isAnimationing = false
        
        switch viewStyle.anmiationStyle {
        case .LineMove:
            scanLineAnimation?.stopStepAnimating()
            break
        case .NetGrid:
            scanNetAnimation?.stopStepAnimating()
            break
        default:
            break
        }
    }
}
