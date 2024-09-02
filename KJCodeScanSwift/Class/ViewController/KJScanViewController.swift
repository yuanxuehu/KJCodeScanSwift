//
//  KJScanViewController.swift
//  KJCodeScanSwift
//
//  Created by TigerHu on 2024/8/30.
//

import UIKit

class KJScanViewController: KJBaseViewController {

    /**
    @brief  扫码区域上方提示文字
    */
    var topTitle: UILabel?

    /**
     @brief  闪关灯开启状态
     */
    var isOpenedFlash: Bool = false

// MARK: - 底部几个功能：开启闪光灯、相册

    //底部显示的功能项
    var bottomItemsView: UIView?

    //相册
    var btnPhoto: UIButton = UIButton()

    //闪光灯
    var btnFlash: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        drawBottomItems()
    }

    override func handleCodeResult(arrayResult: [KJScanResult]) {

        let result: KJScanResult = arrayResult[0]

        let vc = KJScanResultController()
        vc.codeResult = result
        navigationController?.pushViewController(vc, animated: false)
    }

    func drawBottomItems() {
        if (bottomItemsView != nil) {
            return
        }

        let yMax = self.view.frame.maxY - self.view.frame.minY
        bottomItemsView = UIView(frame: CGRect(x: 0.0, y: yMax-100, width: self.view.frame.size.width, height: 100 ) )
        bottomItemsView!.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        self.view .addSubview(bottomItemsView!)

        let size = CGSize(width: 65, height: 87)
        self.btnFlash = UIButton()
        btnFlash.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        btnFlash.center = CGPoint(x: bottomItemsView!.frame.width/2, y: bottomItemsView!.frame.height/2)

        btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControl.State.normal)
        btnFlash.addTarget(self, action: #selector(openOrCloseFlash), for: UIControl.Event.touchUpInside)
        

        self.btnPhoto = UIButton()
        btnPhoto.bounds = btnFlash.bounds
        btnPhoto.center = CGPoint(x: bottomItemsView!.frame.width/4, y: bottomItemsView!.frame.height/2)
        btnPhoto.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_photo_nor"), for: UIControl.State.normal)
        btnPhoto.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_photo_down"), for: UIControl.State.highlighted)
        btnPhoto.addTarget(self, action: #selector(openPhotoAlbum), for: UIControl.Event.touchUpInside)
        

        bottomItemsView?.addSubview(btnFlash)
        bottomItemsView?.addSubview(btnPhoto)

        view.addSubview(bottomItemsView!)
    }
    
    //开关闪光灯
    @objc func openOrCloseFlash() {
        scanObj?.changeTorch()

        isOpenedFlash = !isOpenedFlash
        
        if isOpenedFlash {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_down"), for:UIControl.State.normal)
        } else {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControl.State.normal)

        }
    }

}
