//
//  Card.swift
//  Concentration
//
//  Created by Andrew Pender on 22/4/20.
//  Copyright © 2020 Andrew Pender. All rights reserved.
//

import Foundation

struct ConcentrationCard: Equatable, Hashable {
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    var hashValue: Int { return identifier }

    private static var identifierFactory = 0

    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }

    init() {
        self.identifier = ConcentrationCard.getUniqueIdentifier()
    }

    static func == (lhs: ConcentrationCard, rhs: ConcentrationCard) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
