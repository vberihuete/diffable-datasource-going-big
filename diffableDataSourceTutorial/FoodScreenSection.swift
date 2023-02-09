//
//  FoodScreenSection.swift
//  diffableDataSourceTutorial
//
//  Created by Vincent Berihuete Paulino on 08/02/2023.
//

import Foundation

enum FoodScreenSection: Hashable {
    case favourites
    case recentEats
}

// MARK: - item

enum FoodScreenItem: Hashable {
    case roundedFood
    case largeFoodWithImage
    case squaredFood
}
