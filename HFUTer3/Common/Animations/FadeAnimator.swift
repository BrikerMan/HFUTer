//
//  FadeAnimator.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/17.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import UIKit

class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration:TimeInterval = 0.5
    
    convenience init(withDuration duration:TimeInterval) {
        self.init()
        self.duration = duration
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView        = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        containerView.addSubview(toView)
        toView.alpha = 0.0
        UIView.animate(withDuration: duration, animations: {
            toView.alpha = 1.0 }, completion: { _ in
            transitionContext.completeTransition(true)
            })
    }
}
