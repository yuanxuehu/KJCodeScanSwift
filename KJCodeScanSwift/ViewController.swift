//
//  ViewController.swift
//  KJCodeScanSwift
//
//  Created by TigerHu on 2024/8/30.
//

import UIKit

class ViewController: UIViewController {

    var scanButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scanButton = UIButton(frame: CGRect(x: (self.view.frame.size.width-100)/2, y:self.view.frame.size.height/2, width: 100, height: 60 ) )
        scanButton.setTitle("点击扫码", for: .normal)
        scanButton.setTitleColor(.red, for: .normal)
        scanButton.addTarget(self, action: #selector(clickScan), for: UIControl.Event.touchUpInside)
        view.addSubview(scanButton)
    }

    @objc open func clickScan() {
        let vc = KJScanViewController()
        
        var style = KJScanViewStyle()
        //1、竖线动画
        //style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_light_green")
        //vc.scanStyle = style
        
        //2、网格动画
        style.anmiationStyle = KJScanViewAnimationStyle.NetGrid
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_full_net")
        vc.scanStyle = style
        
        navigationController?.pushViewController(vc, animated: false)
    }
    
}

