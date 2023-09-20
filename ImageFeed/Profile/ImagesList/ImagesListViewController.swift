//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Валерия Медведева on 29.07.2023.
//


import UIKit

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imagesListService: ImagesListService?
    private var imagesServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []
    private var alertPresenter: AlertPresenter?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter(delagate: self)
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        configureImageList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showSingleImageSegueIdentifier {
    let viewController = segue.destination as? SingleImageViewController
    let indexPath = sender as? IndexPath

    guard let viewController = viewController,
          let indexPath = indexPath else {
        return
    }

    viewController.largeImageURL = URL(string: photos[indexPath.row].largeImageURL)
} else {
    super.prepare(for: segue, sender: sender)
}
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.addGradient(size: CGSize(
                     width: imageListCell.bounds.width,
                     height: imageListCell.bounds.height
                 ))
        
        imageListCell.delegate = self

               let photo = photos[indexPath.row]
               let statusOfConfiguringCell = imageListCell.configCell(using: photo.thumbImageURL, with: indexPath, date: photo.createdAt)
               imageListCell.setIsLiked(photo.isLiked)
        if statusOfConfiguringCell {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath
    ) {
        guard let imagesListService = imagesListService else { return }
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView,
                        heightForRowAt indexPath: IndexPath
         ) -> CGFloat {

             let image = photos[indexPath.row]

             let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
             let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
             let imageWidth = image.size.width
             let scale = imageViewWidth / imageWidth
             let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
             return cellHeight
         }
}

private extension ImagesListViewController {
    func configureImageList() {
        imagesListService = ImagesListService()
        guard let imagesListService = imagesListService else { return }
        imagesListService.fetchPhotosNextPage()
        
        imagesServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
        updateTableViewAnimated()
    }
    
    func updateTableViewAnimated() {
        guard let imagesListService = imagesListService else { return }
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    func showError() {
        let alert = AlertModel(title: "Ошибка сети",
                                        message: "Не удалось поставить/убрать лайк",
                                        buttonText: "Ок",
                                        completion: { [weak self] in
                     guard let self = self else { return }
                     dismiss(animated: true)
                 })

                 alertPresenter?.show(alert)
         }
}

//MARK: - ImagesListCellDelegate
 extension ImagesListViewController: ImagesListCellDelegate {
     func imageListCellDidTapLike(_ cell: ImagesListCell) {
         guard let indexPath = tableView.indexPath(for: cell) else { return }

         let photo = photos[indexPath.row]
         let isLiked = photo.isLiked

         UIBlockingProgressHUD.show()

         guard let imagesListService = imagesListService else { return }

         imagesListService.changeLike(
             photoId: photo.id,
             isLike: isLiked
//         ) { result in
         ) { [weak self] result in
                      guard let self = self else { return }
             switch result {
                 case .success(let isLiked):
                     self.photos[indexPath.row].isLiked = isLiked
                     cell.setIsLiked(isLiked)
                     UIBlockingProgressHUD.dismiss()
             case .failure:
                     UIBlockingProgressHUD.dismiss()
//                     // TODO: Показать ошибку с использованием UIAlertController
                 self.showError()
             }
         }
     }
 }

// MARK: - AlertPresentableDelagate
extension ImagesListViewController: AlertPresentableDelagate {
     func present(alert: UIAlertController, animated flag: Bool) {
         self.present(alert, animated: flag)
     }
 }




