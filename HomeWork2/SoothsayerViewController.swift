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
    private var apartment: Apartment! = nil
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var mapControlView: MKMapView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var floorSlider: UISlider!
    
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var areaSlider: UISlider!
    
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var roomCountSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apartment = Apartment(area: 60, floor: 4, rooms: 3, coordinates: CLLocationCoordinate2D(latitude: 55.606415, longitude: 37.600696))
        
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
        
        apartment.cost.asObservable()
            .subscribe { [unowned self] value in
                self.totalSumLabel.text = value.element!.rubCurrency
                print(value.element!.rubCurrency)
            }
            .disposed(by: disposeBag)
    }
    
    /// Centering map to be in view
    func mapSetup(){
        let tapRecognizer: UITapGestureRecognizer = .init(target: self, action: #selector(handleTap(_:)))
        tapRecognizer.delegate = self
        let startCenter = CLLocationCoordinate2D(latitude: 55.603688, longitude: 37.621511)
        let mapCamera = MKMapCamera(lookingAtCenter: startCenter, fromDistance: 175_000, pitch: 0, heading: mapControlView.camera.heading)
        
        mapControlView.setCamera(mapCamera, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = apartment.coordinates
        mapControlView.addAnnotation(annotation)
        mapControlView.addGestureRecognizer(tapRecognizer)
    }
    
    /// Handling the search for place to evaluate
    @objc func handleTap(_ sender: UILongPressGestureRecognizer) {
        let locationTapped = sender.location(in: mapControlView)
        let coordinate = mapControlView.convert(locationTapped, toCoordinateFrom: mapControlView)
        let place = MKPointAnnotation()
        place.coordinate = coordinate
        
        apartment.coordinates = place.coordinate
        print("Adding location for \(place.coordinate)")
        
        let annotations = mapControlView.annotations
        mapControlView.removeAnnotations(annotations)
        
        mapControlView.addAnnotation(place)
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
        
        floorSlider.value = 15
        floorSlider.maximumValue = floorValues.max()!
        floorSlider.minimumValue = floorValues.min()!
        
        floorSlider.rx.value.asObservable()
            .subscribe { [unowned self] value in
                let el = Int(value.element!)
                print(el, apartment.floor)
                self.apartment.floor = Float(el)
                self.floorLabel.text = "\(el) этаж"
            }
            .disposed(by: disposeBag)
        
    }
    
    /// Apartment area setup
    func setUpArea(){
        var areaValues: [Float] = []
        for value in 10...200 {
            areaValues.append(Float(value))
        }
        
        areaSlider.value = apartment.area
        areaSlider.minimumValue = areaValues.min()!
        areaSlider.maximumValue = areaValues.max()!
        
        areaSlider.rx.value.asObservable()
            .map{ Int($0) }
            .subscribe { [unowned self] value in
                self.apartment.area = Float(value.element!)
                self.areaLabel.attributedText = "Площадь: \(value.element!) м2".superscripted
            }
            .disposed(by: disposeBag)
        
    }
    
    /// Room count setup
    func setUpRooms() {
        let roomValues: [Float] = [1,2,3,4,5,6]
        
        roomCountSlider.value = apartment.rooms
        roomCountSlider.maximumValue = roomValues.max()!
        roomCountSlider.minimumValue = roomValues.min()!
        
        roomCountSlider.rx.value.asObservable()
            .map{ Int($0) }
            .subscribe { [unowned self] value in
                self.apartment.rooms = Float(value.element!)
                self.roomLabel.text = "Комнат: \(value.element!)"
            }
            .disposed(by: disposeBag)
        
    }
    
}

extension Double {
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
        attributedString.setAttributes([.font: fontSuper, .baselineOffset: 13], range: NSRange(location: self.count-1, length: 1))
        
        return attributedString
    }
}

extension SoothsayerViewController: UIGestureRecognizerDelegate { }
extension SoothsayerViewController: MKMapViewDelegate { }
