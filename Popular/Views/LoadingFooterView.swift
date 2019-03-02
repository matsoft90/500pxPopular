//
//  LoadingFooterView.swift
//  Popular
//
//  Created by Mahmood Tahir on 2019-03-02.
//  Copyright © 2019 Mahmood Tahir. All rights reserved.
//

import UIKit

class LoadingFooterView: UICollectionReusableView {
    static var identifier: String {
        return "LoadingFooter"
    }
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
}
