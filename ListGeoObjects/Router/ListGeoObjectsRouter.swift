//
//  ListGeoObjectsRouter.swift
//  iOS3
//
//  Created by Алексей Папин on 02.10.2019.
//  Copyright © 2019 CREDIT BANK OF MOSCOW. All rights reserved.
//

import Foundation

class ListGeoObjectsRouter: ListGeoObjectsRouterInput {
    func showAtmSettings(settings: GFilter.AtmSettings, output: AtmFilterSettingsModuleOutput, from viewController: UIViewController) {
        AtmFilterSettingsModule.create(settings: settings, output: output).present(from: viewController)
    }
}
