//
//  MainViewController.swift
//  Slide Menu
//
//  Created by Patrick Hansen on 3/14/16.
//  Copyright © 2016 Neal and Pat. All rights reserved.
//

import UIKit

protocol MainViewControllerDelegate {
    func toggleMenu()
    func animateMenu(isExpanded: Bool)
    func createMenu()
}

class MainViewController: UIViewController {

    var delegate: MainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func menuButtonTouched(sender: AnyObject) {
    
        delegate?.toggleMenu()
    
    }

}
