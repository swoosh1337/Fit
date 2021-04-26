//
//  AppScene.swift
//  Fit
//
//  Created by Beka Japaridze on 4/25/21.
//  Copyright © 2021 Beka Japaridze. All rights reserved.
//

import UIKit


class TabBarScene: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .default
        //navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
}
