//
//  OptionViewController.swift
//  Pods
//
//  Created by mohsen shakiba on 3/13/1396 AP.
//
//

import UIKit

public class OptionControllerProvider {
    
    public var rowHeight: CGFloat = 50
    public var titleMessage: String?
    public var cancelMessage: String
    var rows: [String: Any] = [:]
    
    public init(title: String?, cancel: String) {
        self.titleMessage = title
        self.cancelMessage = cancel
    }
    
    public func appendRow(title: String, value: Any) {
        rows[title] = value
    }
    
    public func present(in viewController: UIViewController) -> OptionControllerPromise {
        let promise = OptionControllerPromise()
        let vc = OptionViewController(provider: self, promise: promise)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        viewController.present(vc, animated: true, completion: nil)
        return promise
    }
    
}

public class OptionControllerPromise {
    
    var handler: ((OptionResult) -> Void)?
    
    public func onResult(_ handler: @escaping (OptionResult) -> Void) {
        self.handler = handler
    }
    
    func complete(result: Any) {
        let result = OptionResult.selected(result)
        handler?(result)
        handler = nil
    }
    
    func canceled() {
        let result = OptionResult.canceled
        handler?(result)
        handler = nil
    }
    
}

public enum OptionResult {
    case selected(Any)
    case canceled
}


class OptionViewController: UIViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var overlay: UIView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var titleLabel: UILabel!
    
    var provider: OptionControllerProvider!
    var promise: OptionControllerPromise!
    
    init(provider: OptionControllerProvider, promise: OptionControllerPromise) {
        self.provider = provider
        self.promise = promise
        let bundle = Bundle(for: OptionViewController.self)
        super.init(nibName: "OptionViewController", bundle: bundle)
        self.transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let bundle = Bundle(for: OptionViewController.self)
        let nib = UINib(nibName: "OVCTableViewCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "OVCTableViewCell")
        self.titleLabel.textAlignment = SelectControllerGlobalStyleProvider.default.titleTextAlignment
        self.titleLabel.text = provider.titleMessage
        self.titleLabel.font = SelectControllerGlobalStyleProvider.default.font
        self.titleLabel.textColor = SelectControllerGlobalStyleProvider.default.textColor
        self.tableView.backgroundColor = .white
        self.view.backgroundColor = .clear
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.overlay.backgroundColor = SelectControllerGlobalStyleProvider.default.overlayColor
        tableViewHeight.constant = CGFloat(provider.rows.count) * provider.rowHeight
        
        self.tableView.alwaysBounceVertical = false
        
        cancelButton.titleLabel?.font = SelectControllerGlobalStyleProvider.default.font
        cancelButton.setTitle("test", for: .normal)
        cancelButton.addTarget(self, action: #selector(onCancel), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onCancel))
        overlay.addGestureRecognizer(tapGesture)
        
        if provider.titleMessage == nil {
            titleContainer.removeFromSuperview()
            NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: viewContainer, attribute: .top, multiplier: 1, constant: 0).isActive = true
        }
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("willapear", viewContainer.bounds.height)
    }

    func onSelected(row: Int) {
        let value = Array(provider.rows.values)[row]
        self.dismiss(animated: true, completion: nil)
        promise.complete(result: value)
    }
    
    func onCancel() {
        self.dismiss(animated: true, completion: nil)
        promise.canceled()
    }
    
}


extension OptionViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return provider.rows.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OVCTableViewCell") as! OVCTableViewCell
        let title = Array(provider.rows.keys)[indexPath.row]
        cell.label.text = title
        cell.label.textAlignment = SelectControllerGlobalStyleProvider.default.titleTextAlignment
        cell.label.font = SelectControllerGlobalStyleProvider.default.font
        cell.label.textColor = SelectControllerGlobalStyleProvider.default.textColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return provider.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}

extension OptionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelected(row: indexPath.item)
    }
    
    
}

extension OptionViewController: PresentingViewController {
    
    func prepareAnimationForPresentation() {
        print("prepare", viewContainer.bounds.height)
        overlay.alpha = 0
        viewContainer.transform = CGAffineTransform(translationX: 0, y: viewContainer.bounds.height)
    }
    
    func animateForPresentation() {
        overlay.alpha = 1
        viewContainer.transform = CGAffineTransform.identity
    }
    
    func prepareAnimationForDismiss() {
        
    }
    
    func animateForDismiss() {
        overlay.alpha = 0
        viewContainer.transform = CGAffineTransform(translationX: 0, y: viewContainer.bounds.height)
    }
    
}


extension OptionViewController: UIViewControllerTransitioningDelegate {

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GenericAnimationTransitioning(isPresenting: true, duration: 0.35)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GenericAnimationTransitioning(isPresenting: false, duration: 0.25)
    }

}

