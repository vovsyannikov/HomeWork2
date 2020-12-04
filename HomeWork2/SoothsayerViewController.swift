//
//  SoothsayerViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 03.12.2020.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

class SoothsayerViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var mapControlView: MKMapView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var floorSlider: UISlider!
    
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var roomCountSlider: UISlider!
    
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var areaSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalSumSetup()
        mapSetup()
        
        bottomViewSetup()
        setUpFloor()
        setUpArea()
        setUpRooms()
    }

    /// Setting up total apartment sum
    func totalSumSetup(){
        topView.layer.cornerRadius = CGFloat(15)
        topView.backgroundColor = UIColor(white: 1, alpha: 0.75)
        
        // TODO: Implement reactive text
        totalSumLabel.text = "Конечная сумма"
    }
    
    /// Centering map to be in view
    func mapSetup(){
        
        let startCenter = CLLocationCoordinate2D(latitude: 55.603688, longitude: 37.621511)
        let mapCamera = MKMapCamera(lookingAtCenter: startCenter, fromDistance: 200_000, pitch: 0, heading: mapControlView.camera.heading)
        
        mapControlView.setCamera(mapCamera, animated: true)
    }
    
    /// Bottom view setup
    func bottomViewSetup() {
        self.bottomView.layer.cornerRadius = CGFloat(15)
        self.bottomView.backgroundColor = UIColor(white: 1, alpha: 0.75)
        
    }
    
    /// Floor section setup
    func setUpFloor(){
        var floorValues: [Float] = []
        for value in 1...20 {
            floorValues.append(Float(value))
        }
        
        floorSlider.setValue(floorValues[4], animated: true)
        floorSlider.maximumValue = floorValues.max()!
        floorSlider.minimumValue = floorValues.min()!
        
        floorSlider.rx.value.asObservable()
            .map{ Int($0)}
            .subscribe { [unowned self] value in
                self.floorLabel.text = "\(value.element!) этаж"
            }
            .disposed(by: disposeBag)
        
    }
    
    /// Apartment area setup
    func setUpArea(){
        var areaValues: [Float] = []
        for value in 10...200 {
            areaValues.append(Float(value))
        }
        
        areaSlider.setValue(areaValues[17], animated: true)
        areaSlider.minimumValue = areaValues.min()!
        areaSlider.maximumValue = areaValues.max()!
        
        areaSlider.rx.value.asObservable()
            .map{ Int($0) }
            .subscribe { [unowned self] value in
                self.areaLabel.attributedText = "Площадь: \(value.element!) м2".superscripted
            }
            .disposed(by: disposeBag)
        
    }
    
    /// Room count setup
    func setUpRooms() {
        let roomValues: [Float] = [1,2,3,4,5,6]
        
        roomCountSlider.setValue(2, animated: true)
        roomCountSlider.maximumValue = roomValues.max()!
        roomCountSlider.minimumValue = roomValues.min()!
        
        roomCountSlider.rx.value.asObservable()
            .map{ Int($0) }
            .subscribe { [unowned self] value in
                self.roomLabel.text = "Комнат: \(value.element!)"
            }
            .disposed(by: disposeBag)
        
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

extension String {
    var superscripted: NSMutableAttributedString { superscript() }
    
    private func superscript() -> NSMutableAttributedString {
        let font: UIFont = UIFont(name: "Helvetica", size: 17)!
        let fontSuper: UIFont = UIFont(name: "Helvetica", size: 13)!
        let attributedString = NSMutableAttributedString(string: self, attributes: [.font: font])
        attributedString.setAttributes([.font: fontSuper, .baselineOffset: 10], range: NSRange(location: self.count-1, length: 1))
        
        return attributedString
    }
}


