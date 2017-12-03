//
//  TrainHistoryTableCell.swift
//  MyWorkout
//
//  Created by Lu Ao on 11/30/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//

import UIKit

class TrainHistoryTableCell: UITableViewCell {

    @IBOutlet weak var trainTypeImage: UIImageView!
    @IBOutlet weak var trainTypeName: UILabel!
    @IBOutlet weak var HRAverage: UILabel!
    @IBOutlet weak var trainDuration: UILabel!
    @IBOutlet weak var trainDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    func initialize(trainTypeName:String = "BasketBall",HRAverage:String = "150",trainDate:String = "11/29/2017",trainDuration:String = "2:00:00"){
        self.trainTypeName.text = trainTypeName
        self.trainTypeName.textColor = UIColor.white
        self.HRAverage.text = HRAverage
        self.HRAverage.textColor = UIColor.white
        self.trainDate.text = trainDate
        self.trainDate.textColor = UIColor.white
        self.trainDuration.text = trainDuration
        self.trainDuration.textColor = UIColor.white
        self.backgroundColor = UIColor.black
        self.trainTypeImage.backgroundColor = UIColor.red
        self.selectionStyle = .none
    }
    
}
