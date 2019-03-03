//
//  ImageViewController.swift
//  Popular
//
//  Created by Mahmood Tahir on 2019-03-02.
//  Copyright © 2019 Mahmood Tahir. All rights reserved.
//

import UIKit

class ImageInformationView: UIView {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var imageTitleLabel: UILabel!
    @IBOutlet weak var imageDetailsTextView: UITextView!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var takenOnLabel: UILabel!
    @IBOutlet weak var uploadedOnLabel: UILabel!
    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var isoLabel: UILabel!

}

class ImageViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var informationView: ImageInformationView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Public
    var pageIndex: Int?
    var photo: Photo?
    var image: UIImage?
    var zoomable = true {
        didSet {
            update()
        }
    }
    
    var interactor:Interactor? = nil
    fileprivate var loadingTask: URLSessionDataTask?
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleGesture(_ sender: UIPanGestureRecognizer) {
        let percentThreshold:CGFloat = 0.3
        
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = max(verticalMovement, 0)
        let downwardMovementPercent = min(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        guard let interactor = interactor else { return }
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImage()
        // add pan gesture recognizer
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(pan)
        
        // add tap gesture recognizer to show and hide information
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        view.addGestureRecognizer(tap)
        
        // add double tap recognizer for zoom
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(_:)))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        // hide the information
        informationView.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        super.viewWillAppear(animated)
    }
    
    fileprivate func loadImage() {
        // load the details
        informationView.userNameLabel.text = photo?.user.fullName
        informationView.imageTitleLabel.text = photo?.name
        informationView.likesCountLabel.text = "\(photo?.votesCount ?? 0)"
        informationView.commentsCountLabel.text = "\(photo?.commentsCount ?? 0)"
        if let taken = photo?.takenAt {
            informationView.takenOnLabel.text = DateFormatter.localizedString(from: taken, dateStyle: .medium, timeStyle: .short)
        } else {
            informationView.takenOnLabel.superview?.isHidden = true
        }
        if let uploaded = photo?.createdAt {
            informationView.uploadedOnLabel.text = DateFormatter.localizedString(from: uploaded, dateStyle: .medium, timeStyle: .short)
        } else {
            informationView.uploadedOnLabel.superview?.isHidden = true
        }
        if let camera = photo?.camera {
            informationView.cameraLabel.text = camera
        } else {
            informationView.cameraLabel.superview?.isHidden = true
        }
        if let iso = photo?.iso {
            informationView.isoLabel.text = iso
        } else {
            informationView.isoLabel.superview?.isHidden = true
        }
        if let desc = photo?.description, let data = desc.data(using: .utf8), let attributed = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            // description is html
            let mutable = NSMutableAttributedString(attributedString: attributed)
            mutable.addAttributes([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 14)], range: NSRange(location: 0, length: mutable.length))
            informationView.imageDetailsTextView.attributedText = mutable
        } else {
            informationView.imageDetailsTextView.text = photo?.description
        }
        // load profile image
        if let profileImage = photo?.user.avatars?.small {
            UIImage.asyncFrom(url: profileImage.url) {[weak self] (result) in
                if let sself = self {
                    switch result {
                    case .success(let downloadedImage):
                        sself.informationView.profileImageView.image = downloadedImage
                    case .error(let error):
                        sself.informationView.profileImageView.image = nil
                        print("error loading image \(error)")
                    }
                }
            }
        }
        // load the image
        imageView.image = nil
        if let photo = photo, let index = photo.images.lastIndex(where: {$0.size == Image.Size.longestEdge2048}) {
            let image = photo.images[index]
            activityIndicator.startAnimating()
            self.loadingTask = UIImage.asyncFrom(url: image.httpsUrl) {[weak self] (result) in
                if let sself = self {
                    sself.activityIndicator.stopAnimating()
                    switch result {
                    case .success(let downloadedImage):
                        sself.imageView.image = downloadedImage
                    case .error(let error):
                        sself.imageView.image = nil
                        print("error loading image \(error)")
                    }
                    sself.view.layoutIfNeeded()
                    sself.update()
                    sself.loadingTask = nil
                }
            }
        }
        // set previously loaded image if any
        if let image = image {
            imageView.image = image
            view.layoutIfNeeded()
            update()
        }
    }
    
    func update() {
        updateConstraints(for: view.bounds.size)
        updateMinZoomScale(for: view.bounds.size)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        update()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        update()
    }
    
    deinit {
        loadingTask?.cancel()
        loadingTask = nil
    }
}

extension ImageViewController {
    @objc fileprivate func handleTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        guard let nav = navigationController else {
            return
        }
        let show = nav.isNavigationBarHidden
        // show
        nav.setNavigationBarHidden(!show, animated: true)
        // show the view
        let destinationAlpha: CGFloat = show ? 1 : 0
        informationView.alpha = 1 - destinationAlpha
        informationView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.informationView.alpha = destinationAlpha
        }
    }
    
    @objc fileprivate func doubleTapped(_ sender: UITapGestureRecognizer) {
        // check if already zoomed in to max
        if abs(scrollView.zoomScale - scrollView.maximumZoomScale) < .ulpOfOne {
            // zoomed in
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            // zoom in
            scrollView.setZoomScale(min(scrollView.zoomScale * 2, scrollView.maximumZoomScale), animated: true)
        }
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraints(for: view.bounds.size)
    }
    fileprivate func updateMinZoomScale(for size: CGSize) {
        guard imageView.bounds.width > 0 && imageView.bounds.height > 0 else {
            return
        }
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 2
        scrollView.zoomScale = minScale
        if !zoomable {
            scrollView.maximumZoomScale = minScale
        }
    }
    fileprivate func updateConstraints(for size: CGSize) {
        
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
}
