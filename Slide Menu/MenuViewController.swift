//
//  MenuViewController.swift
//  Slide Menu
//
//  Created by Patrick Hansen on 3/14/16.
//  Copyright © 2016 Neal and Pat. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate {
    func homeButtonTouched()
    func secondButtonTouched()
}

class MenuViewController: UIViewController {

    var delegate: MenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func secondButton(sender: AnyObject) {
        delegate?.secondButtonTouched()
    }
    
    @IBAction func homeButton(sender: AnyObject) {
        delegate?.homeButtonTouched()
    }
    
}
