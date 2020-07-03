//
//  MusicCell.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 03.07.2020.
//  Copyright © 2020 NRKK.DEV. All rights reserved.
//

import UIKit
import Kingfisher

class MusicCell: UITableViewCell {
    
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        backgroundColor = highlighted ? UIColor(white: 1, alpha: 0.05) : UIColor.clear
    }
    
    
    func set(_ music: Music) {
        coverImage.kf.setImage(with: music.getCoverURL)
        titleLabel.text = music.title
        artistLabel.text = music.artist
    }
}
