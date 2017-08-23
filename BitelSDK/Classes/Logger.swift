//
//  Logger.swift
//  Pods
//
//  Created by mohsen shakiba on 5/29/1396 AP.
//
//


import Foundation
import SwiftHTTP

protocol Logging {
    
}

extension Logging {
    
    func event(_ action: String, _ items: Any?...) {
        Logg.default.prepare(type: .event, category: getClassName(), action: action, items: items)
    }
    
    func error(_ action: String, _ items: Any?...) {
        Logg.default.prepare(type: .error, category: getClassName(), action: action, items: items)
    }
    
    func info(_ action: String, _ items: Any?...) {
        Logg.default.prepare(type: .info, category: getClassName(), action: action, items: items)
    }
    
    func warning(_ action: String, _ items: Any?...) {
        Logg.default.prepare(type: .warning, category: getClassName(), action: action, items: items)
    }
    
    private func getClassName() -> String {
        var className = String(describing: self)
        if let name = className.components(separatedBy: ".").last {
            className = name
        }
        return className
    }
    
}

public class BitelLoggerConfig {
    
    static var `default` = BitelLoggerConfig()
    
    var enabled = false
    
}

class Logg {
    
    public static var `default` = Logg()
    public var config = BitelLoggerConfig.default
    
    public func prepare(type: LoggType, category: String, action: String, items: [Any?]) {
        
        if !config.enabled { return }
        
        var str = ""
        for (i, item) in items.enumerated() {
            if let item = item {
                str += String(describing: item)
            }else{
                str += "[NULL]"
            }
            if i < items.count - 1 {
                str += ", "
            }
        }
        
        print("BitelLogger:::", category, action, str)
        
    }
    
}

enum LoggType: Int {
    
    case error = 0
    case warning = 1
    case event = 2
    case info = 3
    
}
