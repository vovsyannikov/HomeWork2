//
//  FunctionProcessingViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 22.10.2020.
//

import UIKit

typealias task = (() -> Void)

class FunctionProcessingViewController: UIViewController {
    
    var processor: Processor!
    
    private var activityIndicators: [UIActivityIndicatorView]!
    private var progressViews: [UIProgressView]!
    
    @IBOutlet weak var task1ProgressView: UIProgressView!
    @IBOutlet weak var task1ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var task2ProgressView: UIProgressView!
    @IBOutlet weak var task2ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var task3ProgressView: UIProgressView!
    @IBOutlet weak var task3ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var task4ProgressView: UIProgressView!
    @IBOutlet weak var task4ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var task5ProgressView: UIProgressView!
    @IBOutlet weak var task5ActivityIndicator: UIActivityIndicatorView!
    
    func firstTask(){
        startProgress(for: 1)
        print("Тупые расчеты")
        
        var array = Array<Int>()
        var result = 0
        
        for num in 1...1_000_000{
            array.append(num)
        }
        
        setProgress(0.3, for: 1)
        
        for num in array{
            result += num*2
        }
        setProgress(0.5, for: 1)
        
        result /= (array.count / 2)
        print(result)
        stopProgress(for: 1)
    }
    func secondTask(){
        startProgress(for: 2)
        print("Загрузка 4К картинки")
        
        let data = (try? Data(contentsOf: URL(string: "https://picsum.photos/3840/2160")! ))!
        
        setProgress(0.3, for: 2)
        
        let image = UIImage(data: data)
        print(image!)
        
        stopProgress(for: 2)
    }
    func thirdTask(){
        startProgress(for: 3)
        let thirdTaskConstant = 10_000 // Число, до которого искать простые числа
        print("Нахождение простого числа от \(thirdTaskConstant)")
        
        var numberSet = Set<Int>()
        for currNum in 1...thirdTaskConstant{
                switch currNum{
                case 1_000: setProgress(0.1, for: 3)
                case 2_000: setProgress(0.2, for: 3)
                case 3_000: setProgress(0.3, for: 3)
                case 4_000: setProgress(0.4, for: 3)
                case 5_000: setProgress(0.5, for: 3)
                case 6_000: setProgress(0.6, for: 3)
                case 7_000: setProgress(0.7, for: 3)
                case 8_000: setProgress(0.8, for: 3)
                case 9_000: setProgress(0.9, for: 3)
                default: print("", terminator: "")
                }
            
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
        print(numberSet.count)
        stopProgress(for: 3)
    }
    func fourthTask(){
        startProgress(for: 4)
        print("Загрузка 3 HD картинок с размытием")
        
        for i in 1...3{
            let data = (try? Data(contentsOf: URL(string: "https://picsum.photos/1280/720")! ))!
            let image = UIImage(data: data)?.blurred
            print(image!)
            
            setProgress(0.3 * Float(i), for: 4)
        }
        stopProgress(for: 4)
    }
    func fifthTask(){
        startProgress(for: 5)
        var availableTasks = [firstTask, secondTask, thirdTask, fourthTask]
        
        let count = Int.random(in: 1...4)
        print(count == 1 ? "Вызов случайной функции" : "Вызов \(count) случайных функций")
        
        for i in 1...count{
            setProgress(Float(i) / Float(count), for: 5)
            
            let removeTask = Int.random(in: 0..<availableTasks.count)
            let taskToRun = availableTasks.remove(at: removeTask)
            taskToRun()
        }
        stopProgress(for: 5)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicators = [
            task1ActivityIndicator,
            task2ActivityIndicator,
            task3ActivityIndicator,
            task4ActivityIndicator,
            task5ActivityIndicator
        ]
        
        progressViews = [
            task1ProgressView,
            task2ProgressView,
            task3ProgressView,
            task4ProgressView,
            task5ProgressView
        ]
        
        processor = Processor()
        processor.opQueue.maxConcurrentOperationCount = 1
    }
    
    func startProgress(for index: Int, fromFunc: Bool = true){
        let actIndicator = activityIndicators[index-1]
        let prView = progressViews[index-1]
        
        DispatchQueue.main.async {
            actIndicator.startAnimating()
            prView.progress = 0
        }
        if fromFunc{
            print("++++++++++")
        }
    }
    
    func setProgress(_ progress: Float, for index: Int){
        let prView = progressViews[index-1]
        
        DispatchQueue.main.async {
            prView.setProgress(progress, animated: true)
        }
    }
    
    func stopProgress(for index: Int){
        let actIndicator = activityIndicators[index-1]
        let prView = progressViews[index-1]
        
        DispatchQueue.main.async {
            actIndicator.stopAnimating()
            prView.setProgress(1, animated: true)
        }
        print("----------")
    }
    
    
    @IBAction func startTask1(_ sender: Any) {
        processor.tasks.append(firstTask)
        startProgress(for: 1, fromFunc: false)
        processor.run()
    }
    @IBAction func startTask2(_ sender: Any) {
        processor.tasks.append(secondTask)
        startProgress(for: 2, fromFunc: false)
        processor.run()
    }
    @IBAction func startTask3(_ sender: Any) {
        processor.tasks.append(thirdTask)
        startProgress(for: 3, fromFunc: false)
        processor.run()
    }
    @IBAction func startTask4(_ sender: Any) {
        processor.tasks.append(fourthTask)
        startProgress(for: 4, fromFunc: false)
        processor.run()
    }
    @IBAction func startTask5(_ sender: Any) {
        processor.tasks.append(fifthTask)
        processor.run()
    }
    
    
}

class Processor{
    var tasks: [task] = []
    let opQueue = OperationQueue()
    
    func run(){
        for t in tasks{
            opQueue.addOperation(t)
        }
        tasks = []
    }
}
