//
//  SolutionTableViewCell.swift
//  SolutionsViewer
//
//  Created by Carlo Donzelli on 29/07/2015.
//  Copyright (c) 2015 Carlo Donzelli. All rights reserved.
//

import UIKit

class SolutionTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailWidth: NSLayoutConstraint!
    @IBOutlet weak var horizontalSpacing: NSLayoutConstraint!
}
