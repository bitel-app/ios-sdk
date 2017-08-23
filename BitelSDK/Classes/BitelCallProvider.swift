//
//  BitelCallProvider.swift
//  Pods
//
//  Created by mohsen shakiba on 5/29/1396 AP.
//
//

/// contains information to make a bitel call
/// this struct is used for instantiating BitelCallViewController
public class BitelCallProvider {
    
    /// unique id used by socket server
    let uuid: String
    /// token used for authentication
    public let token: String
    /// hidden soruce number used to make call
    public let sourceNumber: String
    /// hidden destination number to make call
    public let destinationNumber: String
    /// voiceID to use for bitel call
    public let voiceID: String?
    /// name visible by the user
    public let visibleName: String
    /// number visible by user
    /// you might wanna change the number to meet your criteria
    public let visibleNumber: String
    /// thumbnail visible by user
    public let visibleThumbnail: UIImage
    
    /// status for call in progress
    public private(set) var status: BitelCallStatus
    
    var handler: ((BitelCallStatus) -> Void)?
    
    /// default initializer for BitelCallProvider
    public init(token: String, sourceNumber: String, destinationNumber: String, visibleName: String, voiceID: String?, visibleNumber: String, visibleThumbnail: UIImage) {
        self.uuid = NSUUID().uuidString
        self.token = token
        self.voiceID = voiceID
        self.sourceNumber = sourceNumber
        self.destinationNumber = destinationNumber
        self.visibleName = visibleName
        self.visibleNumber = visibleNumber
        self.visibleThumbnail = visibleThumbnail
        self.status = .waitingForZamanak
    }
    
    public func present(in controller: UIViewController) {
        let vc = BitelCallViewController(provider: self)
        controller.present(vc, animated: true, completion: nil)
    }
    
    public func onCallStatusChange(_ handler: @escaping (BitelCallStatus) -> ()) {
        self.handler = handler
    }
    
}
