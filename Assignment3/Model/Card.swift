//
//  Card.swift
//  Assignment2
//
//  Created by Andrew Pender on 27/4/20.
//  Copyright © 2020 Andrew Pender. All rights reserved.
//

import Foundation

struct Card: Hashable {
    let color: CardProperty
    let shape: CardProperty
    let fill: CardProperty
    let number: CardProperty
    
    enum CardProperty: Int {
        case first = 1
        case second
        case third
        
        static var allValues: [CardProperty] { return [.first, .second, .third] }
    }
}
