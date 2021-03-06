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
            dealButton.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            dealButton.layer.borderWidth = 5
            dealButton.layer.cornerRadius = 0.15 * dealButton.bounds.height
        }
    }
    @IBOutlet weak var setScoreLabel: UILabel! {
        didSet {
            setScoreLabel.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            setScoreLabel.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            setScoreLabel.layer.borderWidth = 5
            setScoreLabel.layer.cornerRadius = 0.15 * setScoreLabel.bounds.height
        }
    }

    private var currentSets: Int = 0 {
        didSet {
            setScoreLabel.text = "\(currentSets / 3) Sets"
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
        currentSets = setGame.matchedCards.count
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

                // Prepare cardview for incoming transition
                cardView.frame = dealButton.frame
                boardView.cardViews.append(cardView)
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6, delay: 0.0, options: [], animations: {
                        self.boardView.layoutIfNeeded()
                    })
            } else {
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6, delay: 0.0, options: [], animations: {
                        if self.setGame.matchedCards.contains(card) {
                            self.boardView.cardViews[index].alpha = 0
                        }
                    }, completion: { finished in
                        let cardView = self.boardView.cardViews[index]
                        self.updateCardView(cardView, for: card)
                    })
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
}

