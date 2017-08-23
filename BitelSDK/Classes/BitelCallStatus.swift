//
//  BitelCallStatus.swift
//  Pods
//
//  Created by mohsen shakiba on 5/29/1396 AP.
//
//

/// status for bitel call
public enum BitelCallStatus {
    
    case waitingForZamanak
    case internetConnectionError
    case zamanakRespondedSuccessfuly
    case destinationAnswered
    case succeed
    case failed(BitelCallError)
    
    func persianDescription() -> String {
        switch self {
        case .waitingForZamanak: return "در حال برقراری ارتباط"
        case .internetConnectionError: return "اتصال به سرور برقرار نشد"
        case .zamanakRespondedSuccessfuly: return "در حال انتظار برای پاسخ مخاطب"
        case .destinationAnswered: return "مخاطب پاسخ داده و به زودی به شما متصل میشود"
        case .succeed: return "تماس موفقت آمیز"
        case .failed(_): return "تماس موفقیت آمیز نبود"
        }
    }
    
}
