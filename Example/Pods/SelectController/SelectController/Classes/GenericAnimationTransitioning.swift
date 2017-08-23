//
//  SelectControllerTransitioning.swift
//  Pods
//
//  Created by mohsen shakiba on 5/22/1396 AP.
//
//

import Foundation
import UIKit

class GenericAnimationTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    let presenting: Bool
    var duration: TimeInterval
    
    init(isPresenting: Bool, duration: TimeInterval) {
        self.presenting = isPresenting
        self.duration = duration
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if presenting {
            onPresentingAnimation(context: transitionContext)
        }else{
            onDismissAnimation(context: transitionContext)
        }
    }
    
    private func onPresentingAnimation(context: UIViewControllerContextTransitioning) {
//        let fromVC = context.viewController(forKey: .from)!
        let toVC = context.viewController(forKey: .to) as! PresentingViewController
        let toView = context.view(forKey: .to)!
        toView.frame = UIScreen.main.bounds
        toVC.prepareAnimationForPresentation()
        context.containerView.addSubview(toView)
        UIView.animate(withDuration: self.duration, animations: { 
            toVC.animateForPresentation()
        }) { (_) in
            context.completeTransition(true)
        }
        
    }
    
    private func onDismissAnimation(context: UIViewControllerContextTransitioning) {
                let fromVC = context.viewController(forKey: .from) as! PresentingViewController
        fromVC.prepareAnimationForDismiss()
        
        UIView.animate(withDuration: self.duration, animations: {
            fromVC.animateForDismiss()
        }) { (_) in
            context.completeTransition(true)
        }
        
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }


    
}

protocol PresentingViewController {
    
    func prepareAnimationForPresentation()
    func animateForPresentation()
    
    func prepareAnimationForDismiss()
    func animateForDismiss()
}
