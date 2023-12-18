//
//  VideoPlayerManager+BaseViewControllerSwizzling.swift
//  ShowToStream
//
//  Created by 1312 on 21/12/20.
//

import UIKit

private let swizzling: (AnyClass, Selector, Selector) -> () = { forClass, originalSelector, swizzledSelector in
    guard
        let originalMethod = class_getInstanceMethod(forClass, originalSelector),
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
    else { return }
    method_exchangeImplementations(originalMethod, swizzledMethod)
}

extension BaseViewController {
    static let classInit: Void = {
        let originalSelector = #selector(viewWillDisappear(_:))
        let swizzledSelector = #selector(swizzled_viewWillDisappear(_:))
        
        swizzling(BaseViewController.self, originalSelector, swizzledSelector)
    }()
    
    @objc func swizzled_viewWillDisappear(_ animated: Bool) {
        // not able to call the original method in the correct way,
        // so swizzling back the original method,
        // calling it,
        // and then swizzling again.
        let originalSelector = #selector(viewWillDisappear(_:))
        let swizzledSelector = #selector(swizzled_viewWillDisappear(_:))
        swizzling(BaseViewController.self, swizzledSelector, originalSelector)
        self.viewWillDisappear(animated)
        swizzling(BaseViewController.self, originalSelector, swizzledSelector)
        // ------------------------------------------------------------------------
        
        VideoPlayerManager.shared.checkStateOfVideoPlayer(in: self)
        
        VideoPlayerManager.shared.autoPauseTrailer(in: self)
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        NSObject.cancelPreviousPerformRequests(withTarget: self.getViewModel())
        print("swizzled_viewWillDisappear")
    }
}
