//
//  KJPermissions.swift
//  KJCodeScanSwift
//
//  Created by TigerHu on 2024/8/30.
//

import UIKit
import Photos

class KJPermissions: NSObject {

    //MARK: 获取相册权限
    static func authorizePhotoWith(comletion: @escaping (Bool) -> Void) {
        let granted = PHPhotoLibrary.authorizationStatus()
        switch granted {
        case PHAuthorizationStatus.authorized:
            comletion(true)
        case PHAuthorizationStatus.denied, PHAuthorizationStatus.restricted:
            comletion(false)
        case PHAuthorizationStatus.notDetermined:
            PHPhotoLibrary.requestAuthorization({ status in
                DispatchQueue.main.async {
                    comletion(status == PHAuthorizationStatus.authorized)
                }
            })
        case .limited:
            comletion(true)
        @unknown default:
            comletion(false)
        }
    }
    
    //MARK: 相机权限
    static func authorizeCameraWith(completion: @escaping (Bool) -> Void) {
        let granted = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch granted {
        case .authorized:
            completion(true)
        case .denied:
            completion(false)
        case .restricted:
            completion(false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) in
                DispatchQueue.main.async {
                    completion(granted)
                }
            })
        @unknown default:
            completion(false)
        }
    }
    
    //MARK: 跳转到APP系统设置权限界面
    static func jumpToSystemPrivacySetting() {
        guard let appSetting = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
  
        UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
    }

}

