//
//  UIViewController.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func endEditing(_ force: Bool) {
        self.view.endEditing(force)
    }
    
    func showAlert(with title: String? = nil,
                   message: String,
                   style: UIAlertController.Style = .alert,
                   options: String...,
        completion: @escaping (Int) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for (index, option) in options.enumerated() {
            alert.addAction(UIAlertAction(title: option, style: .default, handler: { action in
                completion(index)
            }))
        }
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: Any?) {
        if let navVC = self.navigationController,
           navVC.viewControllers.count > 1 {
            navVC.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
   
}
