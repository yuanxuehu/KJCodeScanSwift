//
//  KJBaseViewController.swift
//  KJCodeScanSwift
//
//  Created by TigerHu on 2024/8/30.
//

import UIKit
import AVFoundation

open class KJBaseViewController: UIViewController {
    
    open var scanObj: KJScanManager?
    
    open var scanStyle: KJScanViewStyle? = KJScanViewStyle()
    open var qRScanView: KJScanView?
    
    //连续扫码
    open var isSupportContinuous = false;

    // 识别码的类型
    public var arrayCodeType: [AVMetadataObject.ObjectType]?
    
    // 是否需要识别后的当前图像
    public var isNeedCodeImage = false
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        KJPermissions.authorizeCameraWith { [weak self] (granted) in
            
            if granted {
                if let strongSelf = self {
                    strongSelf.perform(#selector(KJBaseViewController.startScan), with: nil, afterDelay: 0.3)
                }
            } else {
                KJPermissions.jumpToSystemPrivacySetting()
            }
        }
        
        drawScanView()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        qRScanView?.stopScanAnimation()
        scanObj?.stop()
    }
    

    @objc open func startScan() {
        if scanObj == nil {
            let cropRect = CGRect.zero

            // 指定识别几种码
            if arrayCodeType == nil {
                arrayCodeType = [AVMetadataObject.ObjectType.qr as NSString,
                                 AVMetadataObject.ObjectType.ean13 as NSString,
                                 AVMetadataObject.ObjectType.code128 as NSString] as [AVMetadataObject.ObjectType]
            }

            scanObj = KJScanManager(videoPreView: view,
                                     objType: arrayCodeType!,
                                     isCaptureImg: isNeedCodeImage,
                                     cropRect: cropRect,
                                     success: { [weak self] (arrayResult) -> Void in
                                        guard let strongSelf = self else {
                                            return
                                        }
                
                                        if !arrayResult.isEmpty {
                                            strongSelf.handleCodeResult(arrayResult: arrayResult)
                                        }
                                     })
        }
        
        // 开始扫描动画
        qRScanView?.startScanAnimation()
        
        // 相机运行
        scanObj?.start()
    }
    
    open func drawScanView() {
        if qRScanView == nil {
            qRScanView = KJScanView(frame: view.frame, vstyle: scanStyle!)
            view.addSubview(qRScanView!)
        }
    }
    
    //提供给子类重写
    open func handleCodeResult(arrayResult: [KJScanResult]) {
        
    }
    
    @objc open func openPhotoAlbum() {
        KJPermissions.authorizePhotoWith { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            picker.delegate = self
            picker.allowsEditing = false
            self?.present(picker, animated: true, completion: nil)
        }
    }

}

//MARK: - 图片选择代理方法
extension KJBaseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        //MARK: 相册选择图片识别二维码
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            picker.dismiss(animated: true, completion: nil)
            
            let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            guard let image = editedImage ?? originalImage else {
                print("Identify failed")
                return
            }
            let arrayResult = KJScanManager.recognizeQRImage(image: image)
            if !arrayResult.isEmpty {
                handleCodeResult(arrayResult: arrayResult)
            }
        }
    }
