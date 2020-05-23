//
//  ViewController.swift
//  Concentration
//
//  Created by Andrew Pender on 21/4/20.
//  Copyright © 2020 Andrew Pender. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    @IBOutlet private var flipCountLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    private var emoji = [ConcentrationCard: String]()
    private var numberOfCards = 12

//    private let emojiThemes = [
//        ConcentrationTheme(name: "default", emojis: ["🍕", "🎸", "🧘", "🚴‍♂️", "🤖", "👽", "🐮", "🐱", "👻"]),
//        ConcentrationTheme(name: "animals", emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮", "🐵", "🐸", "🐽", "🐷", "🐔", "🐧"])]


    var emojiChoices: [String] = []


    var numberOfPairsOfCards: Int {
        return cardButtons.count / 2
    }

    private func updateViewFromModel() {
        flipCountLabel.text = "Flip Count: \(game.flipCount)"
        scoreLabel.text = "Score: \(game.score)"
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0): #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }

    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card was not in card button")
        }
    }

    @IBAction func touchNewGame() {
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
//        emojiChoices = emojiThemes[emojiThemes.count.arc4random].emojis.shuffled()
        emoji.removeAll()
        updateViewFromModel()
    }

    private func emoji(for card: ConcentrationCard) -> String {
        print(emoji[card])
        if emoji[card] == nil, emojiChoices.count > 0 {
            emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(-self)))
        } else {
            return 0
        }
    }

}

