//
//  ListGeoObjectsModuleInput.swift
//  iOS3
//
//  Created by Alexey Papin on 13/09/2019.
//  Copyright © 2019 CREDIT BANK OF MOSCOW. All rights reserved.
//

import UIKit

protocol ListGeoObjectsModuleInput {
    var output: ListGeoObjectsModuleOutput? { get set }
    func present(from viewController: UIViewController)
}
