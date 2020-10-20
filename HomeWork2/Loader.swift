//
//  Loader.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 20.10.2020.
//

import Foundation
import UIKit

class Loader {
    static let randomImageURL = URL(string: "https://picsum.photos/1280/720")!
    static func download() -> UIImage{
        let data = (try? Data(contentsOf: randomImageURL))!
        return UIImage(data: data)!
        
    }
    
}

