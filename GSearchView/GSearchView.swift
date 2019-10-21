//
//  GSearchView.swift
//  iOS3
//
//  Created by Алексей Папин on 26.09.2019.
//  Copyright © 2019 CREDIT BANK OF MOSCOW. All rights reserved.
//

import UIKit

final class GSearchView: UIView {
    static let nib = UINib(nibName: reuseIdentifier, bundle: nil)
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var dividerView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var dividerViewHeightConstraint: NSLayoutConstraint!
    private var viewHeightConstraint: NSLayoutConstraint!
    
    private var parentView: UIView!
    private var maxHeight: CGFloat! {
        return self.parentView.bounds.height
    }
    private var isActive: Bool = false {
        didSet {
            print("New state: \(self.isActive)")
            self.reloadData()
        }
    }
    
    internal struct DataModel {
        public enum Section: String {
            case metro = "Рядом с метро"
            case atms = "Ближайшие банкоматы"
            case offices = "Отделения"
            case terminals = "Терминалы"
            case cashes = "Операционные кассы"
            case centers = "Торговые центры"
            case message
            
            static var all: [Section] = [.metro, .atms, .offices, .terminals, .cashes, .centers, .message]
        }

        public var stations: [GMetro]
        public var atms: [GAtm]
        public var offices: [GOffice]
        public var terminals: [GTerminal]
        public var cashes: [GCash]
        public var centers: [GCentre]
        public var nothingFoundMessage: String?
        
        public var sections: [Section] {
            var result = [Section]()
            if !self.stations.isEmpty { result.append(.metro) }
            if !self.atms.isEmpty { result.append(.atms) }
            if !self.offices.isEmpty { result.append(.offices) }
            if !self.terminals.isEmpty { result.append(.terminals) }
            if !self.cashes.isEmpty { result.append(.cashes) }
            if !self.centers.isEmpty { result.append(.centers) }
            return !result.isEmpty ? result : self.nothingFoundMessage == nil ? [] : [.message]
        }
        
        init(stations: [GMetro] = [], atms: [GAtm] = [], offices: [GOffice] = [], terminals: [GTerminal] = [], cashes: [GCash] = [], centers: [GCentre] = [], nothingFoundMessage: String? = nil) {
            self.stations = stations
            self.atms = atms
            self.offices = offices
            self.terminals = terminals
            self.cashes = cashes
            self.centers = centers
            self.nothingFoundMessage = nothingFoundMessage
        }
    }
    
    public enum Theme: String {
        case light
        case dark
        
        var color: UIColor {
            switch self {
            case .light : return .white
            case .dark  : return ColorStyle.grayBackgroundButton.color()
            }
        }
    }
    
    public var theme: Theme! { didSet { self.containerView.backgroundColor = self.theme.color } }
    public var dataSource: GSearchViewDataSource?
    public var delegate: GSearchViewDelegate?
    public var onBeginEditing: (() -> Void) = { }
    public var onEndEditing: (() -> Void) = { }

    private var dataModel: DataModel = DataModel() {
        didSet { self.reloadData() }
    }

    class func instanceFromNib(parentView: UIView, viewHeightConstraint: NSLayoutConstraint, theme: Theme = .light) -> GSearchView? {
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? GSearchView else { return nil }
        view.theme = theme
        view.parentView = parentView
        view.viewHeightConstraint = viewHeightConstraint
        view.setupTableView()
        return view
    }
    
    func setupTableView() {
        self.tableView.register(MetroCell.nib, forCellReuseIdentifier: MetroCell.reuseIdentifier)
        self.tableView.register(GObjectCell.nib, forCellReuseIdentifier: GObjectCell.reuseIdentifier)
        self.tableView.register(SearchMessageCell.uiNib(), forCellReuseIdentifier: SearchMessageCell.reuseIdentifier)
        self.tableView.register(GObjectSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: GObjectSectionHeaderView.reuseIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = GObjectCell.height
        self.tableView.estimatedSectionHeaderHeight = GObjectSectionHeaderView.height
        self.tableView.rowHeight = GObjectCell.height
        self.tableView.tableFooterView = UIView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textField.backgroundColor = .clear
        self.textField.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: .allEditingEvents)
        self.searchButton.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        self.textField.delegate = self
    }
    
    public func reloadData() {
        self.tableView.reloadData()
        self.viewHeightConstraint.constant = self.isActive ? self.tableView.contentSize.height : 60
        self.dividerViewHeightConstraint.constant = self.isActive ? 0 : 2
        self.layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.isActive {
            self.containerView.layer.cornerRadius = 0
            self.containerView.roundCorners(radius: 8, byRoundingCorners: [.topLeft, .topRight])
        } else {
            self.containerView.layer.cornerRadius = 8
        }
        self.tableView.roundCorners(radius: 8, byRoundingCorners: [.bottomLeft, .bottomRight])
    }
    
    @objc private func textFieldChanged(_ sender: UITextField) {
        self.dataModel = self.dataSource?.dataModel(for: sender.text) ?? DataModel()
    }
    
    @objc private func close() {
        self.textField.text = nil
        self.textField.resignFirstResponder()
        self.isActive = false
        self.dataModel = DataModel()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension GSearchView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard self.isActive else { return 0 }
        return self.dataModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.isActive else { return 0 }
        switch self.dataModel.sections[section] {
        case .metro     : return self.dataModel.stations.count
        case .atms      : return self.dataModel.atms.count
        case .offices   : return self.dataModel.offices.count
        case .terminals : return self.dataModel.terminals.count
        case .cashes    : return self.dataModel.cashes.count
        case .centers   : return self.dataModel.centers.count
        case .message   : return self.dataModel.nothingFoundMessage == nil ? 0 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.dataModel.sections[indexPath.section] {
        case .metro:
            let cell = tableView.dequeueReusableCell(withIdentifier: MetroCell.reuseIdentifier, for: indexPath) as! MetroCell
            let metro = self.dataModel.stations[indexPath.row]
            cell.configure(with: metro)
            return cell
        case .atms:
            let cell = tableView.dequeueReusableCell(withIdentifier: GObjectCell.reuseIdentifier, for: indexPath) as! GObjectCell
            let atm = self.dataModel.atms[indexPath.row]
            cell.configure(with: atm)
            return cell
        case .offices:
            let cell = tableView.dequeueReusableCell(withIdentifier: GObjectCell.reuseIdentifier, for: indexPath) as! GObjectCell
            let office = self.dataModel.offices[indexPath.row]
            cell.configure(with: office)
            return cell
        case .terminals:
            let cell = tableView.dequeueReusableCell(withIdentifier: GObjectCell.reuseIdentifier, for: indexPath) as! GObjectCell
            let terminal = self.dataModel.terminals[indexPath.row]
            cell.configure(with: terminal)
            return cell
        case .cashes:
            let cell = tableView.dequeueReusableCell(withIdentifier: GObjectCell.reuseIdentifier, for: indexPath) as! GObjectCell
            let cash = self.dataModel.cashes[indexPath.row]
            cell.configure(with: cash)
            return cell
        case .centers:
            let cell = tableView.dequeueReusableCell(withIdentifier: GObjectCell.reuseIdentifier, for: indexPath) as! GObjectCell
            let center = self.dataModel.centers[indexPath.row]
            cell.configure(with: center)
            return cell
            
        case .message:
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchMessageCell.reuseIdentifier, for: indexPath) as! SearchMessageCell
            let message = self.dataModel.nothingFoundMessage ?? "ошибка поиска"
            cell.configure(with: message)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GObjectCell.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard self.isActive else { return 0 }
        return self.dataModel.sections[section] == .message ? 0 : GObjectSectionHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard self.isActive else { return nil }
        let section = self.dataModel.sections[section]
        guard section != .message else {
            return nil
        }
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: GObjectSectionHeaderView.reuseIdentifier) as! GObjectSectionHeaderView
        view.title = section.rawValue
        view.buttonTitle = nil
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selected: Distanceable?
        switch self.dataModel.sections[indexPath.section] {
        case .metro: selected = self.dataModel.stations[indexPath.row]
        case .atms: selected = self.dataModel.atms[indexPath.row]
        case .offices: selected = self.dataModel.offices[indexPath.row]
        case .terminals: selected = self.dataModel.terminals[indexPath.row]
        case .cashes: selected = self.dataModel.cashes[indexPath.row]
        case .centers: selected = self.dataModel.centers[indexPath.row]
        case .message: selected = nil
        }
        self.close()
        self.delegate?.selected(object: selected)
    }
}

// MARK: - UITextFieldDelegate
extension GSearchView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.searchButton.setImage(UIImage(named: "close_black"), for: .normal)
        self.onBeginEditing()
        self.isActive = true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.searchButton.setImage(UIImage(named: "find_black"), for: .normal)
        self.onEndEditing()
    }
}
