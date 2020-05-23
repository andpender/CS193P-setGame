//
//  Concentration.swift
//  Concentration
//
//  Created by Andrew Pender on 22/4/20.
//  Copyright © 2020 Andrew Pender. All rights reserved.
//

import Foundation

class Concentration {
    private(set) var cards = [ConcentrationCard]()
    private(set) var flipCount = 0
    private(set) var score = 0
    private var seenBefore = [ConcentrationCard: Bool]()

    private var indexOfOneAndOnlyOneFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    private func scoreSeenBefore(firstCard: ConcentrationCard, secondCard: ConcentrationCard) {
        if seenBefore[firstCard] == true {
            score -= 1
        }
        if seenBefore[secondCard] == true {
            score -= 1
        }
        seenBefore[firstCard] = true
        seenBefore[secondCard] = true
    }

    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfOneAndOnlyOneFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else {
                    scoreSeenBefore(firstCard: cards[matchIndex], secondCard: cards[index])
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyOneFaceUpCard = index
            }
        }
    }

    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 0..<numberOfPairsOfCards {
            let card = ConcentrationCard()
            cards += [card, card]
            seenBefore[card] = false
        }
        cards.shuffle()
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
