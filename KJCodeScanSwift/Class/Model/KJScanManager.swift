//
//  KJScanManager.swift
//  KJCodeScanSwift
//
//  Created by TigerHu on 2024/8/30.
//

import UIKit
import AVFoundation

public struct KJScanResult {
    
    /// 码内容
    public var strScanned: String?
    
    /// 扫描图像
    public var imgScanned: UIImage?
    
    /// 码的类型
    public var strBarCodeType: String?

    /// 码在图像中的位置
    public var arrayCorner: [AnyObject]?
    
    public init(str: String?, img: UIImage?, barCodeType: String?, corner: [AnyObject]?) {
        strScanned = str
        imgScanned = img
        strBarCodeType = barCodeType
        arrayCorner = corner
    }
}


open class KJScanManager: NSObject,AVCaptureMetadataOutputObjectsDelegate {
    
    let device = AVCaptureDevice.default(for: AVMediaType.video)
    var input: AVCaptureDeviceInput?
    var output: AVCaptureMetadataOutput

    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    //var stillImageOutput: AVCaptureStillImageOutput
    var stillImageOutput: AVCapturePhotoOutput

    // 存储返回结果
    var arrayResult = [KJScanResult]()

    // 扫码结果返回block
    var successBlock: ([KJScanResult]) -> Void

    // 是否需要拍照
    var isNeedCaptureImage: Bool

    // 当前扫码结果是否处理
    var isNeedScanResult = true
    
    //连续扫码
    var supportContinuous = false
    
    
    /**
     初始化设备
     - parameter videoPreView: 视频显示UIView
     - parameter objType:      识别码的类型,缺省值 QR二维码
     - parameter isCaptureImg: 识别后是否采集当前照片
     - parameter cropRect:     识别区域
     - parameter success:      返回识别信息
     - returns:
     */
    init(videoPreView: UIView,
         objType: [AVMetadataObject.ObjectType] = [(AVMetadataObject.ObjectType.qr as NSString) as AVMetadataObject.ObjectType],
         isCaptureImg: Bool,
         cropRect: CGRect = .zero,
         success: @escaping (([KJScanResult]) -> Void)) {
        
        successBlock = success
        output = AVCaptureMetadataOutput()
        isNeedCaptureImage = isCaptureImg
        //stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput = AVCapturePhotoOutput()
        
        super.init()
        
        guard let device = device else {
            return
        }
        do {
            input = try AVCaptureDeviceInput(device: device)
        } catch let error as NSError {
            print("AVCaptureDeviceInput(): \(error)")
        }
        guard let input = input else {
            return
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }

        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        if session.canAddOutput(stillImageOutput) {
            session.addOutput(stillImageOutput)
        }

        //stillImageOutput.outputSettings = [AVVideoCodecJPEG: AVVideoCodecKey]
        stillImageOutput.photoSettingsForSceneMonitoring = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])

        session.sessionPreset = AVCaptureSession.Preset.high

        // 参数设置
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

        output.metadataObjectTypes = objType


        if !cropRect.equalTo(CGRect.zero) {
            // 启动相机后，直接修改该参数无效
            output.rectOfInterest = cropRect
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill

        var frame: CGRect = videoPreView.frame
        frame.origin = CGPoint.zero
        previewLayer?.frame = frame

        videoPreView.layer.insertSublayer(previewLayer!, at: 0)

        if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.continuousAutoFocus) {
            do {
                try input.device.lockForConfiguration()
                input.device.focusMode = AVCaptureDevice.FocusMode.continuousAutoFocus
                input.device.unlockForConfiguration()
            } catch let error as NSError {
                print("device.lockForConfiguration(): \(error)")
            }
        }
    }

    public func metadataOutput(_ output: AVCaptureMetadataOutput,
                               didOutput metadataObjects: [AVMetadataObject],
                               from connection: AVCaptureConnection) {
        captureOutput(output, didOutputMetadataObjects: metadataObjects, from: connection)
    }
    
    func start() {
        if !session.isRunning {
            isNeedScanResult = true
            
            DispatchQueue.global(qos: .background).async {
                self.session.startRunning()
            }
        }
    }
    
    func stop() {
        if session.isRunning {
            isNeedScanResult = false
            
            DispatchQueue.global(qos: .background).async {
                self.session.stopRunning()
            }
        }
    }
    
    open func captureOutput(_ captureOutput: AVCaptureOutput,
                            didOutputMetadataObjects metadataObjects: [Any],
                            from connection: AVCaptureConnection!) {
        guard isNeedScanResult else {
            // 上一帧处理中
            return
        }
        isNeedScanResult = false

        arrayResult.removeAll()

        // 识别扫码类型
        for current in metadataObjects {
            guard let code = current as? AVMetadataMachineReadableCodeObject else {
                continue
            }
            
            #if !targetEnvironment(simulator)
            
            arrayResult.append(KJScanResult(str: code.stringValue,
                                             img: UIImage(),
                                             barCodeType: code.type.rawValue,
                                             corner: code.corners as [AnyObject]?))
            #endif
        }

        if arrayResult.isEmpty || supportContinuous {
            isNeedScanResult = true
        }
        if !arrayResult.isEmpty {
            
            if supportContinuous {
                successBlock(arrayResult)
            }
            else if isNeedCaptureImage {
                //captureImage()
            } else {
                stop()
                successBlock(arrayResult)
            }
        }
    }
    
    
    open func isGetFlash() -> Bool {
        return device != nil && device!.hasFlash && device!.hasTorch
    }
    
    /**
     打开或关闭闪关灯
     - parameter torch: true：打开闪关灯 false:关闭闪光灯
     */
    open func setTorch(torch: Bool) {
        guard isGetFlash() else {
            return
        }
        do {
            try input?.device.lockForConfiguration()
            input?.device.torchMode = torch ? AVCaptureDevice.TorchMode.on : AVCaptureDevice.TorchMode.off
            input?.device.unlockForConfiguration()
        } catch let error as NSError {
            print("device.lockForConfiguration(): \(error)")
        }
    }
    
    
    /// 闪光灯打开或关闭
    open func changeTorch() {
        let torch = input?.device.torchMode == .off
        setTorch(torch: torch)
    }
    
    /**
     识别二维码码图像
     
     - parameter image: 二维码图像
     
     - returns: 返回识别结果
     */
    public static func recognizeQRImage(image: UIImage) -> [KJScanResult] {
        guard let cgImage = image.cgImage else {
            return []
        }
        let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                  context: nil,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])!
        let img = CIImage(cgImage: cgImage)
        let features = detector.features(in: img, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        return features.filter {
            $0.isKind(of: CIQRCodeFeature.self)
        }.map {
            $0 as! CIQRCodeFeature
        }.map {
            KJScanResult(str: $0.messageString,
                          img: image,
                          barCodeType: AVMetadataObject.ObjectType.qr.rawValue,
                          corner: nil)
        }
    }
}
