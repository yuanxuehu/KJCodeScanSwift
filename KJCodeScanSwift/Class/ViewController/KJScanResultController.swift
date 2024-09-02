//
//  KJScanResultController.swift
//  KJCodeScanSwift
//
//  Created by TigerHu on 2024/9/1.
//

import UIKit

class KJScanResultController: UIViewController {
    
    var codeImg = UIImageView()
    var codeTypeLabel = UILabel()
    var codeStringLabel = UILabel()
    
    var codeResult: KJScanResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rect = CGRect(x: (self.view.frame.width-self.view.frame.width*5/6)/2, y: 100, width: self.view.frame.width*5/6, height: self.view.frame.width*5/6)
        codeImg.frame = rect
        self.view.addSubview(codeImg)
        
        codeTypeLabel.frame = CGRect(x: (self.view.frame.width-self.view.frame.width*5/6)/2, y: 300, width: self.view.frame.width*5/6, height: self.view.frame.width*5/6)
        codeTypeLabel.textColor = UIColor.white
        self.view.addSubview(codeTypeLabel)
        
        codeStringLabel.frame = CGRect(x: (self.view.frame.width-self.view.frame.width*5/6)/2, y: 350, width: self.view.frame.width*5/6, height: self.view.frame.width*5/6)
        codeStringLabel.textColor = UIColor.white
        codeStringLabel.numberOfLines = 0
        self.view.addSubview(codeStringLabel)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        codeImg.image = codeResult?.imgScanned
        codeTypeLabel.text = "码的类型:" + (codeResult?.strBarCodeType)!
        codeStringLabel.text = "码的内容:" + (codeResult?.strScanned)!

    }
    
}
