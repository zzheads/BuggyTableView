//
//  ListGeoObjectsViewController.swift
//  iOS3
//
//  Created by Alexey Papin on 13/09/2019.
//  Copyright © 2019 CREDIT BANK OF MOSCOW. All rights reserved.
//

import UIKit

class ListGeoObjectsViewController: UIViewController {
    var output: ListGeoObjectsViewOutput!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var filterButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var searchViewContainer: UIView!

    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    
    private var searchView: GSearchView?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButton.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
        self.filterButton.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
        if let searchView = GSearchView.instanceFromNib(parentView: self.contentView, viewHeightConstraint: self.searchViewHeightConstraint, theme: .dark) {
            searchView.addAndAlign(to: self.searchViewContainer)
            searchView.onBeginEditing = { [weak self] in self?.tableView.isHidden = true }
            searchView.onEndEditing = { [weak self] in self?.tableView.isHidden = false }
            self.searchView = searchView
        }
        self.output.viewIsReady()
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        switch sender {
        case self.backButton    : self.output.backPressed()
        case self.filterButton  : self.output.filterPressed()
        default                 : break
        }
    }
}


// MARK: - ListGeoObjectsViewInput
extension ListGeoObjectsViewController: ListGeoObjectsViewInput {
    func setupInitialState(title: String, showFilter: Bool, dataSource: UITableViewDataSource & UITableViewDelegate, searchDataSource: GSearchViewDataSource & GSearchViewDelegate) {
        self.searchView?.dataSource = searchDataSource
        self.searchView?.delegate = searchDataSource
        self.titleLabel.text = title
        self.filterButton.isHidden = !showFilter
        self.tableView.register(GObjectCell.nib, forCellReuseIdentifier: GObjectCell.reuseIdentifier)
        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource
        self.tableView.reloadData()
    }
    
    func reload() {
        self.tableView.reloadData()
    }
}

// MARK: - ViewControllerable
extension ListGeoObjectsViewController: ViewControllerable {
    static func storyBoardName() -> String {
        return "ListGeoObjects"
    }
}
