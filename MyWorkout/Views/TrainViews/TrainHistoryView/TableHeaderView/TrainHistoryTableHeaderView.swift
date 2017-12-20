//
//  TrainHistoryTableHeaderView.swift
//  MyWorkout
//
//  Created by Lu Ao on 12/1/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//

import UIKit
@IBDesignable
class TrainHistoryTableHeaderView: UIView {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet var contentView: UIView!
    
    
    var label: String{
        get{
            return headerLabel.text!
        }
        set{
            headerLabel.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    func initView(){
        let nib = UINib(nibName: "TrainHistoryTableHeaderView", bundle: Bundle(for: type(of: self)))
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        contentView.backgroundColor = .darkGray
        self.layer.cornerRadius = 0.1 * self.frame.height
        self.layer.shadowColor = UIColor.blue.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize.zero
        headerLabel.textColor = UIColor.blue
        self.addSubview(contentView)
    }
}
