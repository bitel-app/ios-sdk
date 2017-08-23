//
//  PickerViewController.swift
//  Pods
//
//  Created by mohsen shakiba on 5/22/1396 AP.
//
//

import UIKit

public class PickerControllerProvider {
    
    public var rowHeight: CGFloat?
    public var titleMessage: String?
    public var cancelMessage: String
    var components: [PickerComponent] = []
    
    public init(title: String?, cancel: String) {
        self.titleMessage = title
        self.cancelMessage = cancel
    }
    
    public func appendRow(title: String, value: Any, toComponentAt index: Int) {
        if components.count <= index {
            components.append(PickerComponent())
        }
        let pickerRow = PickerRow(title: title, value: value)
        components[index].rows.append(pickerRow)
    }
    
    public func present(in viewController: UIViewController) -> PickerControllerPromise {
        let promise = PickerControllerPromise()
        let vc = PickerViewController(provider: self, promise: promise)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        viewController.present(vc, animated: true, completion: nil)
        return promise
    }
    
}

struct PickerComponent {
    var rows: [PickerRow] = []
}

struct PickerRow {
    var title: String
    var value: Any
}

public class PickerControllerPromise {
    
    var handler: ((PickerResult) -> Void)?
    
    public func onResult(_ handler: @escaping (PickerResult) -> Void) {
        self.handler = handler
    }
    
    func complete(result: [Int: Any]) {
        let result = PickerResult(values: result)
        handler?(result)
        handler = nil
    }
    
}

public struct PickerResult {
    
    var values: [Int: Any] = [:]
    
    public func value<T>(for component: Int) -> T? {
        print(values)
        return values[component] as? T
    }
    
}

class PickerViewController: UIViewController {
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var topLableConstraint: NSLayoutConstraint!

    var provider: PickerControllerProvider
    var promise: PickerControllerPromise
    
    init(provider: PickerControllerProvider, promise: PickerControllerPromise) {
        self.promise = promise
        self.provider = provider
        let bundle = Bundle(for: PickerViewController.self)
        super.init(nibName: "PickerViewController", bundle: bundle)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        messageLabel.textAlignment = SelectControllerGlobalStyleProvider.default.titleTextAlignment
        messageLabel.text = provider.titleMessage
        messageLabel.textColor = SelectControllerGlobalStyleProvider.default.textColor
        messageLabel.font = SelectControllerGlobalStyleProvider.default.font
        cancelButton.setTitle(provider.cancelMessage, for: .normal)
        cancelButton.titleLabel?.font = SelectControllerGlobalStyleProvider.default.font
        if provider.titleMessage == nil {
            topLableConstraint.constant = 0
        }
        view.backgroundColor = SelectControllerGlobalStyleProvider.default.overlayColor
        cancelButton.addBorder(.top, color: UIColor(white: 0, alpha: 0.1))
        cancelButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        overlayView.addGestureRecognizer(recognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismissController() {
        var results = [Int: Any]()
        for i in 0..<provider.components.count {
            let index = pickerView.selectedRow(inComponent: i)
            let value = provider.components[i].rows[index]
            results[i] = value.value
        }
        promise.complete(result: results)
        self.dismiss(animated: true, completion: nil)
    }

}

extension PickerViewController: UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return provider.rowHeight ?? 50
    }
    
}

extension PickerViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return provider.components.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return provider.components[component].rows.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let component = provider.components[component]
        let title = component.rows[row].title
        if let titleLabel = view as? UILabel {
            titleLabel.text = title
            return titleLabel
        } else {
            let titleLabel = UILabel()
            titleLabel.textAlignment = .center
            titleLabel.font = SelectControllerGlobalStyleProvider.default.font
            titleLabel.textColor = SelectControllerGlobalStyleProvider.default.textColor
            titleLabel.text = title
            return titleLabel
        }
    }
    
}
