//
//  ViewController.swift
//  diffableDataSourceTutorial
//
//  Created by Vincent Berihuete Paulino on 08/02/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    typealias DiffableDataSource = UITableViewDiffableDataSource<FoodSectionIdentifier, AnyHashable>
    private lazy var dataSource = DiffableDataSource(
        tableView: tableView
    ) { [weak self] tableView, indexPath, _ in
        self?.viewModel.cellModel(for: indexPath).tableViewModel(in: tableView, indexPath: indexPath)
    }
    private let viewModel = FoodViewModel(dataSource: FoodDataSource())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup tableView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicStyle")
        tableView.dataSource = dataSource
        // bind view model
        viewModel.updateSnapshotSignal = { [weak self] snapshot in
            self?.dataSource.apply(snapshot)
        }
        // setup data
        viewModel.setup()
        // load data
        viewModel.loadData()
    }
}


// MARK: - Item builder helper
struct CellModel {
    let message: String

    func tableViewModel(
        in tableView: UITableView,
        indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyle", for: indexPath)
        cell.textLabel?.text = message
        return cell
    }
}

