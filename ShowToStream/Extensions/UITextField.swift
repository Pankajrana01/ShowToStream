//
//  UITextField.swift
//  KarGoRider
//
//  Created by Dev on 31/07/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension UITextField {
    @objc
    var leftAccessoryViewTopPadding: CGFloat {
        return 0
    }
    
    @objc
    var rightAccessoryViewTopPadding: CGFloat {
        return 0
    }

    @IBInspectable var leftPadding: Int {
        get {
            return Int(self.leftView?.frame.size.width ?? 0.0)
        }
        set {
            if newValue > 0 {
                let paddingView: UIView = UIView(frame: CGRect(x: 0,
                                                               y: 0,
                                                               width: newValue,
                                                               height: Int(self.bounds.size.height)))
                self.leftView = paddingView
                self.leftViewMode = .always
            }
        }
    }
        
    @objc
    func addRightButton(image: UIImage,
                        tintColor: UIColor? = nil,
                        target: Any?,
                        selector: Selector?) {
        let height = self.frame.size.height
        let button = UIButton(frame: CGRect(x: 0,
                                            y: 0,
                                            width: 20,
                                            height: height - 16))
        
        if let selector = selector {
            button.addTarget(target, action: selector, for: .touchUpInside)
            button.isUserInteractionEnabled = true
        } else {
            button.isUserInteractionEnabled = false
        }
        button.contentMode = .right
        self.rightViewMode = .always
        
        button.setImage(image, for: .normal)
        
        if let tintColor = tintColor {
            button.tintColor = tintColor
        }
        
        button.sizeToFit()
        button.frame = CGRect(x: 0, y: 0, width: max(button.frame.size.width, 30) , height: height)
        
        button.contentEdgeInsets = UIEdgeInsets(top: rightAccessoryViewTopPadding, left: 0, bottom: 0, right: 20)
        button.tag = self.tag
        self.rightView = button
    }
    
    @objc
    func addLeftButton(accessories: [Any],
                       target: Any?,
                       selector: Selector?) {
        self.setNeedsDisplay()
        self.setNeedsLayout()
        var text: String?
        var image: UIImage?
        
        let button = UIButton(frame: .zero)
        if let target = target,
            let selector = selector {
            button.addTarget(target, action: selector, for: .touchUpInside)
            button.isUserInteractionEnabled = true
        } else {
            button.isUserInteractionEnabled = false
        }
        button.tintColor = self.textColor ?? .white
        button.titleLabel?.font = self.font
        button.setTitleColor(button.tintColor, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: leftAccessoryViewTopPadding,
                                                left: 10,
                                                bottom: 0,
                                                right: 0)
        self.leftViewMode = .always
        if let first = accessories.first as? String {
            text = first + " "
            if accessories.count > 1 {
                image = accessories[1] as? UIImage
            }
            button.contentHorizontalAlignment = .left
            button.semanticContentAttribute = .forceRightToLeft
        } else if let first = accessories.first as? UIImage {
            image = first
            if accessories.count > 1 {
                text = accessories[1] as? String
            }
        }
        button.setTitle(text, for: .normal)
        button.setImage(image, for: .normal)
        button.sizeToFit()
        self.leftView = button
    }
    
    @objc
    func addNewLeftButton(accessories: [Any],
                       target: Any?,
                       selector: Selector?) {
        self.setNeedsDisplay()
        self.setNeedsLayout()
        var text: String?
        var image: UIImage?
        
        let button = UIButton(frame: .zero)
        if let target = target,
            let selector = selector {
            button.addTarget(target, action: selector, for: .touchUpInside)
            button.isUserInteractionEnabled = true
        } else {
            button.isUserInteractionEnabled = false
        }
        button.tintColor = self.textColor ?? .white
        button.titleLabel?.font = self.font
        button.setTitleColor(button.tintColor, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 12,
                                                left: 10,
                                                bottom: 0,
                                                right: 0)
        self.leftViewMode = .always
        if let first = accessories.first as? String {
            text = first + " "
            if accessories.count > 1 {
                image = accessories[1] as? UIImage
            }
            button.contentHorizontalAlignment = .left
            button.semanticContentAttribute = .forceRightToLeft
        } else if let first = accessories.first as? UIImage {
            image = first
            if accessories.count > 1 {
                text = accessories[1] as? String
            }
        }
        button.setTitle(text, for: .normal)
        button.setImage(image, for: .normal)
        button.sizeToFit()
        self.leftView = button
    }

    @objc
    func addRightButton(accessories: [Any],
                       font: UIFont? = nil,
                       fontColor: UIColor = .black,
                       target: Any? = nil,
                       selector: Selector? = nil) {
        self.setNeedsDisplay()
        self.setNeedsLayout()
        var text: String?
        var image: UIImage?
        
        let button = UIButton(frame: .zero)
        if let target = target,
            let selector = selector {
            button.addTarget(target, action: selector, for: .touchUpInside)
            button.isUserInteractionEnabled = true
        } else {
            button.isUserInteractionEnabled = false
        }
        button.tintColor = .black
        button.titleLabel?.font = font ?? self.font
        
        button.setTitleColor(fontColor, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: rightAccessoryViewTopPadding,
                                                left: -2,
                                                bottom: 0,
                                                right: 0)
        self.rightViewMode = .always
        if let first = accessories.first as? String {
            text = first + " "
            if accessories.count > 1 {
                image = accessories[1] as? UIImage
            }
            button.contentHorizontalAlignment = .left
            button.semanticContentAttribute = .forceRightToLeft
        } else if let first = accessories.first as? UIImage {
            image = first
            if accessories.count > 1 {
                text = accessories[1] as? String
            }
        }
        button.setTitle(text, for: .normal)
        button.setImage(image, for: .normal)
        button.sizeToFit()
        self.rightView = button
    }


}
