//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Giorgi Shavgulidze on 13/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    fileprivate var keyboard: Keyboard!
    var keyboardView: KeyboardView!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        initialise()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
//        initialise()
    }
    
    func initialise() {
        
        
        print("Init called")
        
        KeyboardState.reset()
        KeyboardInputActionPool.configure(delegate: self)
        
        keyboard = DefaultKeyboard.iPhone6()
        
        keyboardView = KeyboardView(model: keyboard)
        view.addSubview(keyboardView)
        keyboardView.backgroundColor = UIColor.clear
        
        KeyboardState.sharedInstance.activeLanguage = nil
        KeyboardState.sharedInstance.padState = .alphabet
        KeyboardState.sharedInstance.shiftState = .disabled
        KeyboardState.sharedInstance.shiftNumbersState = .disabled
        KeyboardState.sharedInstance.orientation = .portrait
        
//        if let keyboard = DefaultKeyboard.get() {
//            
//        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialise()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateRotation(forSize: view.frame.size)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
    }
    
    
    // MARK: - Rotation
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        print("Rotated")
        
        let frameBeforeRotation = self.keyboardView.frame
        
        let snapshotBeforeRotation = self.keyboardView.snapshot()
        var snapshotAfterRotation: UIImageView!
        
        self.updateRotation(forSize: size)
        
        coordinator.animate(alongsideTransition: { (context) in
            
            UIView.setAnimationsEnabled(false)
            
            let frameAfterRotation = self.keyboardView.frame
            
            snapshotAfterRotation = self.keyboardView.snapshot()
            snapshotAfterRotation.setFramePreservingHeight(frameBeforeRotation)
            
            var imageBeforeRotation = snapshotBeforeRotation.image!
            var imageAfterRotation = snapshotAfterRotation.image!
            
            imageBeforeRotation = imageBeforeRotation.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
            imageAfterRotation = imageAfterRotation.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
            
            snapshotBeforeRotation.image = imageBeforeRotation
            snapshotAfterRotation.image = imageAfterRotation
            
            UIView.setAnimationsEnabled(true)
            
            snapshotAfterRotation.alpha = 0
            
            self.view.insertSubview(snapshotAfterRotation, aboveSubview: snapshotBeforeRotation)
            
            snapshotAfterRotation.alpha = 1
            
            /*
            if imageAfterRotation.size.height < imageBeforeRotation.size.height {
                snapshotAfterRotation.alpha = 0
                
                self.view.insertSubview(snapshotAfterRotation, aboveSubview: snapshotBeforeRotation)
                
                snapshotAfterRotation.alpha = 1
            } else {
                snapshotBeforeRotation.alpha = 1
                
                self.view.insertSubview(snapshotAfterRotation, belowSubview: snapshotBeforeRotation)
                
                snapshotBeforeRotation.alpha = 0
            }*/
            
            snapshotAfterRotation.frame = frameAfterRotation
            snapshotBeforeRotation.setFramePreservingHeight(frameAfterRotation)
            
            self.keyboardView.isHidden = true
        }) { (context) in
            snapshotBeforeRotation.removeFromSuperview()
            snapshotAfterRotation.removeFromSuperview()
            
            self.keyboardView.isHidden = false
        }
    }
    
    
    private func updateRotation(forSize size: CGSize) {
        guard let info = KeyboardState.sharedInstance.info else {
            return
        }
        if size.width == info[.portrait]!.width.cgf {
            KeyboardState.sharedInstance.orientation = .portrait
        } else {
            KeyboardState.sharedInstance.orientation = .landscape
        }
    }
}
