//
//  WalkthroughViewController.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class WalkthroughViewController: BaseViewController {

    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.walkthrough
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.walkthrough
    }
    
    override class func show(from viewController: UIViewController,
                             forcePresent: Bool = true) {
        self.getController().show(from: viewController,
                                  forcePresent: forcePresent)
    }
    
    override func show(from viewController: UIViewController,
                       forcePresent: Bool = true) {
        self.modalPresentationStyle = .fullScreen
        if forcePresent {
            viewController.present(self,
                                   animated: false,
                                   completion: nil)
        } else {
            viewController.show(self,
                                sender: nil)
        }
    }
    
    @IBOutlet private var logoImageViews: [UIImageView]!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var firstWalkLabel: UILabel!
    @IBOutlet private weak var tvImageView: UIImageView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var skipButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!

    private var animationDuration: Double = 2
    private var autoScrollTimer: Double = 3

    lazy var viewModel: WalkthroughViewModel = WalkthroughViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isUserInteractionEnabled = false
        tvImageView.transform = CGAffineTransform(scaleX: 4, y: 4)
        tvImageView.alpha = 0
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: .appEnterForeground, object: nil)
        
        self.scrollView.isScrollEnabled = false
        self.pageControl.isHidden = true
        self.pageControl.numberOfPages = 1
        self.skipButton.isHidden = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delay(1) {
            self.performAnimtaion()
        }
        
//        delay(3) {
//            self.perform(#selector(self.nextButtonTapped(_:)), with: nil, afterDelay: self.autoScrollTimer)
//        }
    }
    
    @objc
    private func didBecomeActive() {
        // animations were disturbed, now fix views positions without animation
        animationDuration = 0
        performAnimtaion()
    }
    
    private func performAnimtaion() {
        UIView.animate(withDuration: animationDuration) {
            self.logoImageViews.forEach {
                $0.transform = CGAffineTransform(scaleX: 0.46, y: 0.46)
                $0.center = self.tvImageView.center
            }
            self.tvImageView.transform = .identity
            self.tvImageView.alpha = 1
            self.contentView.alpha = 1
            self.firstWalkLabel.alpha = 1
        } completion: { _ in
            self.scrollView.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any?) {
//        let currentPage = pageControl.currentPage
//        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(nextButtonTapped(_:)), object: nil)
//        if currentPage < 2 {
//            let newOffset = CGPoint(x: (currentPage + 1) * Int(self.scrollView.frame.size.width), y: 0)
//            scrollView.setContentOffset(newOffset, animated: true)
//            if currentPage < 1 {
//                perform(#selector(nextButtonTapped(_:)), with: nil, afterDelay: autoScrollTimer)
//            }
//        } else {
            viewModel.nextButtonTapped()
//        }
    }

    @IBAction func skipButtonTapped(_ sender: Any?) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(nextButtonTapped(_:)), object: nil)
        self.viewModel.skipButtonTapped()
    }
}

extension WalkthroughViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        skipButton.isHidden = pageControl.currentPage == 2
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(nextButtonTapped(_:)), object: nil)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if pageControl.currentPage < 2 {
            perform(#selector(nextButtonTapped(_:)), with: nil, afterDelay: autoScrollTimer)
        }

    }
    
}
