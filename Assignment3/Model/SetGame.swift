//
//  Set.swift
//  Assignment2
//
//  Created by Andrew Pender on 28/4/20.
//  Copyright © 2020 Andrew Pender. All rights reserved.
//

import Foundation

class SetGame {
    private(set) var startingDeck = [Card]()
    private(set) var cardsOnTable = [Card]()
    private(set) var matchedCards = [Card]()
    private(set) var selectedCards = [Card]()
    


    init() {
        for colorCase in Card.CardProperty.allValues {
            for shapeCase in Card.CardProperty.allValues {
                for fillCase in Card.CardProperty.allValues {
                    for numberCase in Card.CardProperty.allValues {
                        startingDeck.append(Card(color: colorCase, shape: shapeCase, fill: fillCase, number: numberCase))
                    }
                }
            }
        }
        startingDeck.shuffle()
        dealCards(number: 12)
    }

    func dealCards(number: Int) {
        if startingDeck.count >= number {
            for _ in 0..<number {
                cardsOnTable += [startingDeck.removeFirst()]
            }
        }
    }

    func selectCard(card: Card) {
        if let index = selectedCards.firstIndex(of: card) {
            selectedCards.remove(at: index)
        } else {
            selectedCards.append(card)
        }
    }

    func matchCards() {
        if selectedCards.count == 3 {
            if selectedCards.isValidAttribute({ $0.color == $1.color }) &&
                selectedCards.isValidAttribute({ $0.shape == $1.shape }) &&
                selectedCards.isValidAttribute({ $0.number == $1.number }) &&
                selectedCards.isValidAttribute({ $0.fill == $1.fill }) {
                matchedCards.append(contentsOf: selectedCards)
                cardsOnTable = cardsOnTable.filter { !selectedCards.contains($0) }
            }
        }
        selectedCards.removeAll()
    }
    
    func shuffle() {
        cardsOnTable.shuffle()
    }
}

extension Array {
    func isValidAttribute(_ compare: (Element, Element) -> Bool) -> Bool {
        var same = true
        var diff = true
        for i in self.indices {
            for j in i..<self.count {
                if i != j {
                    same = same && compare(self[i], self[j])
                    diff = diff && !compare(self[i], self[j])
                }
            }
        }
        return same || diff
    }
}
