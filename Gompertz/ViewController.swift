//
//  ViewController.swift
//  Gompertz
//
//  Created by Matsui Keiji on 2020/04/10.
//  Copyright © 2020 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet var timeDateSelector:UISegmentedControl!
    @IBOutlet var t0TextField: UITextField!
    @IBOutlet var t1TextField:UITextField!
    @IBOutlet var t2TextField:UITextField!
    @IBOutlet var ATextField:UITextField!
    @IBOutlet var BTextField:UITextField!
    @IBOutlet var CTextField:UITextField!
    @IBOutlet var txTextField:UITextField!
    @IBOutlet var RUNButton:UIButton!
    @IBOutlet var clearButton:UIBarButtonItem!
    @IBOutlet var graphButton:UIBarButtonItem!
    @IBOutlet var logFt:UILabel!
    @IBOutlet var ft:UILabel!
    @IBOutlet var gmax:UILabel!
    @IBOutlet var lnGmaxLabel:UILabel!
    @IBOutlet var ftx:UILabel!
    @IBOutlet var savedUpperButton:UIBarButtonItem!
    @IBOutlet var dataBarButton:UIBarButtonItem!
    @IBOutlet var saveLowerButton:UIBarButtonItem!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let formatter = DateFormatter()
    var datePicker = UIDatePicker()
    var now = Date()
    var t0Saved = ""
    var t1Saved = ""
    var t2Saved = ""
    var ft0Saved = ""
    var ft1Saved = ""
    var ft2Saved = ""
    var txSaved = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        t0Saved = ""
        t1Saved = ""
        t2Saved = ""
        ft0Saved = ""
        ft1Saved = ""
        ft2Saved = ""
        txSaved = ""
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = .autoupdatingCurrent
        screenWidth = Double(view.bounds.width)
        screenHeight = Double(view.bounds.height)
        t0TextField.becomeFirstResponder()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: .autoupdatingCurrent)
    }//override func viewDidLoad()
    
    func showLabels(){
        logFt.textColor = .label
        ft.textColor = .label
        gmax.textColor = .label
        lnGmaxLabel.textColor = .label
        ftx.textColor = .label
    }
    
    func hideLabels(){
        logFt.textColor = .systemBackground
        ft.textColor = .systemBackground
        gmax.textColor = .systemBackground
        lnGmaxLabel.textColor = .systemBackground
        ftx.textColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let nc = NotificationCenter.default
    nc.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    nc.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        hideLabels()
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        showLabels()
    }
    
    func keyboardChanger(){
        switch timeDateSelector.selectedSegmentIndex {
        case 0://Time is selected.
            isDatePicker = false
            view.endEditing(true)
            t0TextField.text = ""
            t0TextField.inputView = nil
            t0TextField.inputAccessoryView = nil
            t0TextField.keyboardType = .decimalPad
            t1TextField.text = ""
            t1TextField.inputView = nil
            t1TextField.inputAccessoryView = nil
            t1TextField.keyboardType = .decimalPad
            t2TextField.text = ""
            t2TextField.inputView = nil
            t2TextField.inputAccessoryView = nil
            t2TextField.keyboardType = .decimalPad
            txTextField.text = ""
            txTextField.inputView = nil
            txTextField.inputAccessoryView = nil
            txTextField.keyboardType = .decimalPad
        case 1://DatePicker is selected
            isDatePicker = true
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
            let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
            toolbar.setItems([spacelItem, doneItem], animated: true)
            view.endEditing(true)
            t0TextField.text = ""
            t0TextField.inputView = datePicker
            t0TextField.inputAccessoryView = toolbar
            t1TextField.text = ""
            t1TextField.inputView = datePicker
            t1TextField.inputAccessoryView = toolbar
            t2TextField.text = ""
            t2TextField.inputView = datePicker
            t2TextField.inputAccessoryView = toolbar
            txTextField.text = ""
            txTextField.inputView = datePicker
            txTextField.inputAccessoryView = toolbar
        default:
            break
        }//switch timeDateSelector.selectedSegmentIndex
    }
    
    @IBAction func selectorChanged(){
        keyboardChanger()
        t0TextField.becomeFirstResponder()
    }//@IBAction func selectorChanged()
    
    @objc func done() {
        let dateString = formatter.string(from: datePicker.date)
        if t0TextField.isEditing {t0TextField.text = dateString}
        if t1TextField.isEditing {t1TextField.text = dateString}
        if t2TextField.isEditing {t2TextField.text = dateString}
        if txTextField.isEditing {txTextField.text = dateString}
    }//@objc func done()
    
    func calc() {
        view.endEditing(true)
        isFinished = false
        hasTx = false
        switch isDatePicker {
        case false:
            t0 = Double(t0TextField.text!) ?? 0.0
            t1 = Double(t1TextField.text!) ?? 0.0
            t2 = Double(t2TextField.text!) ?? 0.0
        case true:
            t0 = 0.0
            let nowString = formatter.string(from: now)
            let day0:Date = formatter.date(from: t0TextField.text ?? nowString) ?? now
            let day1:Date = formatter.date(from: t1TextField.text ?? nowString) ?? now
            let day2:Date = formatter.date(from: t2TextField.text ?? nowString) ?? now
            let dayInterval0_1 = (Calendar.current.dateComponents([.day], from: day0, to: day1)).day
            let dayInterval0_2 = (Calendar.current.dateComponents([.day], from: day0, to: day2)).day
            t1 = Double(dayInterval0_1!)
            t2 = Double(dayInterval0_2!)
            print("t0: \(t0) t1: \(t1) t2: \(t2)")
        }
        
        actualA = Double(ATextField.text!) ?? 0.0001
        actualB = Double(BTextField.text!) ?? 0.0001
        actualC = Double(CTextField.text!) ?? 0.0001
        a = log(actualA)
        let b = log(actualB)
        let c = log(actualC)
        if t0 >= t1 || t1 >= t2 {
            labelClearOnError()
            let alert = UIAlertController(title: "time setting", message: "t0 < t1 < t2 is required.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }//if t0 >= t1 || t1 >= t2
        let slopeAB = (b - a) / (t1 - t0)
        let slopeAC = (c - a) / (t2 - t0)
        let slopeBC = (c - b) / (t2 - t1)
        if slopeAB * slopeBC <= 0 {
            labelClearOnError()
            let alert = UIAlertController(title: "Change values", message: "A<B<C or A>B>C", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }//if slopeAB * slopeBC <= 0
        if slopeAB == slopeBC {
            let alert = UIAlertController(title: "Change values", message: "It's not Gompertz but exponential.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }//if slopeAB == slopeBC
        var midBUpper = 0.0
        var midBLower = 0.0
        if slopeAC > 0 && slopeAB > slopeBC {
            midBUpper = c
            midBLower = (a + c) / 2
        }
        if slopeAC > 0 && slopeAB < slopeBC {
            midBUpper = (a + c) / 2
            midBLower = a
        }
        if slopeAC < 0 && slopeAB < slopeBC {
            midBUpper = (a + c) / 2
            midBLower = c
        }
        if slopeAC < 0 && slopeAB > slopeBC {
            midBUpper = a
            midBLower = (a + c) / 2
        }
        var midB = (midBUpper + midBLower) / 2
        lnGmax = 0.0
        k = 0.0
        var calcB = 0.0
        for _ in 0 ... 100 {
            lnGmax = (a * c - midB * midB) / (a - 2 * midB + c)
            k = -1 / ((t2 - t0) / 2) * log((midB - c) / (a - midB))
            calcB = lnGmax + (a - lnGmax) * exp(-k * (t1 - t0))
            if calcB == b{
                break
            }
            else if b > calcB{
                midBLower = midB
            }
            else if b < calcB{
                midBUpper = midB
            }
            midB = (midBLower + midBUpper) / 2
        }//for _ in 0...100
        var myFormat = "%.4f"
        switch exp(lnGmax) {
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
        }
        let slnGmax = String(format: "%.4f", lnGmax)
        let sGmax = String(format: myFormat, exp(lnGmax))
        let sB = String(format: "%.4f",exp(-(lnGmax - a)))
        let slnGmax_a = String(format: "%.4f", abs(lnGmax - a))
        let sk = String(format: "%.4f", -k)
        var st0 = String(t0)
        if floor(t0) == t0 {
            st0 = "(t-\(Int(t0)))"
        }
        else {
            st0 = "(t-\(t0))"
        }
        if st0 == "(t-0)" {
            st0 = "t"
        }
        var fugo = "-"
        if lnGmax - a < 0 {
            fugo = "+"
        }
        logFt.text = "LogF(t) = \(slnGmax)\(fugo)\(slnGmax_a)e^(\(sk)×\(st0))"
        var minOrMax = ""
        var lnMinOrMax = ""
        if lnGmax > b {
            minOrMax = "Gmax"
            lnMinOrMax = "Log Gmax"
        }
        else {
            minOrMax = "Gmin"
            lnMinOrMax = "Log Gmin"
        }
        gmax.text = "\(minOrMax) = \(sGmax)"
        lnGmaxLabel.text = "\(lnMinOrMax) = \(slnGmax)"
        ft.text = "F(t) = \(sGmax)×\(sB)^(e^(\(sk)×\(st0)))"
        isFinished = true
        ftx.text = ""
        tx = 0.0
        if let _tx = Double(txTextField.text!), !isDatePicker{
            hasTx = true
            tx = _tx
            vFtx = exp(lnGmax + (a - lnGmax) * exp(-k * (tx - t0)))
            var myFormat = "%.4f"
            switch vFtx {
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
            }
            let sFtx = String(format: myFormat, vFtx)
            ftx.text = "F(tx) = \(sFtx)"
        }//if let _tx = Double(txTextField.text!)
        if isDatePicker {
            let nowString = formatter.string(from: now)
            let day0:Date = formatter.date(from: t0TextField.text ?? nowString) ?? now
            theFirstDay = day0
            if let dayTx = formatter.date(from: txTextField.text ?? "") {
                let dayInterval0_x = (Calendar.current.dateComponents([.day], from: day0, to: dayTx)).day
                tx = Double(dayInterval0_x!)
                if tx < 0 {
                    theFirstDay = dayTx
                }
                hasTx = true
                vFtx = exp(lnGmax + (a - lnGmax) * exp(-k * (tx - t0)))
                var myFormat = "%.4f"
                switch vFtx {
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
                }
                let sFtx = String(format: myFormat, vFtx)
                ftx.text = "F(tx) = \(sFtx)"
            }
        }//if isDatePicker
        maximalTime = t2
        if tx > t2 {
            maximalTime = tx
        }
        if isDatePicker, tx < 0 {
            maximalTime = t2 - tx
        }
        print("maximal time: \(maximalTime)")
    }//func calc()
    
    @IBAction func myActionRun(){
        calc()
    }//@IBAction func myActionRun()
    
    @IBAction func myActionClear(){
        t0TextField.text = ""
        t1TextField.text = ""
        t2TextField.text = ""
        txTextField.text = ""
        ATextField.text = ""
        BTextField.text = ""
        CTextField.text = ""
        txTextField.text = ""
        gmax.text = ""
        lnGmaxLabel.text = ""
        ft.text = ""
        logFt.text = ""
        ftx.text = ""
        isFinished = false
        hasTx = false
        keyboardChanger()
        t0TextField.becomeFirstResponder()
    }//@IBAction func myActionClear()
    
    func labelClearOnError(){
        gmax.text = ""
        lnGmaxLabel.text = ""
        ft.text = ""
        logFt.text = ""
        ftx.text = ""
    }//func labelClearOnError()
    
    @IBAction func graphButttonPushed(){
        calc()
        performSegue(withIdentifier: "toSecondView", sender: true)
    }//@IBAction func graphButttonPushed()
    
    @IBAction func dataButtonPushed(){
        calc()
        performSegue(withIdentifier: "toDataView", sender: true)
    }//@IBAction func dataButtonPushed()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSecondView" {
        let toSubView = segue.destination as! SecondViewController
            toSubView.gMaxText = gmax.text!
            toSubView.ftText = ft.text!
            toSubView.logGmaxText = lnGmaxLabel.text!
            toSubView.logFtText = logFt.text!
        }//if segue.identifier == "toSubView"
        if segue.identifier == "toDataView" {
            let toSubView = segue.destination as! DataViewController
            var dataText = gmax.text! + "\n"
            dataText += lnGmaxLabel.text! + "\n"
            dataText += ft.text! + "\n"
            dataText += logFt.text! + "\n"
            dataText += ftx.text! + "\n\n"
            dataText += "day\tF(t)\n"
            toSubView.dataText = dataText
        }//if segue.identifier == "toDataView"
    }// override func prepare(for segue
    
    @IBAction func myActionSave(){
        guard isFinished else {return}
        var titleString = "注釈入力"
        var messageString = "注釈（メモ、名前等）が入力できます\n（日付は自動的に入力されます）"
        var okString = "入力完了"
        if Locale.autoupdatingCurrent.identifier != "ja_JP" {
            titleString = "Note"
            messageString = "You can add an anotation.\nDate is included automatically."
            okString = "Done"
        }
        let alert = UIAlertController(title:titleString, message: messageString, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: okString, style: UIAlertAction.Style.default, handler:{(action:UIAlertAction!) -> Void in
            let textField = alert.textFields![0]
            let gompertzData = GompertzData(context: self.myContext)
            gompertzData.date = Date()
            gompertzData.memo = textField.text
            gompertzData.t0 = self.t0TextField.text
            gompertzData.t1 = self.t1TextField.text
            gompertzData.t2 = self.t2TextField.text
            gompertzData.ft0 = self.ATextField.text
            gompertzData.ft1 = self.BTextField.text
            gompertzData.ft2 = self.CTextField.text
            var stringTx = ""
            if hasTx {
                stringTx = self.txTextField.text!
            }
            gompertzData.tx = stringTx
            gompertzData.isDatePicker = isDatePicker
            gompertzData.hasTx = hasTx
            self.performSegue(withIdentifier: "toSaveView", sender: true)
        }) //let okAction = UIAlertAction
        let cancelAction = UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler:{(action:UIAlertAction!) -> Void in
        }) //let cancelAction = UIAlertAction
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        // UIAlertControllerにtextFieldを追加
        alert.addTextField { (textField:UITextField!) -> Void in }
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    } //@IBAction func myActionSave()
    
    @IBAction func fromSavedToView(_ Segue:UIStoryboardSegue){
        guard !t0Saved.isEmpty else {return}
        if isDatePicker {
            timeDateSelector.selectedSegmentIndex = 1
        }
        else {
            timeDateSelector.selectedSegmentIndex = 0
        }
        keyboardChanger()
        t0TextField.text = t0Saved
        t1TextField.text = t1Saved
        t2TextField.text = t2Saved
        ATextField.text = ft0Saved
        BTextField.text = ft1Saved
        CTextField.text = ft2Saved
        txTextField.text = txSaved
        print("Unwind is completed. t0Saved: \(t0Saved)")
        calc()
    } //@IBAction func fromSavedToView
    
    override func viewWillDisappear(_ animated: Bool) {
        t0Saved = ""
        t1Saved = ""
        t2Saved = ""
        ft0Saved = ""
        ft1Saved = ""
        ft2Saved = ""
        txSaved = ""
        view.endEditing(true)
    }
    
}//class ViewController: UIViewController

