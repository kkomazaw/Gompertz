//
//  LogGraphDraw.swift
//  Gompertz
//
//  Created by Matsui Keiji on 2020/05/06.
//  Copyright © 2020 Matsui Keiji. All rights reserved.
//

import UIKit

class LogGraphDraw: UIView {

    override func draw(_ rect: CGRect) {
        let w15 = 0.15 * screenWidth
        let w70 = 0.7 * screenWidth
        let w85 = 0.85 * screenWidth
        let outerLine = UIBezierPath()
        outerLine.move(to: CGPoint(x: w15, y: w15))
        outerLine.addLine(to: CGPoint(x: w15, y: w85))
        outerLine.addLine(to: CGPoint(x: w85, y: w85))
        UIColor.label.setStroke()
        outerLine.lineWidth = CGFloat(screenWidth / 300.0)
        outerLine.stroke()
        guard isFinished else {return}
        var valueArray = [Double]()
        valueArray.append(log(actualA))
        valueArray.append(log(actualB))
        valueArray.append(log(actualC))
        if hasTx, !vFtx.isInfinite {
            valueArray.append(log(vFtx))
        }
        let maximalValue = valueArray.max()!
        
        let firstNumberT = log10(maximalTime) - floor(log10(maximalTime))
        var maxMeasureT = 0.0
        var minMeasureT = 0.0
        if firstNumberT == 0.0 {maxMeasureT = 1.0}
        if firstNumberT > 0.0, firstNumberT <= log10(1.251) {maxMeasureT = 1.25}
        if firstNumberT > log10(1.251), firstNumberT <= log10(1.501) {maxMeasureT = 1.5}
        if firstNumberT > log10(1.501), firstNumberT <= log10(1.751) {maxMeasureT = 1.75}
        if firstNumberT > log10(1.751), firstNumberT <= log10(2.001) {maxMeasureT = 2.0}
        if firstNumberT > log10(2.001), firstNumberT <= log10(2.501) {maxMeasureT = 2.5}
        if firstNumberT > log10(2.501), firstNumberT <= log10(3.001) {maxMeasureT = 3.0}
        if firstNumberT > log10(3.001), firstNumberT <= log10(3.501) {maxMeasureT = 3.5}
        if firstNumberT > log10(3.501), firstNumberT <= log10(4.001) {maxMeasureT = 4.0}
        if firstNumberT > log10(4.001), firstNumberT <= log10(4.501) {maxMeasureT = 4.5}
        if firstNumberT > log10(4.501), firstNumberT <= log10(5.001) {maxMeasureT = 5.0}
        if firstNumberT > log10(5.001), firstNumberT <= log10(6.001) {maxMeasureT = 6.0}
        if firstNumberT > log10(6.001), firstNumberT <= log10(7.001) {maxMeasureT = 7.0}
        if firstNumberT > log10(7.001), firstNumberT <= log10(8.001) {maxMeasureT = 8.0}
        if firstNumberT > log10(8.001), firstNumberT <= log10(9.001) {maxMeasureT = 9.0}
        if firstNumberT > log10(9.001) {maxMeasureT = 10.0}
        minMeasureT = maxMeasureT / 5.0
        let upperTime = maxMeasureT * pow(10, floor(log10(maximalTime)))
        let intervalT = w70 * 0.2
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attrs = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: CGFloat(Int(0.04 * screenWidth)))!, NSAttributedString.Key.paragraphStyle: paragraphStyle,.foregroundColor: UIColor.label]
        for i in 0 ... 5 {
            let shortLine = UIBezierPath()
            let x = w15 + Double(i) * intervalT
            shortLine.move(to: CGPoint(x: x, y: w15))
            shortLine.addLine(to: CGPoint(x: x, y: w85 + 0.02 * screenWidth))
            UIColor.lightGray.setStroke()
            shortLine.lineWidth = CGFloat(screenWidth / 800.0)
            shortLine.stroke()
            var decimalFormat = "%.1f"
            if maxMeasureT == 1.25 || maxMeasureT == 1.75 {
                decimalFormat = "%.2f"
            }
            if maxMeasureT == 10.0 {
                decimalFormat = "%.0f"
            }
            var string = String(format: decimalFormat, Double(i) * minMeasureT)
            if floor(log10(maximalTime)) == 1.0, maxMeasureT != 1.25, maxMeasureT != 1.75 {
                string = String(format: "%.0f", Double(i) * minMeasureT * 10)
            }
            if floor(log10(maximalTime)) == 1.0, (maxMeasureT == 1.25 || maxMeasureT == 1.75) {
                string = String(format: "%.1f", Double(i) * minMeasureT * 10)
            }
            if floor(log10(maximalTime)) == 2.0 {
                string = String(format: "%.0f", Double(i) * minMeasureT * 100)
            }
            string.draw(with: CGRect(x: x - 0.05 * screenWidth, y: 0.868 * screenWidth, width: 0.1 * screenWidth, height: 0.1 * screenWidth), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        }//for i in 0 ... 5
        var string = "×10"
        var upperString = String(Int(round(floor(log10(maximalTime)))))
        if floor(log10(maximalTime)) <= 2.0 {
            string = ""
            upperString = ""
        }
        string.draw(with: CGRect(x: 0.872 * screenWidth, y: 0.868 * screenWidth, width: 0.1 * screenWidth, height: 0.1 * screenWidth), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        let upperAttrs = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: CGFloat(Int(0.03 * screenWidth)))!, NSAttributedString.Key.paragraphStyle: paragraphStyle,.foregroundColor: UIColor.label]
        upperString.draw(with: CGRect(x: 0.915 * screenWidth, y: 0.858 * screenWidth, width: 0.1 * screenWidth, height: 0.1 * screenWidth), options: .usesLineFragmentOrigin, attributes: upperAttrs, context: nil)
        let firstNumberV = log10(maximalValue) - floor(log10(maximalValue))
        var maxMeasureV = 0.0
        var minMeasureV = 0.0
        if firstNumberV == 0.0 {maxMeasureV = 1.0}
        if firstNumberV > 0.0, firstNumberV <= log10(1.251) {maxMeasureV = 1.25}
        if firstNumberV > log10(1.251), firstNumberV <= log10(1.501) {maxMeasureV = 1.5}
        if firstNumberV > log10(1.501), firstNumberV <= log10(1.751) {maxMeasureV = 1.75}
        if firstNumberV > log10(1.751), firstNumberV <= log10(2.001) {maxMeasureV = 2.0}
        if firstNumberV > log10(2.001), firstNumberV <= log10(2.501) {maxMeasureV = 2.5}
        if firstNumberV > log10(2.501), firstNumberV <= log10(3.001) {maxMeasureV = 3.0}
        if firstNumberV > log10(3.001), firstNumberV <= log10(3.501) {maxMeasureV = 3.5}
        if firstNumberV > log10(3.501), firstNumberV <= log10(4.001) {maxMeasureV = 4.0}
        if firstNumberV > log10(4.001), firstNumberV <= log10(4.501) {maxMeasureV = 4.5}
        if firstNumberV > log10(4.501), firstNumberV <= log10(5.001) {maxMeasureV = 5.0}
        if firstNumberV > log10(5.001), firstNumberV <= log10(6.001) {maxMeasureV = 6.0}
        if firstNumberV > log10(6.001), firstNumberV <= log10(7.001) {maxMeasureV = 7.0}
        if firstNumberV > log10(7.001), firstNumberV <= log10(8.001) {maxMeasureV = 8.0}
        if firstNumberV > log10(8.001), firstNumberV <= log10(9.001) {maxMeasureV = 9.0}
        if firstNumberV > log10(9.001) {maxMeasureV = 10.0}
        minMeasureV = maxMeasureV / 5.0
        let upperValue = maxMeasureV * pow(10, floor(log10(maximalValue)))
        let intervalV = w70 * 0.2
        for i in 0 ... 5 {
            let shortLine = UIBezierPath()
            let y = w85 - Double(i) * intervalV
            shortLine.move(to: CGPoint(x: w15 - 0.02 * screenWidth, y: y))
            shortLine.addLine(to: CGPoint(x: w85, y: y))
            UIColor.lightGray.setStroke()
            shortLine.lineWidth = CGFloat(screenWidth / 800.0)
            shortLine.stroke()
            var decimalFormat = "%.1f"
            if maxMeasureV == 1.25 || maxMeasureV == 1.75 {
                decimalFormat = "%.2f"
            }
            if maxMeasureV == 10.0 {
                decimalFormat = "%.0f"
            }
            var string = String(format: decimalFormat, Double(i) * minMeasureV)
            if floor(log10(maximalValue)) == 1.0 ,maxMeasureV != 1.25, maxMeasureV != 1.75{
                string = String(format: "%.0f", Double(i) * minMeasureV * 10)
            }
            if floor(log10(maximalValue)) == 1.0 , (maxMeasureV == 1.25 || maxMeasureV == 1.75) {
                string = String(format: "%.1f", Double(i) * minMeasureV * 10)
            }
            if floor(log10(maximalValue)) == 2.0 {
                string = String(format: "%.0f", Double(i) * minMeasureV * 100)
            }
            string.draw(with: CGRect(x: 0.04 * screenWidth, y: y - 0.022 * screenWidth, width: 0.1 * screenWidth, height: 0.1 * screenWidth), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        }//for i in 0 ... 5
        
        var vF0 = lnGmax + (a - lnGmax) * exp(-k * (-t0))
        if tx < 0 {
            vF0 = lnGmax + (a - lnGmax) * exp(-k * (tx - t0))
        }
        let line = UIBezierPath()
        line.move(to: CGPoint(x: w15, y: w85 - w70 * vF0 / upperValue))
        var startTime = 1
        var endTime = Int(ceil(maximalTime))
        if isDatePicker, tx < 0 {
            startTime = Int(tx) + 1
            endTime = Int(t2)
        }
        for i in startTime ... endTime {
            let value = lnGmax + (a - lnGmax) * exp(-k * (Double(i) - t0))
            line.addLine(to: CGPoint(x: w15 + w70 * Double(i - startTime + 1) / upperTime, y: w85 - w70 * value / upperValue))
        }//for i in startTime ... endTime
        UIColor.systemBlue.setStroke()
        line.lineWidth = CGFloat(screenWidth / 200.0)
        line.stroke()
        
        var stringV = "×10"
        var upperStringV = String(Int(round(floor(log10(maximalValue)))))
        if floor(log10(maximalValue)) <= 2.0 {
            stringV = ""
            upperStringV = ""
        }
        stringV.draw(with: CGRect(x: 0.06 * screenWidth, y: 0.093 * screenWidth, width: 0.1 * screenWidth, height: 0.1 * screenWidth), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        
        upperStringV.draw(with: CGRect(x: 0.103 * screenWidth, y: 0.083 * screenWidth, width: 0.1 * screenWidth, height: 0.1 * screenWidth), options: .usesLineFragmentOrigin, attributes: upperAttrs, context: nil)
        let valueString = "LogF"
        valueString.draw(with: CGRect(x: 0, y: 0.48 * screenWidth, width: 0.1 * screenWidth, height: 0.1 * screenWidth), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        let timeString = "time"
        timeString.draw(with: CGRect(x: 0.45 * screenWidth, y: 0.9 * screenWidth, width: 0.1 * screenWidth, height: 0.1 * screenWidth), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
    }//override func draw(_ rect: CGRect)
    
}//class LogGraphDraw: UIView
