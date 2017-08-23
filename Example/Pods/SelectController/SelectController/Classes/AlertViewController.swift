//
//  AlertViewController.swift
//  Pods
//
//  Created by mohsen shakiba on 2/20/1396 AP.
//
//

import Foundation
import UIKit

public class AlertControllerProvider {
    
    var message: String
    var confirm: String?
    var cancel: String?
    
    public init(message: String, confirm: String?, cancel: String?) {
        self.message = message
        self.confirm = confirm
        self.cancel = cancel
    }
    
    public func present(in viewController: UIViewController) -> AlertControllerPromise {
        let promise = AlertControllerPromise()
        let vc = AlertViewController(provider: self, promise: promise)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        viewController.present(vc, animated: true, completion: nil)
        return promise
    }
    

}

public class AlertControllerPromise {
    
    var handler: ((Bool) -> Void)?
    
    public func onResult(_ handler: @escaping (Bool) -> Void) {
        self.handler = handler
    }
    
    func complete(result: Bool) {
        handler?(result)
        handler = nil
    }
    
}

public class AlertViewController: UIViewController {
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var confirmContainer: UIView!
    @IBOutlet var cancelContainer: UIView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var container: UIView!
    @IBOutlet var overlay: UIView!
    
    public var provider: AlertControllerProvider
    public var promise: AlertControllerPromise
    
    public init(provider: AlertControllerProvider, promise: AlertControllerPromise) {
        self.promise = promise
        self.provider = provider
        let bundle = Bundle(for: AlertViewController.self)
        super.init(nibName: "AlertViewController", bundle: bundle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        
        self.view.backgroundColor = .clear
        
        overlay.backgroundColor = SelectControllerGlobalStyleProvider.default.overlayColor
        
        messageLabel.font = SelectControllerGlobalStyleProvider.default.font
        messageLabel.text = provider.message
        messageLabel.textAlignment = SelectControllerGlobalStyleProvider.default.titleTextAlignment
        messageLabel.textColor = SelectControllerGlobalStyleProvider.default.textColor
        
        cancelButton.titleLabel?.font = SelectControllerGlobalStyleProvider.default.font
        confirmButton.titleLabel?.font = SelectControllerGlobalStyleProvider.default.font
        
        if let confirm = provider.confirm {
            confirmButton.setTitle(confirm, for: .normal)
        }else{
            confirmButton.isHidden = true
        }
        
        if let cancel = provider.cancel {
            cancelButton.setTitle(cancel, for: .normal)
        }else{
            cancelContainer.isHidden = true
            cancelButton.isHidden = true
        }
        
        cancelContainer.backgroundColor = UIColor(hex: "f5f5f5")
        cancelContainer.layer.cornerRadius = 5
        confirmContainer.backgroundColor = UIColor(hex: "f5f5f5")
        confirmContainer.layer.cornerRadius = 5
        
        container.layer.cornerRadius = 5
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowRadius = 10
        container.layer.shadowOpacity = 0.1
        container.layer.shadowOffset = CGSize(width: 0, height: 0)

        cancelButton.setTitleColor(UIColor(hex: "ff4d4d"), for: .normal)
        
        if provider.cancel == nil {
            self.cancelButton.isHidden = true
        }
        
        if provider.confirm == nil {
            self.confirmButton.isHidden = true
        }
    }
    
    @IBAction func cancelClicked(sender: AnyObject) {
        promise.complete(result: false)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func confirmClicked(sender: AnyObject) {
        promise.complete(result: true)
        self.dismiss(animated: true, completion: nil)
    }
}

//
//extension AlertViewController: UIViewControllerTransitioningDelegate {
//    
//    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return AVTransition(presenting: true)
//    }
//    
//    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return AVTransition(presenting: false)
//    }
//    
//}

