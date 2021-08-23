//
//  HeartBubblesAnimation.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 20/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import UIKit

class CurvedView : UIView{
    
    override func draw(_ rect: CGRect) {
        
        let path = customBezierPath()
        path.lineWidth = 3
        //path.stroke()
    }
}

public func customBezierPath() -> UIBezierPath{
    let path = UIBezierPath()
    //start coornidates of the line path
    var startPath = CGPoint(x: 80, y: 300)
    path.move(to: startPath)
    var endPoint = CGPoint(x: 80, y: 0)
    
    //add randomPaths
    let randomNum = drand48()*10
    if randomNum>0 && randomNum<3{
        startPath = CGPoint(x: 100, y: 300)
        path.move(to: startPath)
        endPoint = CGPoint(x: 40, y: 0)
    }else if randomNum>3 && randomNum<7{
        startPath = CGPoint(x: 90, y: 300)
        path.move(to: startPath)
        endPoint = CGPoint(x: 80, y: 0)
    }else{
        startPath = CGPoint(x: 110, y: 300)
        path.move(to: startPath)
        endPoint = CGPoint(x: 120, y: 0)
    }
    
    let randomShift = 10 + drand48()*20
    let cp1 = CGPoint(x: 40-randomShift, y: 100+drand48()*50)
    let cp2 = CGPoint(x: 120+randomShift, y: 200-drand48()*50)
    path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
    return path
}

extension ViewController{
    
    func generateHeartBubblesAnimation(onView: UIView){
        
        let imageName = drand48()>0.5 ? "heart-50" :"heart-49"
        let heartImage1 = UIImage(named: imageName)
        let heartImageView1 = UIImageView(image: heartImage1)
        let dimension = 25+drand48()*20
        heartImageView1.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        
        //animate the heart
        let animation =  CAKeyframeAnimation(keyPath: "position")
        animation.delegate = AnimationDelegate(
                    didStart: nil,
                    didStop: {
                        heartImageView1.removeFromSuperview()
                })
        animation.path = customBezierPath().cgPath
        animation.duration = 0.5 + drand48()*1
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = true
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        heartImageView1.layer.add(animation, forKey: nil)
        onView.addSubview(heartImageView1)
        
    }
}

class AnimationDelegate: NSObject, CAAnimationDelegate {
    typealias AnimationCallback = (() -> Void)

    let didStart: AnimationCallback?
    let didStop: AnimationCallback?

    init(didStart: AnimationCallback?, didStop: AnimationCallback?) {
        self.didStart = didStart
        self.didStop = didStop
    }

    internal func animationDidStart(_ anim: CAAnimation) {
        didStart?()
    }

    internal func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        didStop?()
    }
}
