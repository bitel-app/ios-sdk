//
//  BitelCallViewController.swift
//  Pods
//
//  Created by mohsen shakiba on 5/29/1396 AP.
//
//

import UIKit
import SelectController

/// base class for making bitel call
class BitelCallViewController: UIViewController {
    
    @IBOutlet weak var containerVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var statusTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var retryButton: UIButton!
    
    @IBOutlet weak var thumbnailImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingImageViewWidthConstraint: UIView!
    @IBOutlet weak var loadingImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var thumbnailImageViewHeightConstraint: NSLayoutConstraint!
    
    let provider: BitelCallProvider
    let styles = BitelCallStyles.default
    let currentStatus = BitelCallStatus.waitingForZamanak
    
    public init(provider: BitelCallProvider) {
        self.provider = provider
        let bundle = Bundle(for: BitelCallViewController.self)
        super.init(nibName: "BitelCallViewController", bundle: bundle)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        BitelSocket.default.initConnection(uuid: provider.uuid)
        let app = UIApplication.shared
        NotificationCenter.default.addObserver(self, selector:  #selector(applicationWillResignActive(notification:)), name: NSNotification.Name.UIApplicationWillResignActive, object: app)
    }
    
    func applicationWillResignActive(notification: NSNotification) {
        self.dismiss(animated: true, completion: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("you have to instantiate the bitel from code, using the default initializer")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        /// view
        view.backgroundColor = .clear
        
        /// container
        containerView.backgroundColor = styles.backgroundColor
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        
        /// logo image
        logoImageView.image = UIImage(named: "bitel_logo_white", in: assetsBundle(), compatibleWith: nil)
        
        /// thumbnail
        thumbnailImageView.image = provider.visibleThumbnail
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
        
        /// name
        nameLabel.text = provider.visibleName
        nameLabel.font = styles.font
        nameLabel.textColor = styles.textColor
        
        /// phone
        phoneLabel.text = provider.visibleNumber
        phoneLabel.font = styles.font
        phoneLabel.textColor = styles.textColor
        
        /// status
        statusLabel.text = currentStatus.persianDescription()
        statusLabel.font = styles.font
        statusLabel.textColor = styles.textColor
        
        /// retry & scheduling
        retryButton.isHidden = true
        retryButton.titleLabel?.font = styles.font
        retryButton.layer.cornerRadius = 10
        retryButton.layer.masksToBounds = true
        retryButton.backgroundColor = styles.backgroundColor
        retryButton.setTitleColor(styles.textColor, for: .normal)
        
        initSecretaryCall()
        
    }
    
    private func initSecretaryCall() {
        BitelServer.default.secretary(provider: provider) { (err) in
            if let err = err {
                self.onSecretaryError(err: err)
            }else{
                self.onSecretarySuccess()
            }
        }
        BitelLocationService.default.requestLocation(for: provider.sourceNumber, token: provider.token)
    }
    
    private func onSecretaryError(err: BitelCallError) {
        self.onStatusChange(BitelCallStatus.failed(err))
    }
    
    private func onSecretarySuccess() {
        onStatusChange(BitelCallStatus.zamanakRespondedSuccessfuly)
        BitelSocket.default.initConnection(uuid: provider.uuid)
        BitelSocket.default.socketDelegate = self
    }
    
    internal func onStatusChange(_ status: BitelCallStatus) {
        statusLabel.text = status.persianDescription()
        if case BitelCallStatus.failed(let err) = status {
            goToErrorMode(err: err)
        }else{
            goToNormalMode{
            }
        }
        provider.handler?(status)
    }
    
    private func goToErrorMode(err: BitelCallError) {
        switch err {
        case .badRequestError, .authenticationError, .insufficientBalanceError, .internalServerError, .unknownError, .customError(_, _):
//            self.dismiss(animated: true, completion: nil)
//            return
            break
        default: break
        }
        /// hide the image
        UIView.animate(withDuration: 0.2, animations: { 
            self.loadingImageView.alpha = 0
            self.loadingImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }) { (_) in
            self.loadingImageView.isHidden = true
            self.loadingImageView.transform = .identity
        }
        
        self.retryButton.isHidden = false
        self.retryButton.alpha = 0
        /// remove the space for status
        self.statusTopConstraint.constant = 16
        self.containerVerticalConstraint.constant = -50
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
            self.retryButton.alpha = 1
        }) { (_) in
        }
    
        
        
    }
    
    /// the handler is implemented inorder to prevent both animations of normal and error to happen at the same time
    /// this way we wait for the animation to cpmplete then we proceed with the action
    private func goToNormalMode(onComplete: @escaping () -> Void) {
        /// show the image
        loadingImageView.isHidden = false
        loadingImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        /// add space for status
        self.statusTopConstraint.constant = 180
        self.containerVerticalConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.retryButton.alpha = 0
            self.loadingImageView.alpha = 1
            self.loadingImageView.transform = .identity
            self.view.layoutIfNeeded()
        }) { (_) in
            self.retryButton.isHidden = true
            onComplete()
        }
    }
    
    @IBAction func onRetryButtonClicked(_ sender: Any) {
        goToNormalMode {
            self.initSecretaryCall()
        }
    }
    
}

extension BitelCallViewController: SocketDelegate {
    
    func onSocketData(event: String, content: JSON) {
        switch event {
        case "call_failed":
            let err = BitelCallError.destinationRejectedError
            self.onStatusChange(BitelCallStatus.failed(err))
        default:
            break
        }
    }
    
}
