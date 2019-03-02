//
//  ViewController.swift
//  Popular
//
//  Created by Mahmood Tahir on 2019-03-02.
//  Copyright © 2019 Mahmood Tahir. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    fileprivate let api = API()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadMorePhotos()
    }


}

extension ViewController {
    fileprivate func loadMorePhotos() {
        api.popularPhotos(page: 1) { (result) in
            switch result {
            case .success(let response):
                print("photos page \(response.currentPage) loaded with \(response.photos.count) photos")
            case .error(let error):
                print("error loading \(error)")
            }
        }
    }
}

