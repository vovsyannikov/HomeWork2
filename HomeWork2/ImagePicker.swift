//
//  File.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 29.10.2020.
//

import Foundation
import UIKit
import ObjectiveC

extension UIImagePickerController {
    
    func getImage(for vc: UIViewController) {
        
        self.delegate = vc
        self.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.sourceType = .photoLibrary
        
        vc.present(self, animated: true)
        
    }

}

private var AssociatedObjectImage: UInt8 = 0
extension UIViewController: UIImagePickerControllerDelegate {

    var pickedImage: UIImage? {
        get { return objc_getAssociatedObject(self, &AssociatedObjectImage) as? UIImage }
        set { objc_setAssociatedObject(self, &AssociatedObjectImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancelled")
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        pickedImage = image
        if let vc = self as? ViewController {
            vc.imageView.image = image
            vc.imageView.backgroundColor = UIColor.systemBackground
        }
        self.dismiss(animated: true)
    }
    
}

extension UIViewController: UINavigationControllerDelegate {
    
}
