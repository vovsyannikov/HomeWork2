//
//  D&BViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 22.10.2020.
//

import UIKit

class D_BViewController: UIViewController {
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressLabel.text = "Ожидание ввода"
    }
    
    
    
    @IBAction func downloadAndBlur(_ sender: Any) {
        progressLabel.text = "Загружается картинка..."
        DispatchQueue.global(qos: .utility).async { [unowned self] in
            let data = (try? Data(contentsOf: randomImageURL))!
            let image = UIImage(data: data)!
            DispatchQueue.main.async { [unowned self] in
                self.imageView.image = image
                self.progressLabel.text = "Размытие..."
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {                    self.imageView.image = image.blurred
                    self.progressLabel.text = "Готово!"
                }
            }
        }
    }
    
}

extension UIImage {
    var blurred: UIImage { blur() }
    
    func blur() -> UIImage{
        let context = CIContext(options: nil)
        
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        let startingImage = CIImage(image: self)
        blurFilter?.setValue(startingImage, forKey: kCIInputImageKey)
        blurFilter?.setValue(8, forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter?.setValue(blurFilter?.outputImage, forKey: kCIInputImageKey)
        cropFilter?.setValue(CIVector(cgRect: startingImage!.extent), forKey: "inputRectangle")
        
        let output = cropFilter!.outputImage
        let cgImg = context.createCGImage(output!, from: output!.extent)
        let resultingImage = UIImage(cgImage: cgImg!)
        
        return resultingImage
    }
}
