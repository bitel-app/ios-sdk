//
//  BiteCallStyles.swift
//  Pods
//
//  Created by mohsen shakiba on 5/29/1396 AP.
//
//

import UIKit

public class BitelCallStyles {
    
    public static var `default` = BitelCallStyles()
    
    public var font: UIFont
    public var textColor: UIColor
    public var backgroundColor: UIColor
    public var callWaitingImage: UIImage
    public var callFaildImage: UIImage
    public var retryButtonBackgroundColor: UIColor
    public var retryButtonTextColor: UIColor
    
    /// default initializer
    public init() {
        /// installing fonr programatically
        installFont("iranSans")
        font = UIFont(name: "IRANSansWeb", size: 15)!
        textColor = .white
        backgroundColor = gradientBackground(size: UIScreen.main.bounds.size)
        retryButtonBackgroundColor = .white
        retryButtonTextColor = .black
        let podBundle = assetsBundle()
        callWaitingImage = UIImage(named: "prof", in: podBundle, compatibleWith: nil)!
        callFaildImage = UIImage(named: "prof", in: podBundle, compatibleWith: nil)!
    }
    
}


