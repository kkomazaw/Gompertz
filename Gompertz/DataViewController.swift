//
//  DataViewController.swift
//  Gompertz
//
//  Created by Matsui Keiji on 2020/05/17.
//  Copyright © 2020 Matsui Keiji. All rights reserved.
//

import UIKit
import Accounts

class DataViewController: UIViewController {
    
    var dataText = ""
    
    @IBOutlet var textView:UITextView!
    @IBOutlet var copyButton:UIBarButtonItem!
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: .autoupdatingCurrent)
        textView.text = dataText
        var startTime = 0
        var endTime = Int(ceil(maximalTime))
        if isDatePicker, tx < 0 {
            startTime = Int(tx)
            endTime = Int(t2)
        }//if isDatePicker, tx < 0
        for i in startTime ... endTime {
            let value = exp(lnGmax + (a - lnGmax) * exp(-k * (Double(i) - t0)))
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
            var dayString = "\(i)"
            if isDatePicker {
                let date = Calendar.current.date(byAdding: .day, value: Int(i - startTime), to: theFirstDay)!
                dayString = dateFormatter.string(from: date)
            }
            dataText += "\(dayString)\t\(valueString)\n"
        }//for i in startTime ... endTime
        textView.text = dataText
    }//override func viewDidLoad()
    
    @IBAction func myActionCopy(){
        let activityItems = [textView.text as Any]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }//@IBAction func myActionCopy()
    
}//class DataViewController: UIViewController
