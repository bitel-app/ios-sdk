//
//  UIViewExtension.swift
//  ListViewFramwork
//
//  Created by mohsen shakiba on 11/18/1395 AP.
//  Copyright © 1395 mohsen shakiba. All rights reserved.
//

import UIKit

extension UIView {
    
    func addBorder(_ edge: UIRectEdge, color: UIColor) {

        let tag = edge == .top ? 1111 : 1112
        
        if let _ = subviews.index(where: {$0.tag == tag}) {
            return
        }
        subviews.forEach { layer in
            if layer.tag == tag {
                return
            }
        }
        
        let border = UIView()
        border.tag = tag
        border.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 1)
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(border)
        
        let constraint = NSLayoutConstraint(item: border, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let constraint1 = NSLayoutConstraint(item: border, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let constraint3 = NSLayoutConstraint(item: border, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)
        let constraint4 = NSLayoutConstraint(item: border, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
        
        var constraint2: NSLayoutConstraint!
        
        if edge == .top {
            constraint2 = NSLayoutConstraint(item: border, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        }else{
            constraint2 = NSLayoutConstraint(item: border, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        }

        
        NSLayoutConstraint.activate([constraint, constraint1, constraint2, constraint3, constraint4])
        
    }
    
}

