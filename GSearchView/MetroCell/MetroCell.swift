//
//  MetroCell.swift
//  iOS3
//
//  Created by Алексей Папин on 26.09.2019.
//  Copyright © 2019 CREDIT BANK OF MOSCOW. All rights reserved.
//

import UIKit

final class MetroCell: UITableViewCell {
    static let nib = UINib(nibName: reuseIdentifier, bundle: nil)
    
    @IBOutlet private weak var iconBackgroundView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!

    public func configure(with item: GMetro) {
        self.iconBackgroundView.backgroundColor = .blue // TODO: Change color depends on path-owner of metro station
        self.nameLabel.text = item.name
        self.distanceLabel.text = item.distanceDescription
    }
}
