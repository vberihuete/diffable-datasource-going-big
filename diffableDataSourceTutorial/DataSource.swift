//
//  DataSource.swift
//  diffableDataSourceTutorial
//
//  Created by Vincent Berihuete Paulino on 08/02/2023.
//

import UIKit

// MARK: - Section protocol
enum FoodSectionIdentifier {
    case favouriteFood
    case restaurants
    case nearByUsers
    case disclaimers
}

protocol FoodSectionProtocol {
    var identifier: FoodSectionIdentifier { get }
    func getElements() -> [AnyHashable]
    func cellModel(for row: Int) -> CellModel
}

// MARK: - DataSource
protocol FoodDataSourceProtocol: AnyObject {
    var reload: () -> Void { get set }
    func getSections() -> [FoodSectionIdentifier]
    func getElements(for section: Int) -> [AnyHashable]
    func setup()
    func update()
    func cellModel(for indexPath: IndexPath) -> CellModel
}

final class FoodDataSource: FoodDataSourceProtocol {
    private let favouriteFoodSection: FavouriteFoodSectionProtocol
    private let restaurantsSection: RestaurantsSectionProtocol
    private let nearbyUsersSection: NearbyUsersSectionProtocol
    private let disclaimerSection: FoodDisclaimerSectionProtocol

    private var sections: [FoodSectionProtocol] = []

    var reload: () -> Void = {}

    init(
        favouriteFoodSection: FavouriteFoodSectionProtocol,
        restaurantsSection: RestaurantsSectionProtocol,
        nearbyUsersSection: NearbyUsersSectionProtocol,
        disclaimerSection: FoodDisclaimerSectionProtocol
    ) {
        self.favouriteFoodSection = favouriteFoodSection
        self.restaurantsSection = restaurantsSection
        self.nearbyUsersSection = nearbyUsersSection
        self.disclaimerSection = disclaimerSection
    }

    convenience init() {
        self.init(
            favouriteFoodSection: FavouriteFoodSection(),
            restaurantsSection: RestaurantsSection(),
            nearbyUsersSection: NearbyUsersSection(),
            disclaimerSection: FoodDisclaimerSection()
        )
    }

    func getSections() -> [FoodSectionIdentifier] {
        sections.map(\.identifier)
    }

    func getElements(for section: Int) -> [AnyHashable] {
        sections[section].getElements()
    }

    func setup() {
        // setup structure
        sections = [
            favouriteFoodSection,
            restaurantsSection,
            nearbyUsersSection,
            disclaimerSection
        ]

        // setup actions
        favouriteFoodSection.didRequestAction = { [weak self] action in
            switch action {
            case .reload:
                self?.reload()
            case let .sayHello(name):
                print("Hello \(name)")// bonus: here you propagate hello to viewModel and then do whatever you need
            }
        }

        restaurantsSection.didRequestAction = { [weak self] action in
            switch action {
            case .reload:
                self?.reload()
            }
        }
    }

    func update() {
        favouriteFoodSection.update()
        restaurantsSection.update()
        nearbyUsersSection.update()
        reload()
    }

    func cellModel(for indexPath: IndexPath) -> CellModel {
        sections[indexPath.section].cellModel(for: indexPath.row)
    }
}


// MARK: - FavouriteFood section
enum FavouriteFoodSectionAction: Equatable {
    case reload
    case sayHello(name: String)
}
protocol FavouriteFoodSectionProtocol: AnyObject, FoodSectionProtocol {
    var didRequestAction: (FavouriteFoodSectionAction) -> Void { get set } // bonus material
    func update()
}

final class FavouriteFoodSection: FavouriteFoodSectionProtocol {
    private var elements: [Element] = []
    var identifier: FoodSectionIdentifier = .favouriteFood
    var didRequestAction: (FavouriteFoodSectionAction) -> Void = { _ in } // bonus material

    func update() {
        elements = [.squaredFood, .foodWithImage, .foodDeal, .foodWithRatings]
        let timer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
                self?.elements.shuffle()
                self?.didRequestAction(.reload)
        }
        RunLoop.current.add(timer, forMode: .common)
        timer.fire()
    }

    func getElements() -> [AnyHashable] {
        elements
    }

    func cellModel(for row: Int) -> CellModel {
        // here we build our cell model
        switch elements[row] {
        case .foodWithImage:
            return .init(message: "food with image")
        case .squaredFood:
            return .init(message: "square food")
        case .foodWithRatings:
            return .init(message: "food with ratings")
        case .foodDeal:
            return .init(message: "this is a food deal")
        }
    }

    private enum Element: Hashable {
        case squaredFood
        case foodWithImage
        case foodWithRatings
        case foodDeal
    }
}

// MARK: - Restaurants section
enum RestaurantsSectionAction: Equatable {
    case reload
}
protocol RestaurantsSectionProtocol: AnyObject, FoodSectionProtocol {
    var didRequestAction: (RestaurantsSectionAction) -> Void { get set }
    func update()
}

final class RestaurantsSection: RestaurantsSectionProtocol {
    private var elements: [Element] = []
    var identifier: FoodSectionIdentifier = .restaurants
    var didRequestAction: (RestaurantsSectionAction) -> Void = { _ in }

    func update() {
        let timer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.elements = Element.allCases.prefix(Int.random(in: 1..<Element.allCases.count)).shuffled() // random elements
            self.didRequestAction(.reload)
        }
        RunLoop.current.add(timer, forMode: .common)
        timer.fire()
    }

    func getElements() -> [AnyHashable] {
        elements
    }

    func cellModel(for row: Int) -> CellModel {
        // here we build our cell model
        switch elements[row] {
        case .restaurantWithLog:
            return .init(message: "restaurant with logo")
        case .restaurantWithRatings:
            return .init(message: "restaurant with ratings")
        case .bigRestaurant:
            return .init(message: "big restaurant here")
        case .smallRestaurant:
            return .init(message: "small restaurant here")
        }
    }

    private enum Element: Hashable, CaseIterable {
        case restaurantWithLog
        case restaurantWithRatings
        case bigRestaurant
        case smallRestaurant
    }
}

// MARK: - nearByUsers
protocol NearbyUsersSectionProtocol: FoodSectionProtocol {
    func update()
}

final class NearbyUsersSection: NearbyUsersSectionProtocol {
    private var elements: [Element] = []
    var identifier: FoodSectionIdentifier = .nearByUsers

    func update() {
        elements = [.userWithNameOnly, .userWithAvatar]
    }

    func getElements() -> [AnyHashable] {
        elements
    }

    func cellModel(for row: Int) -> CellModel {
        // here we build our cell model
        switch elements[row] {
        case .userWithAvatar:
            return .init(message: "User and its avatar")
        case .userWithNameOnly:
            return .init(message: "User with name only")
        }
    }

    private enum Element: Hashable {
        case userWithAvatar
        case userWithNameOnly
    }
}


// MARK: - SharedDisclaimerSection
protocol SharedDisclaimerSectionProtocol {
    func getElements() -> [AnyHashable]
    func cellModel(for row: Int) -> CellModel
}

class SharedDisclaimerSection: SharedDisclaimerSectionProtocol {
    private var elements: [Element] = [.companyLogo(0), .mainDisclaimer, .copyright, .companyLogo(1)]

    func getElements() -> [AnyHashable] {
        elements
    }

    func cellModel(for row: Int) -> CellModel {
        switch elements[row] {
        case .mainDisclaimer:
            return .init(message: "main disclaimer")
        case .companyLogo:
            return .init(message: "companyLogo")
        case .copyright:
            return .init(message: "This is the copyright text")
        }
    }

    private enum Element: Hashable {
        case mainDisclaimer
        case companyLogo(Int)
        case copyright
    }
}


// MARK: - Food disclaimer
protocol FoodDisclaimerSectionProtocol: FoodSectionProtocol {}

final class FoodDisclaimerSection: SharedDisclaimerSection, FoodDisclaimerSectionProtocol {
    var identifier: FoodSectionIdentifier = .disclaimers
}
