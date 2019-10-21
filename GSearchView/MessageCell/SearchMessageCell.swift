//
//  MessageCell.swift
//  iOS3
//
//  Created by Алексей Папин on 27.09.2019.
//  Copyright © 2019 CREDIT BANK OF MOSCOW. All rights reserved.
//

import UIKit

final class SearchMessageCell: UITableViewCell {
    @IBOutlet private weak var messageLabel: UILabel!
    
    public func configure(with message: String?) {
        self.messageLabel.text = message
    }
}
