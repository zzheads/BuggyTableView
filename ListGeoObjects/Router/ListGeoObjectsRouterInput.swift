//
//  ListGeoObjectsRouterInput.swift
//  iOS3
//
//  Created by Алексей Папин on 02.10.2019.
//  Copyright © 2019 CREDIT BANK OF MOSCOW. All rights reserved.
//

import Foundation

protocol ListGeoObjectsRouterInput: class {
    func showAtmSettings(settings: GFilter.AtmSettings, output: AtmFilterSettingsModuleOutput, from viewController: UIViewController) 
}
