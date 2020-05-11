//
//  ViewController.swift
//  Assignment2
//
//  Created by Andrew Pender on 27/4/20.
//  Copyright © 2020 Andrew Pender. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    private var setGame = SetGame()
    @IBOutlet var dealButton: UIButton! {
        didSet {
            dealButton.titleLabel?.font = UIFont(name: "Deal 3 More", size: 55.0)
            dealButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            dealButton.layer.borderWidth = 5
            dealButton.layer.cornerRadius = 0.15 * dealButton.bounds.height
        }
    }
    @IBOutlet weak var boardView: BoardView! {
        didSet {
            boardView.backgroundColor = #colorLiteral(red: 0.7090377371, green: 0.7542965646, blue: 1, alpha: 1)
        }
    }

    @IBAction func touchDeal() {
        setGame.matchCards()
        setGame.dealCards(number: 3)
        updateCardViewsFromModel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.7090377371, green: 0.7542965646, blue: 1, alpha: 1)
        updateCardViewsFromModel()
        addRotateGesture()
        addSwipeDownGesture()
    }


    private func updateCardViewsFromModel() {
        setDealMore()
        if boardView.cardViews.count - setGame.cardsOnTable.count > 0 {
            let cardViews = boardView.cardViews [..<setGame.cardsOnTable.count]
            boardView.cardViews = Array(cardViews)
        }

        let numberCardViews = boardView.cardViews.count

        for index in setGame.cardsOnTable.indices {
            let card = setGame.cardsOnTable[index]
            if index > (numberCardViews - 1) {
                let cardView = CardView()
                updateCardView(cardView, for: card)
                addTapViewGestureRecognizer(for: cardView)
                boardView.cardViews.append(cardView)
            } else {
                let cardView = boardView.cardViews[index]
                updateCardView(cardView, for: card)
            }
        }
    }

    private func getSelectedViewIndexCardOnTable(for cardView: CardView) -> Card? {
        guard let cardIndex = boardView.cardViews.firstIndex(of: cardView) else {
            return nil
        }
        return setGame.cardsOnTable[cardIndex]
    }

    private func updateCardView(_ cardView: CardView, for card: Card) {
        cardView.fillInt = card.fill.rawValue
        cardView.colorInt = card.color.rawValue
        cardView.symbolInt = card.shape.rawValue
        cardView.number = card.number.rawValue
        
        cardView.layer.borderColor = setGame.selectedCards.contains(card) ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1): #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    // MARK: Gestures
    private func addTapViewGestureRecognizer(for cardView: CardView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(setSelected(_:)))
        tap.numberOfTouchesRequired = 1
        cardView.addGestureRecognizer(tap)
    }

    @objc func setSelected(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let cardView = recognizer.view! as? CardView {
                if let selectedCard = getSelectedViewIndexCardOnTable(for: cardView), setGame.selectedCards.count < 3 || setGame.selectedCards.contains(selectedCard) {
                    setGame.selectCard(card: selectedCard)
                    updateCardViewsFromModel()
                }
            }
        default:
            break
        }
    }

    private func addRotateGesture() {
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(shuffleRotate(recognizedBy:)))
        self.view.addGestureRecognizer(rotate)

    }

    @objc func shuffleRotate(recognizedBy recognizer: UIRotationGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            setGame.shuffle()
            updateCardViewsFromModel()
        default:
            break
        }
    }

    private func addSwipeDownGesture() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownDeal(recognizedBy:)))
        swipe.direction = .down
        self.view.addGestureRecognizer(swipe)
    }

    @objc func swipeDownDeal(recognizedBy recognizer: UISwipeGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            setGame.matchCards()
            setGame.dealCards(number: 3)
            updateCardViewsFromModel()
        default:
            break
        }
    }



    // Disables deal more if more than 21 cards are on table
    private func setDealMore() {
        if setGame.cardsOnTable.count <= 81 || setGame.selectedCards.count == 3 {
            dealButton.isEnabled = true
            dealButton.isHidden = false
        } else {
            dealButton.isEnabled = false
            dealButton.isHidden = true
        }
    }
}

