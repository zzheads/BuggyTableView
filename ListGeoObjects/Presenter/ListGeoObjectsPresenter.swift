//
//  ListGeoObjectsPresenter.swift
//  iOS3
//
//  Created by Alexey Papin on 13/09/2019.
//  Copyright © 2019 CREDIT BANK OF MOSCOW. All rights reserved.
//

import UIKit

class ListGeoObjectsPresenter: NSObject {
    weak var view: ListGeoObjectsViewInput!
    var router: ListGeoObjectsRouterInput!
    var output: ListGeoObjectsModuleOutput?
    
    var objects: [GObject]
    var atmSettings: GFilter.AtmSettings?
    var filtered: [GObject] = []
    
    var title: String {
        guard let first = self.objects.first, let type = first.type else { return "" }
        return type.names
    }
    
    init(objects: [GObject], atmSettings: GFilter.AtmSettings?) {
        self.objects = objects
        super.init()
        guard
            let atms = objects as? [GAtm],
            let settings = atmSettings
            else {
                self.filtered = objects
                return
        }
        self.atmSettings = atmSettings
        self.filtered = atms.filter(settings: settings)
    }
}

extension ListGeoObjectsPresenter: ListGeoObjectsViewOutput {
    // MARK: - ListGeoObjectsViewOutput
    func viewIsReady() {
        self.view.setupInitialState(title: self.title, showFilter: self.atmSettings != nil, dataSource: self, searchDataSource: self)
    }
    
    func backPressed() {
        self.view.viewController.navigationController?.popViewController(animated: true)
    }
    
    func filterPressed() {
        guard let settings = self.atmSettings else { return }
        self.router.showAtmSettings(settings: settings, output: self, from: self.view.viewController)
    }
}

extension ListGeoObjectsPresenter: ListGeoObjectsModuleInput {
    // MARK: - ListGeoObjectsModuleInput
    func present(from viewController: UIViewController) {
        self.view.present(from: viewController)
    }
}
 
extension ListGeoObjectsPresenter: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GObjectCell.reuseIdentifier, for: indexPath) as! GObjectCell
        cell.configure(with: self.filtered[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GObjectCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.viewController.navigationController?.popViewController(animated: true)
        self.output?.selected(object: self.filtered[indexPath.row])
    }
}

// MARK: - AtmFilterSettingsModuleOutput
extension ListGeoObjectsPresenter: AtmFilterSettingsModuleOutput {
    func done(settings: GFilter.AtmSettings?) {
        guard
            let atms = self.objects as? [GAtm],
            let settings = settings
            else {
                return
        }
        self.atmSettings = settings
        self.filtered = atms.filter(settings: settings)
        self.view.reload()
    }
}

// MARK: - GSearchViewDataSource, GSearchViewDelegate
extension ListGeoObjectsPresenter: GSearchViewDataSource, GSearchViewDelegate {
    func dataModel(for searchText: String?) -> GSearchView.DataModel {
        guard
            let searchText = searchText,
            !searchText.isEmpty
            else {
                return GSearchView.DataModel()
        }
        var model = GSearchView.DataModel()
        let maxResultCount = 50
        var count: Int = 0
        for object in self.objects {
            guard count < maxResultCount else { break }
            if let atm = object as? GAtm {
                if atm.name.lowercased().contains(searchText.lowercased()) {
                    model.atms.append(atm)
                    count += 1
                }
            }
            if let office = object as? GOffice {
                if office.name.lowercased().contains(searchText.lowercased()) {
                    model.offices.append(office)
                    count += 1
                }
            }
            if let terminal = object as? GTerminal {
                if terminal.name.lowercased().contains(searchText.lowercased()) {
                    model.terminals.append(terminal)
                    count += 1
                }
            }
            if let cash = object as? GCash {
                if cash.name.lowercased().contains(searchText.lowercased()) {
                    model.cashes.append(cash)
                    count += 1
                }
            }
            if let center = object as? GCentre {
                if center.name.lowercased().contains(searchText.lowercased()) {
                    model.centers.append(center)
                    count += 1
                }
            }
        }
        model.nothingFoundMessage = model.atms.isEmpty && model.offices.isEmpty && model.terminals.isEmpty && model.cashes.isEmpty && model.centers.isEmpty ? "Ничего не найдено" : nil
        return model
    }

    func selected(object: Distanceable?) {
        guard let object = object as? GObject else { return }
        self.view.viewController.navigationController?.popViewController(animated: true)
        self.output?.selected(object: object)
    }
}
