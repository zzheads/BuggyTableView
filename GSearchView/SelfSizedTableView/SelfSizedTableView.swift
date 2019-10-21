//
//  SelfSizedTableView.swift
//  iOS3
//
//  Created by Алексей Папин on 17.10.2019.
//  Copyright © 2019 CREDIT BANK OF MOSCOW. All rights reserved.
//

import Foundation

class SelfSizedTableView: UITableView {
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height {
        didSet { self.invalidateIntrinsicContentSize() }
    }
  
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        let height = min(contentSize.height, maxHeight)
        return CGSize(width: self.width, height: height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.invalidateIntrinsicContentSize()
    }
}
