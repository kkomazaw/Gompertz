//
//  SecondViewController.swift
//  Gompertz
//
//  Created by Matsui Keiji on 2020/04/18.
//  Copyright © 2020 Matsui Keiji. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet var mySlider:UISlider!
    @IBOutlet var timeLabel:UILabel!
    @IBOutlet var gMaxLabel:UILabel!
    @IBOutlet var ftLabel:UILabel!
    @IBOutlet var myView:UIView!
    @IBOutlet var myLogView:UIView!
    @IBOutlet var logSelector:UISegmentedControl!
    
    var gMaxText = ""
    var ftText = ""
    var logGmaxText = ""
    var logFtText = ""
    
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: .autoupdatingCurrent)
        myView.isHidden = false
        myLogView.isHidden = true
        gMaxLabel.text = gMaxText
        ftLabel.text = ftText
        let graphDraw = GraphDraw(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth))
        graphDraw.backgroundColor = .clear
        myView.addSubview(graphDraw)
        let logGraphDraw = LogGraphDraw(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth))
        logGraphDraw.backgroundColor = .clear
        myLogView.addSubview(logGraphDraw)
        mySlider.minimumValue = 0.0
        mySlider.maximumValue = Float(ceil(maximalTime))
        sliderCalc()
    }//override func viewDidLoad()
    
    func sliderCalc() {
        
        var value = 0.0
        var adjuster = 0.0
        if tx < 0 {
            adjuster = tx
        }
        if logSelector.selectedSegmentIndex == 0 {
        value = exp(lnGmax + (a - lnGmax) * exp(-k * (Double(Int(mySlider.value)) - t0 + adjuster)))
        }
        else {
            value = lnGmax + (a - lnGmax) * exp(-k * (Double(Int(mySlider.value)) - t0 + adjuster))
        }
        var myFormat = "%.4f"
        switch value {
        case 0 ..< 100:
            myFormat = "%.4f"
        case 100 ..< 1000:
            myFormat = "%.3f"
        case 1000 ..< 10000:
            myFormat = "%.2f"
        case 10000 ..< 100000:
            myFormat = "%.1f"
        default:
            myFormat = "%.0f"
        }//switch value
        let valueString = String(format: myFormat, value)
        if logSelector.selectedSegmentIndex == 0, !isDatePicker {
            timeLabel.text = "time: \(Int(mySlider.value))   F(t): \(valueString)"
        }
        if logSelector.selectedSegmentIndex == 1, !isDatePicker {
            timeLabel.text = "time: \(Int(mySlider.value))   Log F(t): \(valueString)"
        }
        let sliderDate = Calendar.current.date(byAdding: .day, value: Int(mySlider.value), to: theFirstDay)!
        let sliderDateString = dateFormatter.string(from: sliderDate)
        if logSelector.selectedSegmentIndex == 0, isDatePicker {
            timeLabel.text = "d\(Int(mySlider.value)): \(sliderDateString)  F(t): \(valueString)"
        }
        if logSelector.selectedSegmentIndex == 1, isDatePicker {
            timeLabel.text = "d\(Int(mySlider.value)): \(sliderDateString)  Log F(t): \(valueString)"
        }
    }//func sliderCalc()
    
    @IBAction func sliderValueChanged() {
        sliderCalc()
    }//@IBAction func sliderValueChanged()
 
    @IBAction func selectorChanged(){
        sliderCalc()
        switch logSelector.selectedSegmentIndex {
        case 0:
            myView.isHidden = false
            myLogView.isHidden = true
            gMaxLabel.text = gMaxText
            ftLabel.text = ftText
        case 1:
            myView.isHidden = true
            myLogView.isHidden = false
            gMaxLabel.text = logGmaxText
            ftLabel.text = logFtText
        default:
            break
        }//switch logSelector.selectedSegmentIndex
    }//@IBAction func selectorChanged()
    
}//class SecondViewController: UIViewController
