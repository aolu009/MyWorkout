//
//  TrainRecordingViewController.swift
//  MyWorkout
//
//  Created by Lu Ao on 12/27/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//

import UIKit
import Charts
import ReactiveSwift

class TrainRecordingViewController: UIViewController {

    private var lineChartView: LineChartView!
    private var heartRate = MutableProperty<Double>(0.0)
    private var minHR: Double = 500
    private var date = Date()
    private var xLabel = [String]()
    private let legend = chartLegends()
    var pauseButton: UIButton!
    var pauseView: TrainRecordingPausingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setupPauseButton()
        setupPauseView()
    }

    func initViews(){
        let frame = CGRect(x: 0, y: 2 * view.bounds.height/3 - 100, width: view.bounds.width, height: view.bounds.height/3)
        setupLineChartView(frame: frame, valueLabelName: "HR",extraEntries: [legend.maxHRlegendEntry,legend.durationLegend])
        heartRate <~ Bluetooth.manage.heartRateDouble.signal
        heartRate.signal.observeValues { (HR) in
            //if startPressed
            self.updateChart(value: HR)
            
        }
    }

}
private extension TrainRecordingViewController{
    //TODO: Add documentation
    func setupLineChartView(frame:CGRect,valueLabelName: String,extraEntries: [LegendEntry] = [],chartDescription: String = "Heart Rate",yMin:Double = 50,yMax:Double = 110){
        let hRDataSet = LineChartDataSet(values: [], label: "Current \(valueLabelName):")//ChartDataEntry()
        hRDataSet.drawCirclesEnabled = false
        hRDataSet.drawValuesEnabled = false
        hRDataSet.setColor(.red)
        hRDataSet.lineWidth = 1.5
        
        
        lineChartView = LineChartView(frame: frame)
        lineChartView.setVisibleXRangeMaximum(1)
        lineChartView.setVisibleYRangeMaximum(1, axis: .left)
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.axisMinimum = 1
        lineChartView.borderLineWidth = 5
        
        lineChartView.chartDescription?.text = chartDescription
        lineChartView.leftAxis.axisMinimum = 50
        lineChartView.leftAxis.axisMaximum = 110
        lineChartView.leftAxis.drawTopYLabelEntryEnabled = true
        lineChartView.rightAxis.enabled = false
        
        lineChartView.legend.extraEntries.append(legend.hRlegendEntry)
        lineChartView.legend.extraEntries.append(contentsOf: extraEntries)
        lineChartView.data = LineChartData(dataSet: hRDataSet)
        lineChartView.data?.notifyDataChanged()
        lineChartView.notifyDataSetChanged()
        view.addSubview(lineChartView)
        //lineChartView.xAxis.setLabelCount(<#T##count: Int##Int#>, force: <#T##Bool#>)
        //lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["true"])
    }
    
    func updateChart(value: Double){
        let dataset = self.lineChartView.data?.getDataSetByIndex(0)
        let dataEntry = ChartDataEntry(x: Double(dataset?.entryCount ?? 0), y: value)
        date = Double(dataset?.entryCount ?? 0) == 0 ? Date() : date
        let time = DateFormatter.localizedString(from: date.addingTimeInterval(date.timeIntervalSinceNow * -1), dateStyle: .none, timeStyle: DateFormatter.Style.short)
        xLabel.append(time)
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xLabel)
        lineChartView.data?.addEntry(dataEntry, dataSetIndex: 0)
        minHR = max(value,minHR)
        lineChartView.legend.extraEntries[0].label = "\(value)"
        lineChartView.legend.extraEntries[1].label = "Max HR: \(self.minHR)"
        lineChartView.legend.extraEntries[2].label = "Duration: \(round(date.timeIntervalSinceNow * -1)) S"
        
        lineChartView.data?.notifyDataChanged()
        lineChartView.notifyDataSetChanged()
        lineChartView.moveViewToX(Double(dataset?.entryCount ?? 0))
    }
    
    func setupPauseButton(){
        let frame = CGRect(x: self.view.bounds.width/2 - 45, y: self.view.frame.height, width: 90, height: 90)
        pauseButton = UIButton(type: .custom)
        pauseButton.frame = frame
        
        pauseButton.imageView?.contentMode = .scaleAspectFill
        pauseButton.setImage(#imageLiteral(resourceName: "PauseButton.png"), for: .normal)
//        pauseButton.layer.cornerRadius = 0.5 * pauseButton.frame.width
//        pauseButton.layer.borderColor = UIColor.blue.cgColor
//        pauseButton.layer.borderWidth = 1
        pauseButton.backgroundColor = UIColor.white
        pauseButton.addTarget(self, action: #selector(didTapPauseButton), for: .touchUpInside)
        
        view.addSubview(pauseButton)
    }
    
    func setupPauseView(){
        let frame = CGRect(x: view.bounds.width/2, y: 5 * view.bounds.height/6 - 30, width: view.bounds.width, height: view.bounds.height/3)
        pauseView = TrainRecordingPausingView(frame: frame)
        pauseView.frame.size.width = 0
        pauseView.frame.size.height = 0
        pauseView.continueButton.addTarget(self, action: #selector(didTapPausingViewButton), for: .touchUpInside)
        pauseView.endButton.addTarget(self, action: #selector(didTapPausingViewButton), for: .touchUpInside)
        view.addSubview(pauseView)
    }
    
    @objc func didTapPausingViewButton(button: UIButton){
        UIView.animate(withDuration: 0.3, animations: {
            let frame = CGRect(x: self.view.bounds.width/2, y: 5 * self.view.bounds.height/6 - 30, width: 0, height: 0)
            self.pauseView.frame = frame
            self.pauseView.layoutIfNeeded()
        }) { (done) in
            if button.tag == 0{
                UIView.animate(withDuration: 0.3, animations: {
                    self.pauseButton.frame = CGRect(x: self.view.bounds.width/2 - 45, y: self.view.frame.height - 100, width: 90, height: 90)
                })
            }else{
                self.dismiss(animated: true) {
                    print("Stop Recording")
                }
            }
        }
    }
    
    @objc func didTapPauseButton(){
        UIView.animate(withDuration: 0.3, animations: {
            self.pauseButton.frame = CGRect(x: self.view.bounds.width/2, y: 5 * self.view.bounds.height/6 - 30, width: 0, height: 0)
            self.view.layoutIfNeeded()
        }) { (done) in
            print("Pause Recording")
            UIView.animate(withDuration: 0.3, animations: {
                self.pauseView.frame = CGRect(x: 0, y: 2 * self.view.bounds.height/3, width: self.view.bounds.width, height: self.view.bounds.height/3)
                self.pauseView.layoutIfNeeded()
            })
        }
    }
}

struct chartLegends {
    let maxHRlegendEntry = LegendEntry(label: "Max HR:", form: Legend.Form.default, formSize: 8, formLineWidth: 5, formLineDashPhase: 1, formLineDashLengths: [1,2], formColor: .red)
    let durationLegend = LegendEntry(label: "Duration:", form: Legend.Form.default, formSize: 8, formLineWidth: 5, formLineDashPhase: 1, formLineDashLengths: [1,2], formColor: .red)
    let hRlegendEntry = LegendEntry(label: "", form: Legend.Form.none, formSize: 5, formLineWidth: 5, formLineDashPhase: 1, formLineDashLengths: [1,2], formColor: .red)
}
