//
//  UIView.swift
//  NPWallet
//
//  Created by Pankaj Rana on 24/02/22.
//

import UIKit
extension UIView {
    private struct AssociatedKey {
        static var rounded = "UIView.rounded"
    }

    func setOpacity(to opacity: Float) {
            self.layer.opacity = opacity
        }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layoutIfNeeded()
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var rounded: Bool {
        get {
            if let rounded = objc_getAssociatedObject(self, &AssociatedKey.rounded) as? Bool {
                return rounded
            } else {
                return false
            }
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKey.rounded,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            layer.cornerRadius = CGFloat(newValue ? 1.0: 0.0) * min(bounds.width, bounds.height) / 2
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        self.layoutIfNeeded()
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addShadow(offset: CGSize,
                   color: UIColor?,
                   radius: CGFloat,
                   opacity: Float = 1) {
        self.layoutIfNeeded()
        self.layer.shadowColor = color?.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                             cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }

}

extension UIView {
    func drawVerticalDottedLine(_ color: UIColor) {
        let existingLayer = self.layer.sublayers?.first(where: { layer -> Bool in
            layer.accessibilityValue == "myDottedLine"
        })
        existingLayer?.removeFromSuperlayer()
        
        let p0: CGPoint = CGPoint(x: 0, y: 0)
        let p1: CGPoint = CGPoint(x: 0, y: self.bounds.height)
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.accessibilityValue = "myDottedLine"
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [2, 2]
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
}

extension UIView {
    
    func startRotating(aCircleTime: Double = 2) { //CABasicAnimation
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Double.pi * 2
            rotationAnimation.duration = aCircleTime
            rotationAnimation.repeatCount = .infinity
            self.layer.add(rotationAnimation, forKey: nil)
    }
    func stopRotating() {
        
        self.layer.removeAnimation(forKey: "rotationAnimation")
        
    }
}
extension UIView {
    func makeSecure() {
        DispatchQueue.main.async {
            let field = UITextField()
            field.isSecureTextEntry = true
            self.addSubview(field)
            field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            self.layer.superlayer?.addSublayer(field.layer)
            field.layer.sublayers?.first?.addSublayer(self.layer)
        }
    }
}
