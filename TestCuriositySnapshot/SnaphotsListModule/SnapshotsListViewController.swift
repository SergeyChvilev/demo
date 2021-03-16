//
//  SnapshotsListViewController.swift
//  TestCuriositySnapshot
//
//  Created by Sergey Chvilev on 12.03.2021.
//

import UIKit
import ImageViewer
import Kingfisher
import RxSwift
import RxCocoa

class SnapshotsListViewController: UIViewController {
    @IBOutlet weak var snapshotsListCollectionView: UICollectionView!
    @IBOutlet var snaphotLongPressGestureRecognizer: UILongPressGestureRecognizer!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    let refreshControl = UIRefreshControl()
    
    
    private var imageUrls: [ShortSnaphotInfo] {
        return viewModel.snaphotsRelay.value
    }
    private let viewModel = SnapshotsListViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.barTintColor = Style.Colors.barColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Style.Colors.barTintColor]
        activityIndicatorView.color = Style.Colors.mainTintColor
        refreshControl.tintColor = Style.Colors.mainTintColor
        self.view.backgroundColor = Style.Colors.backgroundColor
        
        loadFromNetwork()
        bind()
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        snapshotsListCollectionView.addSubview(refreshControl)
        guard let collectionView = snapshotsListCollectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let margin: CGFloat = 8
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
    
    private func bind() {
        viewModel.snaphotsRelay.asObservable()
            .bind(to: snapshotsListCollectionView.rx.items(cellIdentifier: SnaphotCollectionViewCell.Identifier, cellType: SnaphotCollectionViewCell.self)) {
            row, snaphot, cell in
                cell.imgSrc = snaphot.imgSrc
            }.disposed(by: viewModel.disposeBag)
        
        viewModel.urlSingle?.subscribe { (_) in
            self.loadComplited()
        } onFailure: { (_) in
            self.loadComplited(isSuccessful: false)
        }.disposed(by: viewModel.disposeBag)
    }
    
    private func loadFromNetwork() {
        loadStart()
        viewModel.loadFromNetwork()
    }
    
    @objc private func refresh() {
        viewModel.loadFromNetwork()
        viewModel.urlSingle?.subscribe { (_) in
            self.loadComplited()
        } onFailure: { (_) in
            self.loadComplited(isSuccessful: false)
        }.disposed(by: viewModel.disposeBag)
    }
    
    private func loadStart() {
        snapshotsListCollectionView.isHidden = true
        errorLabel.isHidden = true
        activityIndicatorView.startAnimating()
    }
    
    private func loadComplited(isSuccessful: Bool = true) {
        snapshotsListCollectionView.isHidden = !isSuccessful
        errorLabel.isHidden = isSuccessful
        activityIndicatorView.stopAnimating()
        refreshControl.endRefreshing()

    }
    
    @IBAction func handleSnaphotLongPressGestureRecognizer(_ sender: UILongPressGestureRecognizer) {
        let pressPoint = sender.location(in: snapshotsListCollectionView)
        guard let indexPath = snapshotsListCollectionView.indexPathForItem(at: pressPoint) else {
            return
        }
        let cell = snapshotsListCollectionView.cellForItem(at: indexPath) as? SnaphotCollectionViewCell
        guard  sender.state == .ended else {
            if sender.state == .began {
                cell?.isLongTap = true
            }
            return
        }
        cell?.isLongTap = false
        openRemoveAlert(imageIndexPath: indexPath)
    }
    
    private func openRemoveAlert(imageIndexPath: IndexPath) {
        let remoaveAlert = UIAlertController(title:  nil, message: nil, preferredStyle: .actionSheet)
        remoaveAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        remoaveAlert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (_) in
            self.remove(imageWithIndexPath: imageIndexPath)
        }))
        self.present(remoaveAlert, animated: true, completion: nil)
    }
    
    private func remove(imageWithIndexPath index: IndexPath) {
        viewModel.removeSnaphot(at: index.row)
    }
}


//MARK: - UICollectionViewDelegate
extension SnapshotsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let galleryViewController = GalleryViewController(startIndex: indexPath.row, itemsDataSource: self, displacedViewsDataSource: self, configuration: galleryConfiguration())
        let frame = CGRect(x: 0, y: 0, width: 200, height: 24)
        let headerView = CounterView(frame: frame, currentCameraString: imageUrls[indexPath.row].cameraName)
        galleryViewController.landedPageAtIndexCompletion = { [weak self] index in
            headerView.currentCameraString = self?.imageUrls[index].cameraName ?? "Unknow"
        }
        galleryViewController.headerView = headerView
        self.presentImageGallery(galleryViewController)
    }
    
    private func galleryConfiguration() -> GalleryConfiguration {
        return [
            GalleryConfigurationItem.closeButtonMode(.builtIn),
            GalleryConfigurationItem.seeAllCloseButtonMode(.none),
            GalleryConfigurationItem.thumbnailsButtonMode(.none),
            GalleryConfigurationItem.deleteButtonMode(.none),
            GalleryConfigurationItem.swipeToDismissMode(.vertical),
            GalleryConfigurationItem.overlayColor(UIColor(white: 0.035, alpha: 1)),
            GalleryConfigurationItem.maximumZoomScale(4),
            GalleryConfigurationItem.statusBarHidden(false),

        ]
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SnapshotsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCellsInRow = 2
         let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
         let totalSpace = flowLayout.sectionInset.left
             + flowLayout.sectionInset.right
             + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfCellsInRow - 1))
         let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfCellsInRow))
         return CGSize(width: size, height: size)
    }
}

extension SnapshotsListViewController: GalleryDisplacedViewsDataSource {

    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        let imageView = (snapshotsListCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? SnaphotCollectionViewCell)?.imageView
        return imageView
    }
}

extension SnapshotsListViewController: GalleryItemsDataSource {
    func itemCount() -> Int {
        return imageUrls.count
    }

    func provideGalleryItem(_ index: Int) -> GalleryItem {
        let imgView = UIImageView()
        let galleryItem = GalleryItem.image { imageCompletion in
            let pictureURL = URL(string: self.imageUrls[index].imgSrc)
            imgView.kf.setImage(with: pictureURL, options: nil) { result in
                guard let image = try? result.get().image else {
                    imageCompletion(UIImage(named: "im_error"))
                    return
                }
                imageCompletion(image)
            }
        }
        return galleryItem
    }
}

extension UIImageView: DisplaceableView {}
