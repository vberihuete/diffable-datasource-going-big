//
//  ViewModel.swift
//  diffableDataSourceTutorial
//
//  Created by Vincent Berihuete Paulino on 08/02/2023.
//

import UIKit

final class FoodViewModel {
    typealias Snapshot = NSDiffableDataSourceSnapshot<FoodSectionIdentifier, AnyHashable>
    private let dataSource: FoodDataSourceProtocol

    init(dataSource: FoodDataSourceProtocol) {
        self.dataSource = dataSource
    }

    var updateSnapshotSignal: (Snapshot) -> Void = { _ in }

    func setup() {
        dataSource.reload = { [weak self] in
            guard let self else { return }
            self.updateSnapshotSignal(self.makeSnapshot())
        }
        dataSource.setup()
    }

    func loadData() {
        dataSource.update()
    }

    func cellModel(for indexPath: IndexPath) -> CellModel {
        dataSource.cellModel(for: indexPath)
    }

    private func makeSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        let sections = dataSource.getSections()
        snapshot.appendSections(sections)
        sections.enumerated().forEach { index, element in
            snapshot.appendItems(dataSource.getElements(for: index), toSection: element)
        }
        return snapshot
    }
}
