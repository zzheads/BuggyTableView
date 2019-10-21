//
//  ListGeoObjectsModule.swift
//  iOS3
//
//  Created by Alexey Papin on 13/09/2019.
//  Copyright © 2019 CREDIT BANK OF MOSCOW. All rights reserved.
//

import UIKit

class ListGeoObjectsModule {
    class func create(objects: [GObject], atmSettings: GFilter.AtmSettings?, output: ListGeoObjectsModuleOutput?) -> ListGeoObjectsModuleInput {
        let viewController = ListGeoObjectsViewController.create()

        let presenter = ListGeoObjectsPresenter(objects: objects, atmSettings: atmSettings)
        presenter.output = output
        presenter.view = viewController
        presenter.router = ListGeoObjectsRouter()

        viewController.output = presenter
	
        return presenter
    }
}
