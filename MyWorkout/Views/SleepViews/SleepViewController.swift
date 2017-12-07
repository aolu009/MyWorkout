//
//  SleepViewController.swift
//  MyWorkout
//
//  Created by Lu Ao on 12/4/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//

import UIKit
import Charts
import ReactiveSwift

class SleepViewController: UIViewController {

    @IBOutlet weak var hRChartView: UIView!
    private var lineChartView: LineChartView!
    private var heartRate = MutableProperty<Double>(0.0)
    private var minHR: Double = 500
    private var date = Date()
    private var xLabel = [String]()
    private let legend = legends()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
    }

    required init?(coder aDecoder: NSCoder) {
        //TODO: Do it with NSCoder
        super.init(nibName: "SleepViewController", bundle: nil)
    }
    
    override init(nibName: String? , bundle: Bundle?) {
        super.init(nibName: "SleepViewController", bundle: nil)
        view.isHidden = false
        initViews()
    }
    
    func initViews(){
        let nib = UINib(nibName: "SleepViewController", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        
        //Setup all attribute in the line chart
        setupLineChartView(frame: hRChartView.bounds, valueLabelName: "HR",extraEntries: [legend.minHRlegendEntry,legend.durationLegend])
        heartRate <~ Bluetooth.manage.heartRateDouble.signal
        heartRate.signal.observeValues { (HR) in
            //if startPressed
            self.updateChart(value: HR)
            
        }
    }
}
private extension SleepViewController{
    //TODO: Add documentation
    func setupLineChartView(frame:CGRect,valueLabelName: String,extraEntries: [LegendEntry] = [],chartDescription: String = "Sleeping Heart Rate",yMin:Double = 50,yMax:Double = 110){
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
        hRChartView.addSubview(lineChartView)
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
        minHR = min(value,minHR)
        lineChartView.legend.extraEntries[0].label = "\(value)"
        lineChartView.legend.extraEntries[1].label = "Min HR: \(self.minHR)"
        lineChartView.legend.extraEntries[2].label = "Duration: \(round(date.timeIntervalSinceNow * -1)) S"
        
        lineChartView.data?.notifyDataChanged()
        lineChartView.notifyDataSetChanged()
        lineChartView.moveViewToX(Double(dataset?.entryCount ?? 0))
    }
}

struct legends {
    let minHRlegendEntry = LegendEntry(label: "Min HR:", form: Legend.Form.default, formSize: 8, formLineWidth: 5, formLineDashPhase: 1, formLineDashLengths: [1,2], formColor: .red)
    let durationLegend = LegendEntry(label: "Duration:", form: Legend.Form.default, formSize: 8, formLineWidth: 5, formLineDashPhase: 1, formLineDashLengths: [1,2], formColor: .red)
    let hRlegendEntry = LegendEntry(label: "", form: Legend.Form.none, formSize: 5, formLineWidth: 5, formLineDashPhase: 1, formLineDashLengths: [1,2], formColor: .red)
}


