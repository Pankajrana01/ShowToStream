//
//  ShowToStreamTextField.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 17/12/20.
//

import MaterialComponents
import UIKit

class ShowToStreamTextField: MDCTextField {
    override var rightAccessoryViewTopPadding: CGFloat {
        return 0
    }

    private var controller: TextInputControllerOutlined!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureDefaultSettings()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureDefaultSettings()
    }
    
    fileprivate func configureDefaultSettings() {
        controller = TextInputControllerOutlined(textInput: self)
        self.textColor = .white
        controller.inlinePlaceholderFont = UIFont.appRegularFont(with: 14)
        self.clearButtonMode = .never
        controller.normalColor = .appLightBlack
        controller.activeColor = .appLightBlack
        controller.disabledColor = .appLightBlack
        controller.floatingPlaceholderActiveColor = .appGray
        controller.floatingPlaceholderNormalColor = .appGray
        controller.inlinePlaceholderColor = .appPlaceholder
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        let becomeResponder = super.becomeFirstResponder()
        if becomeResponder {
            controller.activeColor = .appVoilet
            
        } else {
            controller.activeColor = .appGray
        }
        return becomeResponder
    }
    
}

class TextInputControllerOutlined: MDCTextInputControllerOutlined {
    override func leadingViewRect(forBounds bounds: CGRect, defaultRect: CGRect) -> CGRect {
        var rect = super.leadingViewRect(forBounds: bounds, defaultRect: defaultRect)
        if let tf = self.textInput as? ShowToStreamTextField {
            rect.origin.y += tf.isEditing || !(tf.text?.isEmpty ?? true) ? 4.5 : 0
        }
        return rect
    }
    
    override func leadingViewTrailingPaddingConstant() -> CGFloat {
        return 0
    }
}
