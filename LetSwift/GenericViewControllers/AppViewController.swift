//
//  AppViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 24.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

class AppViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        if let titleKey = viewControllerTitleKey() {
            title = localized(titleKey).uppercased()
        }
        
        navigationController?.navigationBar.setValue(shouldHideShadow(), forKey: "hidesShadow")
        navigationController?.navigationBar.barTintColor = .white
        
        if let navTitle = navigationItem.title {
            navigationItem.titleView = setupTitleLabel(withTitle: navTitle)
        }
        
        if shouldShowUserIcon() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "UserIcon"), style: .plain, target: self, action: nil)
            navigationItem.rightBarButtonItem?.tintColor = .black
        }
    }
    
    private func setupTitleLabel(withTitle title: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString(string: title, attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightSemibold),
            NSForegroundColorAttributeName: UIColor.highlightedBlack,
            NSKernAttributeName: 1.0
        ])
        titleLabel.sizeToFit()
        
        return titleLabel
    }
    
    func viewControllerTitleKey() -> String? {
        return nil
    }
    
    func shouldShowUserIcon() -> Bool {
        return false
    }
    
    func shouldHideShadow() -> Bool {
        return false
    }
}
