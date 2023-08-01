//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Валерия Медведева on 29.07.2023.
//

import Foundation

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
}
