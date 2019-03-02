//
//  ImageCell.swift
//  Popular
//
//  Created by Mahmood Tahir on 2019-03-02.
//  Copyright © 2019 Mahmood Tahir. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    static var cellIdentifier: String {
        return "ImageCell"
    }
    // The url of the image
    var imageUrl: URL? {
        didSet {
            loadImage()
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var loadingTask: URLSessionTask?
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageUrl = nil
        activityIndicator.stopAnimating()
        loadingTask?.cancel()
        loadingTask = nil
    }
    
    deinit {
        
    }
    fileprivate func loadImage() {
        guard let url = imageUrl else {
            imageView.image = nil
            return
        }
        activityIndicator.startAnimating()
        loadingTask = UIImage.asyncFrom(url: url) {[weak self] (result) in
            self?.loadingTask = nil
            self?.activityIndicator.stopAnimating()
            switch result {
            case .success(let image):
                // check if cell was reused
                self?.imageView.image = image
            case .error(let error):
                print("error loading image \(error)")
                self?.imageView.image = nil
            }
        }
    }
}
