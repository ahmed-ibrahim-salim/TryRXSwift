
import UIKit
import Photos
import RxSwift

class PhotosViewController: UICollectionViewController {
    
    // MARK: public properties
    var selectedPhotos: Observable<UIImage> {
        //  we observe subject, before any events emitted to the subject, to receive any events for this observable
        return selectedPhotosSubject.asObservable()
    }
    
    // MARK: private properties
    private let bag = DisposeBag()
    private let authorised = PHPhotoLibrary.authorized.share()
    private let selectedPhotosSubject = PublishSubject<UIImage>()
    
    private lazy var photos = PhotosViewController.loadPhotos()
    private lazy var imageManager = PHCachingImageManager()
    
    private lazy var thumbnailSize: CGSize = {
        let cellSize = (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        return CGSize(width: cellSize.width * UIScreen.main.scale,
                      height: cellSize.height * UIScreen.main.scale)
    }()
    
    static func loadPhotos() -> PHFetchResult<PHAsset> {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return PHAsset.fetchAssets(with: allPhotosOptions)
    }
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // when authorized reload data
        authorised
            .skip(while: { !$0 })
            .take(1)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.photos = PhotosViewController.loadPhotos()
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                }
            })
        
        // when not authorized show error
        authorised
          .skip(1)
          .takeLast(1)
          .filter { !$0 }
          .subscribe(onNext: { [weak self] _ in
            guard let errorMessage = self?.errorMessage else { return }
            DispatchQueue.main.async(execute: errorMessage)
          })
          .disposed(by: bag)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // on complete to terminate observable
        selectedPhotosSubject.onCompleted()
    }
    private func errorMessage() {
        alert(title: "No access to Camera Roll",
              text: "You can grant access to Combinestagram from the Settings app")
            .asObservable()
            .take(for: .seconds(5), scheduler: MainScheduler.instance)
            .subscribe(onCompleted: {
                [weak self] in
                
                // dismiss alert after received completed event
                self?.dismiss(animated: true)
                // pop controller after received completed event
                self?.navigationController?.popViewController(animated: true)
            })
             .disposed(by: bag)
    }
            
    // MARK: UICollectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let asset = photos.object(at: indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCell
        
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.imageView.image = image
            }
        })
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = photos.object(at: indexPath.item)
        
        // flashing when selected
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
            cell.flash()
        }
        
        imageManager.requestImage(for: asset,
                                  targetSize: view.frame.size,
                                  contentMode: .aspectFill,
                                  options: nil,
                                  resultHandler: {
            
            [weak self] image, info in
            
            guard let image = image,
                  let info = info else { return }
            
            if let isThumbnail = info[PHImageResultIsDegradedKey as NSString] as? Bool,
                !isThumbnail {
                // add photo to subject
                self?.selectedPhotosSubject.onNext(image)
            }
        })
        
    }
}
