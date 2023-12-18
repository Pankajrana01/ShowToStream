//
//  BaseAlertViewController.swift
//  KarGoCustomer
//
//  Created by Applify on 23/07/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class BaseAlertViewController: BaseViewController {
    
    enum AlertState {
        case collapsed
        case expanded
    }
    var nextState: AlertState = .collapsed
    // Empty property animator array
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0

    private lazy var backgroundView: UIView = UIView(frame: self.view.bounds)
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var panHandlerView: UIView!

    var dismissCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .overFullScreen

        //containerView?.roundCorners(corners: [.topLeft, .topRight],
                                  //  radius: 10.0)
        backgroundView.backgroundColor = .appAlertOpacity
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(self.handleTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(handlePan(recognizer:)))
        tapGestureRecognizer.require(toFail: panGestureRecognizer)
        
        panHandlerView.addGestureRecognizer(panGestureRecognizer)
        panHandlerView.addGestureRecognizer(tapGestureRecognizer)

    }
    
    @IBAction func dismissButtonTapped(_ sender: Any?) {
        dismiss()
    }
    
    class func show(over host: UIViewController) {
        let controller = self.getController() as! BaseAlertViewController
        controller.show(over: host)
    }
    
    func show(over host: UIViewController) {
        self.loadViewIfNeeded()
        self.backgroundView.alpha = 0
        var parentView = host.view
        if let navVc = host.navigationController {
            parentView = navVc.view
        }
        
        parentView?.addSubview(backgroundView)
        
        host.present(self, animated: true, completion: nil)
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.backgroundView.alpha = 1.0
        }, completion: { _ in
            
        })
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.backgroundView.alpha = 0
                        self.view.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.size.height), size: self.view.frame.size)
        }, completion: { _ in
            self.backgroundView.removeFromSuperview()
            self.dismiss(animated: false, completion: nil)
            if let dismissCompletion = self.dismissCompletion {
                dismissCompletion()
            }
        })
    }
    
}

extension BaseAlertViewController {
    @objc
    func handleTap(recognzier:UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }

    @objc
    func handlePan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // Start animation if pan begins
            startInteractiveTransition(state: nextState, duration: 0.9)
            
        case .changed:
            // Update the translation according to the percentage completed
            let translation = recognizer.translation(in: panHandlerView)
            let fractionComplete = translation.y / self.view.frame.height
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            // End animation when pan ends
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    // Animate transistion function
    func animateTransitionIfNeeded (state: AlertState, duration:TimeInterval) {
        // Check if frame animator is empty
        if runningAnimations.isEmpty {
            // Create a UIViewPropertyAnimator depending on the state of the popover view
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    // If expanding set popover y to the ending height and blur background
                    self.view.frame.origin.y = 0
                    self.backgroundView.alpha = 1
                case .collapsed:
                    // If collapsed set popover y to the starting height and remove background blur
                    self.view.frame.origin.y = self.view.frame.height
                    self.backgroundView.alpha = 0
                }
            }
            
            // Complete animation frame
            frameAnimator.addCompletion { _ in
                self.dismiss()
                self.runningAnimations.removeAll()
            }
            
            // Start animation
            frameAnimator.startAnimation()
            
            // Append animation to running animations
            runningAnimations.append(frameAnimator)
        }
    }
    
    // Function to start interactive animations when view is dragged
    func startInteractiveTransition(state:AlertState, duration:TimeInterval) {
        
        // If animation is empty start new animation
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        
        // For each animation in runningAnimations
        for animator in runningAnimations {
            // Pause animation and update the progress to the fraction complete percentage
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    // Funtion to update transition when view is dragged
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        // For each animation in runningAnimations
        for animator in runningAnimations {
            // Update the fraction complete value to the current progress
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    // Function to continue an interactive transisiton
    func continueInteractiveTransition (){
        // For each animation in runningAnimations
        for animator in runningAnimations {
            // Continue the animation forwards or backwards
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            delay(0.2) {
                self.dismiss()
            }
        }
    }

}
