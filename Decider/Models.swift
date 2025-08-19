//
//  Models.swift
//  Decider
//
//  Created by Min Thet Naung on 19/08/2025.
//

import Foundation
import SwiftUI

// MARK: - Category Model
struct Category: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let defaultOptions: [String]
}

// MARK: - Option Model
struct Option: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let category: String
    var isCustom: Bool = false
}

// MARK: - Decision Model
struct Decision: Identifiable {
    let id = UUID()
    let selectedOption: Option
    let allOptions: [Option]
    let timestamp: Date
    let category: String
}

// MARK: - Predefined Categories
struct CategoryData {
    static let categories: [Category] = [
        Category(
            name: "Food",
            icon: "fork.knife",
            color: .orange,
            defaultOptions: ["Pizza", "Sushi", "Burger", "Tacos", "Pasta", "Thai Food", "Chinese Food", "Mexican Food"]
        ),
        Category(
            name: "Places",
            icon: "location.fill",
            color: .blue,
            defaultOptions: ["Park", "Beach", "Mall", "Museum", "Cafe", "Library", "Cinema", "Restaurant"]
        ),
        Category(
            name: "Activities",
            icon: "gamecontroller.fill",
            color: .green,
            defaultOptions: ["Movie Night", "Board Games", "Hiking", "Shopping", "Cooking", "Video Games", "Sports", "Reading"]
        ),
        Category(
            name: "Entertainment",
            icon: "tv.fill",
            color: .purple,
            defaultOptions: ["Netflix", "YouTube", "Music", "Podcast", "Book", "Game", "Social Media", "News"]
        )
    ]
}
