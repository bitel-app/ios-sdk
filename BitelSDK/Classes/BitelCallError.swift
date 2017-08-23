//
//  File.swift
//  Pods
//
//  Created by mohsen shakiba on 5/29/1396 AP.
//
//

/// error types for when call fails
public enum BitelCallError: Error {
    
    /// when internet connection is inavailable
    case internetConnectionError
    
    /// when server returns error code 500
    case internalServerError
    
    /// if credentials provided by app is invalid
    case authenticationError
    
    /// if destination number rejects the call
    case destinationRejectedError
    
    /// if acound balance is zero
    case insufficientBalanceError
    
    /// when token or given parameters are invalid
    case badRequestError
    
    /// unkown errors might accure due to the nature of call
    case unknownError
    
    /// error sent from server containing information about the error
    case customError(String, String)
    
    /// debug description for error
    func debugDescription() -> String {
        switch self {
        case .internetConnectionError: return "internetConnectionError, please make sure the internet connection is available"
        case .internalServerError: return "internalServerError, server returned error code 500, this will be fixed shortly"
        case .authenticationError: return "authenticationError, authentication failed for the credentials provided"
        case .destinationRejectedError: return "destinationRejectedError, the destination number did not answer the call"
        case .unknownError: return "callFailedWithUnkownError, there was an unkown error, you might wanna retry the call"
        case .badRequestError: return "badRequestError, please make sure token and given parameters are valid"
        case .insufficientBalanceError: return "insufficientBalanceError, make sure you have enough balance to make a call"
        case .customError(let code, let description): return "ErrorCode: \(code), description: \(description)"
        }
    }
    
    static func from(status: Int?) -> BitelCallError {
        if status == nil {
            return .internetConnectionError
        }else if status == 400 {
            return .badRequestError
        }else if status == 401 || status == 403 {
            return .authenticationError
        }else if status == 500 {
            return .internalServerError
        }else {
            return .unknownError
        }
    }
    
    static func from(errCode: String, err: String) -> BitelCallError {
        return BitelCallError.customError(errCode, err)
    }
    
}
