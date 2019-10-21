//
//  ListGeoObjectsViewInput.swift
//  iOS3
//
//  Created by Alexey Papin on 13/09/2019.
//  Copyright © 2019 CREDIT BANK OF MOSCOW. All rights reserved.
//

import UIKit

protocol ListGeoObjectsViewInput: class, Presentable {
    func setupInitialState(title: String, showFilter: Bool, dataSource: UITableViewDataSource & UITableViewDelegate, searchDataSource: GSearchViewDataSource & GSearchViewDelegate) 
    func reload()
}
