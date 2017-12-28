//
//  TrainRecordingPausingView.swift
//  MyWorkout
//
//  Created by Lu Ao on 12/27/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//

import UIKit

class TrainRecordingPausingView: UIView {
    
    var continueButton: UIButton!
    var endButton: UIButton!
    var titleLabel: UILabel!
    var continueLabel: UILabel!
    var pauseLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(frame: CGRect){
        
        let width = frame.width/20
        
        continueButton = UIButton(frame: CGRect(x: frame.width/4 - width/2, y: frame.height/2 - width, width: width, height: width))
        endButton = UIButton(frame: CGRect(x: 3 * frame.width/4 - width/2, y: frame.height/2 - width, width: width, height: width))
        titleLabel = UILabel(frame: CGRect(x: frame.width/4 - width/2, y: frame.height/2 - width, width: width, height: width))
        continueLabel = UILabel(frame: CGRect(x: frame.width/4 - width/2, y: frame.height/2 - width, width: width, height: width))
        pauseLabel = UILabel(frame: CGRect(x: frame.width/4 - width/2, y: frame.height/2 - width, width: width, height: width))
        
        endButton.backgroundColor = .white

        
        
        let trianglePath = UIBezierPath()
        let triangleLayer = CAShapeLayer()
        //change the CGPoint values to get the triangle of the shape you want
        trianglePath.move(to: CGPoint(x: 0, y: 0))
        trianglePath.addLine(to: CGPoint(x: width, y: width/2))
        trianglePath.addLine(to: CGPoint(x: 0, y: width))
        trianglePath.addLine(to: CGPoint(x: 0, y: 0))
        triangleLayer.path = trianglePath.cgPath
        triangleLayer.fillColor = UIColor.white.cgColor
        continueButton.layer.addSublayer(triangleLayer)
        
        
        titleLabel.text = "TRAINING PAUSED"
        titleLabel.font = titleLabel.font.withSize(3 * width/2)
        titleLabel.sizeToFit()
        titleLabel.center.x = frame.width/2
        titleLabel.center.y = 2 * width
        titleLabel.textColor = .white
        
        
        continueLabel.text = "CONTINUE"
        continueLabel.font = UIFont(name: "Halvetica", size: width)
        continueLabel.sizeToFit()
        continueLabel.center.x = continueButton.center.x
        continueLabel.center.y = continueButton.center.y + 5 * width/2
        continueLabel.textColor = .white
        
        pauseLabel.text = "STOP"
        pauseLabel.font = UIFont(name: "Halvetica", size: width)
        pauseLabel.sizeToFit()
        pauseLabel.center.x = endButton.center.x
        pauseLabel.center.y = endButton.center.y + 5 * width/2
        pauseLabel.textColor = .white
        
        continueButton.tag = 0
        endButton.tag = 1
        backgroundColor = .red
        addSubview(continueButton)
        addSubview(endButton)
        addSubview(titleLabel)
        addSubview(continueLabel)
        addSubview(pauseLabel)
        
    }
}
