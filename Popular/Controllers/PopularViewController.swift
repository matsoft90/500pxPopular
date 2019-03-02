//
//  ViewController.swift
//  Popular
//
//  Created by Mahmood Tahir on 2019-03-02.
//  Copyright © 2019 Mahmood Tahir. All rights reserved.
//

import UIKit

class PopularViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    // MARK: - Private
    fileprivate let api = API()
    fileprivate var photos: [Photo] = []
    fileprivate var lastLoadedPage: Int?
    fileprivate var isLoading = false
    fileprivate var numberOfPagesToLoad: Int?
    // MARK: - Public
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadMorePhotos()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController, let imageVC = nav.viewControllers.first as? ImageViewController {
            let handler = TransitioningHandler.shared
            imageVC.transitioningDelegate = handler
            imageVC.interactor = handler.interactor
            if let cell = sender as? ImageCell, let indexPath = collectionView.indexPath(for: cell) {
                imageVC.photo = photos[indexPath.item]
                imageVC.image = cell.imageView.image
            }
        }
    }
}

extension PopularViewController {
    fileprivate func loadMorePhotos() {
        guard !isLoading else {
            return
        }
        if let pagesToLoad = numberOfPagesToLoad, let lastLoadedPage = lastLoadedPage, lastLoadedPage == pagesToLoad {
            // everything is already loaded
            return
        }
        isLoading = true
        collectionView.reloadData()
        // figure out the next page to load
        let pageToLoad = (lastLoadedPage ?? 0) + 1
        api.popularPhotos(page: pageToLoad) {[weak self] (result) in
            guard let sself = self else {
                return
            }
            switch result {
            case .success(let response):
                print("photos page \(response.currentPage) loaded with \(response.photos.count) photos")
                sself.photos.append(contentsOf: response.photos)
                sself.lastLoadedPage = pageToLoad
                sself.numberOfPagesToLoad = response.totalPages
                sself.collectionView.reloadData()
            case .error(let error):
                print("error loading \(error)")
                // show retry option if there is nothing loaded
            }
            sself.isLoading = false
        }
    }
}

extension PopularViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.cellIdentifier, for: indexPath) as! ImageCell
        
        if let index = photos[indexPath.item].images.lastIndex(where: {$0.size == Image.Size.square440}) {
            cell.imageUrl = photos[indexPath.item].images[index].httpsUrl
        } else {
            cell.imageUrl = nil
        }
        return cell
    }
}

extension PopularViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingFooterView.identifier, for: indexPath) as! LoadingFooterView
            if isLoading {
                if !header.activityIndicatorView.isAnimating {
                    header.activityIndicatorView.startAnimating()
                }
            } else {
                if header.activityIndicatorView.isAnimating {
                    header.activityIndicatorView.stopAnimating()
                }
            }
            return header
        }
        return UICollectionReusableView()
    }
}

extension PopularViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // calculate item size to fit two columns
        let numOfColumns: CGFloat = 2
        let spacing: CGFloat = 5
        
        let usableWidth = collectionView.frame.width - spacing * (numOfColumns - 1) - spacing * 2
        let itemWidth = usableWidth / numOfColumns
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
}

extension PopularViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        
        let reload_distance: CGFloat = 0
        if(y > h + reload_distance) {
            // load more
            loadMorePhotos()
        }
    }
}
