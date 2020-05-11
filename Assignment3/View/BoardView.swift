//
//  SetView.swift
//  Assignment3
//
//  Created by Andrew Pender on 3/5/20.
//  Copyright © 2020 Andrew Pender. All rights reserved.
//

import UIKit

class BoardView: UIView {
    
    /// Property that holds all of the different card views
    var cardViews = [CardView]() {
        willSet { removeSubviews();}
        didSet { addSubviews(); setNeedsLayout() }
    }

    private func removeSubviews() {
        for card in cardViews {
            card.removeFromSuperview()
        }
    }

    /// Adds all of the subviews for each of the cardViews
    private func addSubviews() {
        for card in cardViews {
            addSubview(card)
        }
    }


    /**
     Sets up the layout of card subviews according to how many views are in cardViews property.
    
     Loops through each of the rows and columns established by the cellAspectRatio passed through to the
     to the Grid struct
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        var grid = Grid(layout: .aspectRatio(Constant.cellApsectRatio), frame: bounds)
        grid.cellCount = cardViews.count
        for row in 0..<grid.dimensions.rowCount {
            for column in 0..<grid.dimensions.columnCount {
                if cardViews.count > (row * grid.dimensions.columnCount + column) {
                    cardViews[row * grid.dimensions.columnCount + column].frame = grid[row, column]!.insetBy(dx: Constant.spacingDx, dy: Constant.spacingDy)
                }
            }
        }
    }
    
    /// Constants used in the BoardView class
    struct Constant {
        static let cellApsectRatio: CGFloat = 0.7
        static let spacingDx: CGFloat = 3.0
        static let spacingDy: CGFloat = 3.0
    }

}
