//
//  Color.swift
//  Assignment2
//
//  Created by Andrew Pender on 27/4/20.
//  Copyright © 2020 Andrew Pender. All rights reserved.
//

import Foundation
import UIKit

enum Color: CaseIterable {
    case first
    case second
    case third
}

enum Shape: CaseIterable {
    case first
    case second
    case third
}

enum Shade: CaseIterable {
    case first
    case second
    case third
}

enum Number: Int {
    case one = 1, two, three
}

//struct Color {
//    static var option1 = UIColor.blue
//    static var option2 = UIColor.red
//    static var option3 = UIColor.green
//
//    static func colorReturn(option: Int) -> UIColor {
//        switch option {
//        case 1:
//            return option1
//        case 2:
//            return option2
//        case 3:
//            return option3
//        default:
//            return option1
//        }
//    }
//}
