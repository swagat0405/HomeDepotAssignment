//
//  ReposCollectionViewCell.swift
//  HomeDepotAssignment
//
//  Created by Swagat Mishra on 5/2/18.
//  Copyright © 2018 Swagat Mishra. All rights reserved.
//

import UIKit

class ReposCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var createdLabel: UILabel!
    @IBOutlet weak private var licenseLabel: UILabel!
    
    func setValues(from repo: Repo) {
        self.nameLabel.text = repo.name
        self.createdLabel.text = repo.createdAt
        self.descriptionLabel.text = repo.description
        self.licenseLabel.text = repo.license?.name
    }
}
