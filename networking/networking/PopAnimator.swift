//
//  PopAnimator.swift
//  networking
//
//  Created by Alex P on 07/08/2019.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.45
    var presenting  = true
    var originFrame  = CGRect.zero
    var dismissCompletion: (() -> Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let commentsView = presenting ? toView : transitionContext.view(forKey: .from)!
        
        let initialFrame = presenting ? originFrame : commentsView.frame
        let finalFrame = presenting ? commentsView.frame : originFrame
        
        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            commentsView.transform = scaleTransform
            commentsView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            commentsView.clipsToBounds = true
        }
        
        commentsView.layer.cornerRadius = presenting ? 20.0 : 0.0
        commentsView.layer.masksToBounds = true
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(commentsView)
        
        UIView.animate(
            withDuration: duration,
            delay:0.0,
            usingSpringWithDamping: 0.68,
            initialSpringVelocity: 0.2,
            animations: {
                commentsView.transform = self.presenting ? .identity : scaleTransform
                commentsView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                commentsView.layer.cornerRadius = !self.presenting ? 20.0 : 0.0
        }, completion: { _ in
            if !self.presenting {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        })
    }
    

}
