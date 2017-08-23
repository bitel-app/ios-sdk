//
//  BitelServer.swift
//  Pods
//
//  Created by mohsen shakiba on 5/29/1396 AP.
//
//


import SwiftHTTP
import SwiftyJSON

typealias Parameters = [String: Any]
typealias JSON = SwiftyJSON.JSON


class BitelServer {
    
    static var `default` = BitelServer()
    
    /// make secretary call
    func secretary(provider: BitelCallProvider, handler: @escaping (BitelCallError?) -> Void) {
        let param: Parameters = [
            "sourcePhone": provider.sourceNumber,
            "destPhone": provider.destinationNumber,
            "productId": provider.voiceID ?? "",
            "uuid": provider.uuid
        ]
        let promise = HttpService.default.post(path: .secretary, data: param, token: provider.token)
        promise.onResponse { (res) in
            switch res {
            case .error(let err): handler(err)
            case .ok(_): handler(nil)
            }
        }
    }
    
    /// scheduling call
    func schedulingCall(provider: BitelCallProvider, handler: @escaping (BitelCallError?) -> Void) {
        let param: Parameters = [
            "sourcePhone": provider.sourceNumber,
            "destPhone": provider.destinationNumber,
            "productId": provider.voiceID ?? "",
            "uuid": provider.uuid
        ]
        let promise = HttpService.default.post(path: .secretary, data: param, token: provider.token)
        promise.onResponse { (res) in
            switch res {
            case .error(let err): handler(err)
            case .ok(_): handler(nil)
            }
        }
    }
    
}

enum EndPoints: String {
    
    case secretary = "secretary/dcall"
    case lbs = "lbs/location"
    
    func httpPath () -> String {
        return "http://185.20.163.147:11980/api/v2/" + self.rawValue
    }
}


/// wrapper around SwiftHTTP
class HttpService: Logging {
    
    static var `default` = HttpService()
    
    internal let timeout: TimeInterval = 10
    
    private init() {
        setupGlobalVaribales()
    }
    
    private func setupGlobalVaribales() {
        HTTP.globalRequest { req in
            req.timeoutInterval = 10
        }
    }
    
  
    
    func get(path: EndPoints, query: Parameters?, token: String) -> HttpPromiseProtocol {
        return request(method: .GET, uri: path, parameters: query, token: token)
    }
    
    func post(path: EndPoints, data: Parameters?, token: String) -> HttpPromiseProtocol {
        return request(method: .POST, uri: path, parameters: data, token: token)
    }
    
    private func request(method: HTTPVerb, uri: EndPoints, parameters: Parameters?, token: String) -> HttpPromiseProtocol {
        let promise = HttpPromise()
        do {
            let encoding: HTTPSerializeProtocol = method != .GET ? JSONParameterSerializer() : HTTPParameterSerializer()
            let headers: [String: String] = [
                "Accept": "application/json",
                "X-Zamanak-Session-Token": token,
                "X-Zamanak-Api-Key": "9b34cca78ef1dd27e4efcc94c7897dabd8cec81294166d6e2123bf4c3f6f273a"
            ]
            
            if let param = parameters {
                event("request", "body for url: \(uri.httpPath())", param)
            }
            let opt = try HTTP.New(uri.httpPath(), method: method, parameters: parameters, headers: headers, requestSerializer: encoding)
            promise.request = opt
            opt.onFinish = { response in
                if let err = response.error {
                    self.warning("Response", "no response from \(uri.httpPath()) \nreason \(err.debugDescription)")
                    let error = BitelCallError.from(status: response.statusCode)
                    promise.onResponseError(error: error)
                    return
                }else{
                    let json = JSON(data: response.data)
                    let error = json["error"].string
                    let result = json["result"]
                    let code = json["code"].stringValue
                    self.event("Response", "url: \(uri.httpPath()) \n", json)
                    if let err = error {
                        let error = BitelCallError.from(errCode: code, err: err)
                        promise.onResponseError(error: error)
                    }else{
                        promise.onResponseSuccess(result: result)
                    }
                }
            }
            opt.start()
        } catch let error {
            self.error("http request failed", error.localizedDescription)
            let error = BitelCallError.unknownError
            promise.onResponseError(error: error)
        }
        return promise
    }
    
}

/// returned
enum HttpResponse {
    case error(BitelCallError)
    case ok(JSON)
}

/// returned protocol by http service
protocol HttpPromiseProtocol {
    
    func onResponse(_ handler: @escaping (HttpResponse) -> Void)
    func cancel()
    
}

/// implementation of HttpPromiseProtocol
class HttpPromise: HttpPromiseProtocol {
    
    var handler: ((HttpResponse) -> Void)?
    var request: HTTP?
    
    func onResponse(_ handler: @escaping (HttpResponse) -> Void) {
        self.handler = handler
    }
    
    func onResponseError(error: BitelCallError) {
        DispatchQueue.main.async {
            let result = HttpResponse.error(error)
            self.handler?(result)
            self.release()
        }
    }
    
    func onResponseSuccess(result: JSON) {
        DispatchQueue.main.async {
            let result = HttpResponse.ok(result)
            self.handler?(result)
            self.release()
        }
    }
    
    func cancel() {
        request?.cancel()
        self.release()
    }
    
    func release() {
        self.handler = nil
        self.request = nil
    }
    
}

