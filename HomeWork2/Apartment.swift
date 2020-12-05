//
//  Apartment.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 03.12.2020.
//

import Foundation
import RxSwift
import CoreML
import MapKit

// FIXME: Model is getting stuff wrong!
fileprivate let model = ApartmentCostPredictionModel()

struct Apartment {
    var area: Float { didSet { makePrediction() } }
    var floor: Float  { didSet { makePrediction() } }
    var rooms: Float  { didSet { makePrediction() } }
    var coordinates: CLLocationCoordinate2D { didSet { makePrediction() } }
    var cost: BehaviorSubject<Double> = .init(value: 0.0)
    
    private mutating func makePrediction() {
        let prediction = try? model.prediction(
            Area: Double(area),
            Floor: Double(floor),
            Rooms: Double(rooms),
            Latitude: coordinates.latitude,
            Longitude: coordinates.longitude)
        
        
        let predictedCost: BehaviorSubject<Double> = .init(value: prediction?.Cost ?? 0.0)
        
        predictedCost.asObservable()
            .bind(to: cost)
            .dispose()
        
        print("The cost is \(try! cost.value())")
    }
}
