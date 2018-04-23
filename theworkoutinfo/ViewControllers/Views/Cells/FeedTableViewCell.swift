//
//  FeedTableViewCell.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 4/4/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import UIKit
import Kingfisher

class FeedTableViewCell: UITableViewCell {
    
    static let cellReuseIdentifier = "FeedTableViewCellIdentifier"
    static let cellNibName = "FeedTableViewCell"
    
    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setup(withExercise exercise: Exercise) {
        self.descriptionLabel.text = exercise.description
        
        if let imageURL = exercise.imageURL {
            let url = URL(string: imageURL)
            self.exerciseImageView.kf.setImage(with: url)
        } else {
            exerciseImageView.image = UIImage(named: "AppMainIcon")
        }
    }
    
}
