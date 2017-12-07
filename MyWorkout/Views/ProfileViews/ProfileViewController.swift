//
//  ProfileViewController.swift
//  MyWorkout
//
//  Created by Lu Ao on 12/4/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    required init?(coder aDecoder: NSCoder) {
        //TODO: Do it with NSCoder
        super.init(nibName: "ProfileViewController", bundle: nil)
    }
    
    override init(nibName: String? , bundle: Bundle?) {
        super.init(nibName: "ProfileViewController", bundle: nil)
    }

}
