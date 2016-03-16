//
//  ContainerViewController.swift
//  Slide Menu
//
//  Created by Patrick Hansen on 3/14/16.
//  Copyright © 2016 Neal and Pat. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, UIGestureRecognizerDelegate {

    var mainViewController: MainViewController!
    var menuViewController: MenuViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("MainViewController") as? MainViewController
        //mainViewController.delegate = self
        
        self.view.addSubview(mainViewController.view)
        
        let panGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "panning:")
        panGestureRecognizer.edges = .Left
        mainViewController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    
    func panning(recognizer: UIPanGestureRecognizer) {
        print("x vel: \(recognizer.velocityInView(self.view).x) y vel: \(recognizer.velocityInView(self.view).y)")
    }
    
    
    

}
