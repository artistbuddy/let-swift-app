//
//  TappableView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 15.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class TappableView: UIView {
    
    @IBInspectable var selectionColor: UIColor = .lightBlueGrey
    
    private var originalBackground: UIColor!
    private var isTouchDown = false
    
    private weak var target: AnyObject?
    private var action: Selector?
    
    func addTarget(_ target: Any?, action: Selector) {
        self.target = target as AnyObject
        self.action = action
    }
    
    private func releaseTouch() -> Bool {
        if isTouchDown {
            isTouchDown = false
            backgroundColor = originalBackground
            
            return true
        } else {
            return false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchDown = true
        originalBackground = backgroundColor
        backgroundColor = selectionColor
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if releaseTouch() {
            _ = target?.perform(action)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = releaseTouch()
    }
}
