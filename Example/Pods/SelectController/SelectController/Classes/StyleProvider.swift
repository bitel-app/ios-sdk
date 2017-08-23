//
//  StyleProvider.swift
//  Pods
//
//  Created by mohsen shakiba on 5/22/1396 AP.
//
//

import UIKit

public class SelectControllerGlobalStyleProvider {
    
    static public var `default`: SelectControllerStyleProvider =
        SelectControllerStyleProvider(overlayColor: UIColor(white: 0, alpha: 0.5), font: UIFont.systemFont(ofSize: 15), accentColor: UIColor.blue, textColor: UIColor.black, cancelColor: UIColor.red, titleTextAlignment: .right)
    
}

public struct SelectControllerStyleProvider {
    
    public var font: UIFont
    public var accentColor: UIColor
    public var textColor: UIColor
    public var overlayColor: UIColor
    public var cancelTextColor: UIColor
    public var titleTextAlignment: NSTextAlignment
    
    public init(overlayColor: UIColor, font: UIFont, accentColor: UIColor, textColor: UIColor, cancelColor: UIColor, titleTextAlignment: NSTextAlignment) {
        self.overlayColor = overlayColor
        self.font = font
        self.accentColor = accentColor
        self.textColor = textColor
        self.cancelTextColor = cancelColor
        self.titleTextAlignment = titleTextAlignment
    }
    
}
