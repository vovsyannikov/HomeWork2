//
//  SimpleNumbersViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 22.10.2020.
//

import UIKit

class SimpleNumbersViewController: UIViewController {
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabel.text = ""
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func findSimpleNums(from input: String) -> String {
        var result = ""
        var numberSet: Set<Int> = Set()
        if let number = Double(input) {
            for currNum in 1...Int(number){
                var divisions = 0
                for count in 1...currNum{
                    if Double(currNum).remainder(dividingBy: Double(count)) == 0 {
                        divisions += 1
                    }
                    if divisions > 2 { break }
                }
                if divisions <= 2 {
                    numberSet.insert(currNum)
                }
            }
            
            
        } else {
            print("Not a number")
        }
        var decimal = 0
        for num in numberSet.sorted(){
            if decimal == 10 {
                result = "\(result.dropLast(2))"
                result.append("\n")
                decimal = 1
            }
            result.append("\(num), ")
            decimal += 1
        }
        return "\(result.dropLast(2))"
    }
    
    @IBAction func findSimples(_ sender: Any) {
        var timer = MyTimer()
        let currentNumber = self.numberTextField.text!
        
        DispatchQueue.global(qos: .utility).async { [unowned self] in
            let resultingString = self.findSimpleNums(from: currentNumber)
            timer.stop()
            print("Time spent \(timer.timeSpent)")
            print(resultingString)
            DispatchQueue.main.async {
                [unowned self] in
                
                self.resultLabel.text = resultingString
            }
        }
    }
    
}

struct MyTimer {
    private var dateFormatter = DateFormatter()
    
    private var startTime: Date!
    private var endTime: Date!
    
    var timeSpent: String = ""
    
    init () {
        startTime = .init(timeIntervalSinceNow: 0)
        dateFormatter.dateFormat = "ss.SSS"
    }
    
    mutating func stop(){
        endTime = Date(timeIntervalSinceNow: 0)
        let finalTime = countTime()
        var counter = -1
        var foundDot = false
        for c in String(finalTime){
            timeSpent.append(c)
            if c == "." { foundDot = true }
            if foundDot { counter += 1 }
            if counter == 3 { break }
        }
    }
    
    mutating func countTime() -> Double{
        return Double(self.dateFormatter.string(from: endTime))! - Double(self.dateFormatter.string(from: startTime))!
    }
}
