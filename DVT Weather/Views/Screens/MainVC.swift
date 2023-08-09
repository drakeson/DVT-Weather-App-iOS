//
//  MainVC.swift
//  DVT Weather
//
//  Created by Kato Drake Smith on 03/08/2023.
//

import UIKit

class MainVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "cloudyColor")
        let initialViewController = HomeVC()
        self.viewControllers = [initialViewController]
    }
    

}
