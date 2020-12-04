//
//  SoothsayerViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 03.12.2020.
//

import UIKit
import RxSwift
import MapKit

class SoothsayerViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var mapControlView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalSumSetup()
        mapSetup()
    }

    func totalSumSetup(){
        topView.layer.cornerRadius = CGFloat(15)
        topView.backgroundColor = UIColor(white: 1, alpha: 0.75)
        
        totalSumLabel.text = "Конечная сумма"
    }
    
    /// Centering map to be in view
    func mapSetup(){
        
        let startCenter = CLLocationCoordinate2D(latitude: 55.603688, longitude: 37.621511)
        let mapCamera = MKMapCamera(lookingAtCenter: startCenter, fromDistance: 200_000, pitch: 0, heading: mapControlView.camera.heading)
        
        mapControlView.setCamera(mapCamera, animated: true)
    }

}

extension Int {
    var separated: String { separate().string(for: self) ?? "" }
    var rubCurrency: String { "\(separated) ₽"}
    
    private func separate() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        
        return formatter
    }
}
