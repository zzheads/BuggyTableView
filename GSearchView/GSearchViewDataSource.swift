//
//  GSearchViewDataSource.swift
//  iOS3
//
//  Created by Алексей Папин on 27.09.2019.
//  Copyright © 2019 CREDIT BANK OF MOSCOW. All rights reserved.
//

import Foundation

protocol GSearchViewDataSource {
    func dataModel(for searchText: String?) -> GSearchView.DataModel
}

protocol GSearchViewDelegate {
    func selected(object: Distanceable?)
}
