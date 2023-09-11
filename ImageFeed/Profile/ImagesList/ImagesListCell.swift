//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Валерия Медведева on 29.07.2023.
//



import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
}
