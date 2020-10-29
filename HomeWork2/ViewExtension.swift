//
//  ViewExtension.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 29.10.2020.
//

import Foundation
import UIKit
import ObjectiveC

private var AssociatedObjectID: UInt8 = 0
extension UIView{
    @IBInspectable var identifier: String {
        get { return objc_getAssociatedObject(self, &AssociatedObjectID) as! String }
        set { objc_setAssociatedObject(self, &AssociatedObjectID, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
}
