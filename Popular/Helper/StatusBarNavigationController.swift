//
//  StatusBarNavigationController.swift
//  Popular
//
//  Created by Mahmood Tahir on 2019-03-02.
//  Copyright © 2019 Mahmood Tahir. All rights reserved.
//

import UIKit

/// This class overrides the default behavior of always showing black status bar for the navigation controller. Instead it uses the visible view controller's preferred status bar style
class StatusBarNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let visible = visibleViewController {
            return visible.preferredStatusBarStyle
        }
        return .default
    }
    override var prefersStatusBarHidden: Bool {
        return isNavigationBarHidden
    }
}
