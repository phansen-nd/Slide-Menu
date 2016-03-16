//
//  ContainerViewController.swift
//  Slide Menu
//
//  Created by Patrick Hansen on 3/14/16.
//  Copyright © 2016 Neal and Pat. All rights reserved.
//

import UIKit

enum MenuState {
    case Collapsed
    case Expanded
}

class ContainerViewController: UIViewController, UIGestureRecognizerDelegate, MainViewControllerDelegate {

    var mainViewController: MainViewController!
    var menuViewController: MenuViewController?
    
    var currentState: MenuState = .Collapsed
    
    let menuOffset: CGFloat = 240
    var centerBound: CGFloat = 0
    var originalCenter: CGFloat = 0
    var panMenuBackGestureRecognizer1: UIPanGestureRecognizer?
    var panMenuBackGestureRecognizer2: UIPanGestureRecognizer?
    var animationComplete = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("MainViewController") as? MainViewController
        mainViewController.delegate = self
        
        self.view.addSubview(mainViewController.view)
        
        
        let edgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "edgePanning:")
        edgePanGestureRecognizer.edges = .Left
        mainViewController.view.addGestureRecognizer(edgePanGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "touched:")
        tapGestureRecognizer.numberOfTapsRequired = 1
        mainViewController.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //
    // MARK: Gesture Recognizers
    //
    
    func edgePanning(recognizer: UIScreenEdgePanGestureRecognizer) {
        switch (recognizer.state) {
        case .Began:
            if currentState == .Collapsed {
                createMenu()
            }
        case .Changed:
            // Show the shadow
            self.menuViewController!.view.layer.shadowRadius = 10
            // Update the menu's x location
            let newCenterX = menuViewController!.view.center.x + recognizer.translationInView(view).x
            if (newCenterX <= self.centerBound) {
                menuViewController!.view.center.x = newCenterX
            }
            
            recognizer.setTranslation(CGPointZero, inView: view)
            
        case .Ended:
            let toExpand = (recognizer.velocityInView(self.view).x < 0)
            animateMenu(toExpand)
        default:
            break
        }
        
    }
    
    func touched(recognizer: UITapGestureRecognizer) {
        if currentState == .Expanded {
            toggleMenu()
        }
    }
    
    func backPanning (recognizer: UIPanGestureRecognizer) {
        
        if currentState == .Expanded {
            switch (recognizer.state) {
            case .Changed:
                // Update the menu's x location
                let newCenterX = menuViewController!.view.center.x + recognizer.translationInView(view).x
                if (newCenterX <= self.centerBound) {
                    menuViewController!.view.center.x = newCenterX
                }
                
                recognizer.setTranslation(CGPointZero, inView: view)
                
            case .Ended:
                let toExpand = (recognizer.velocityInView(self.view).x < 0)
                animateMenu(toExpand)
            default:
                break
            }
        }
    }
    
    //
    // MARK: Menu delegate functions
    //
    
    
    func toggleMenu() {
        let isExpanded = (currentState == .Expanded)
        
        if (!isExpanded) {
            // Create menu
            createMenu()
        }
        // Show the shadow
        self.menuViewController!.view.layer.shadowRadius = 10
        
        animateMenu(isExpanded)
    }
    
    func animateMenu(isExpanded: Bool) {
        
        // Don't allow double animations
        if animationComplete {
            animationComplete = false
            if !isExpanded {
                
                // Animate the menu out
                UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .CurveEaseIn, animations: {
                        self.menuViewController!.view.center.x = self.centerBound
                    }, completion: {
                        (value: Bool) in
                        
                        // Update the menu state
                        self.currentState = .Expanded
                        
                        // Add gesture to allow panning back
                        self.panMenuBackGestureRecognizer2 = UIPanGestureRecognizer(target: self, action: "backPanning:")
                        self.mainViewController.view.addGestureRecognizer(self.panMenuBackGestureRecognizer2!)
                        
                        // Allow animation to continue
                        self.animationComplete = true
                })
            } else {
                
                // Update the menu state
                self.currentState = .Collapsed
                
                // Animate the menu in
                UIView.animateWithDuration(0.6, delay: 0.0, options: .CurveEaseIn, animations: {
                        self.menuViewController!.view.center.x = self.originalCenter
                    }, completion: {
                        (value: Bool) in
                        
                        // Hide the generic pan on main VC
                        if (self.panMenuBackGestureRecognizer2 != nil) {
                            self.mainViewController.view.removeGestureRecognizer(self.panMenuBackGestureRecognizer2!)
                        }
                        
                        // Allow animation to continue
                        self.animationComplete = true
                        
                        // Hide the shadow
                        self.menuViewController!.view.layer.shadowRadius = 0
                        
                        // Kill the menu
                        //self.menuViewController!.view.removeFromSuperview()
                        //self.menuViewController = nil
                    })
                
            }
        }
    }
    
    func createMenu() {
        if menuViewController == nil {
            menuViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("MenuViewController") as? MenuViewController
            
            view.insertSubview(menuViewController!.view, aboveSubview: mainViewController.view)
            addChildViewController(menuViewController!)
            menuViewController!.didMoveToParentViewController(self)
            
            menuViewController!.view.layer.shadowColor = UIColor.blackColor().CGColor
            menuViewController!.view.layer.shadowOpacity = 1
            menuViewController!.view.layer.shadowOffset = CGSizeZero
            menuViewController!.view.layer.shadowRadius = 10
            
            // Set menu's initial frame
            menuViewController!.view.frame = CGRectMake(-1*UIScreen.mainScreen().bounds.width - 10, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
            
            // Set constants
            self.centerBound = menuViewController!.view.center.x + self.menuOffset
            self.originalCenter = menuViewController!.view.center.x
            
            // Add pan gesture recognizer
            panMenuBackGestureRecognizer1 = UIPanGestureRecognizer(target: self, action: "backPanning:")
            menuViewController!.view.addGestureRecognizer(panMenuBackGestureRecognizer1!)
            
            // Set delegate to main
            menuViewController!.delegate = mainViewController
        }
    }
    

}
