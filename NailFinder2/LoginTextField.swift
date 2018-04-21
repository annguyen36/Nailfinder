//
//  LoginTextField.swift
//  NailFinder2
//
//  Created by An Nguyen on 4/21/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//

import UIKit

class LoginTextField: UITextField {

        override func layoutSubviews() {
            super.layoutSubviews()
            self.layer.borderColor = UIColor(white: 231 / 255, alpha: 1).cgColor
            self.layer.borderWidth  = 1
        }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8, dy: 7)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

}
