//
//  KJScanLineAnimation.swift
//  KJCodeScanSwift
//
//  Created by TigerHu on 2024/9/1.
//

import UIKit

class KJScanLineAnimation: UIImageView {

    var isAnimationing = false
    var animationRect = CGRect.zero
    
    public static func instance() -> KJScanLineAnimation {
        return KJScanLineAnimation()
    }
    
    deinit {
        stopStepAnimating()
    }
    
    func startAnimatingWithRect(animationRect: CGRect, parentView: UIView, image: UIImage?) {
        self.image = image
        self.animationRect = animationRect
        parentView.addSubview(self)
        
        isHidden = false
        isAnimationing = true
        if image != nil {
            stepAnimation()
        }
    }
    
    @objc func stepAnimation() {
        guard isAnimationing else {
            return
        }
        var frame = animationRect
        let hImg = image!.size.height * animationRect.size.width / image!.size.width

        frame.origin.y -= hImg
        frame.size.height = hImg
        self.frame = frame
        alpha = 0.0

        UIView.animate(withDuration: 1.4, animations: {
            self.alpha = 1.0
            var frame = self.animationRect
            let hImg = self.image!.size.height * self.animationRect.size.width / self.image!.size.width
            frame.origin.y += (frame.size.height - hImg)
            frame.size.height = hImg
            self.frame = frame
        }, completion: { _ in
            self.perform(#selector(KJScanLineAnimation.stepAnimation), with: nil, afterDelay: 0.3)
        })
    }
    
    func stopStepAnimating() {
        isHidden = true
        isAnimationing = false
    }

}
