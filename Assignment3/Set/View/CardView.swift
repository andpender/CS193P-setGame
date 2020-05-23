//
//  CardView.swift
//  Assignment3
//
//  Created by Andrew Pender on 3/5/20.
//  Copyright © 2020 Andrew Pender. All rights reserved.
//

import UIKit


class CardView: UIView {

    private var symbol: Symbol = .circle { didSet { setNeedsDisplay(); setNeedsLayout() } }
    private var color: UIColor = Colors.red { didSet { setNeedsDisplay(); setNeedsLayout() } }
    private var fill: Fill = .empty { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var number: Int = 3 { didSet { setNeedsDisplay(); setNeedsLayout() } }

    var isSelected: Bool = false { didSet { setNeedsDisplay(); setNeedsLayout() } }

    var fillInt: Int = 1 { didSet {
        switch fillInt {
        case 1: fill = .empty
        case 2: fill = .stripes
        case 3: fill = .solid
        default:
            break
        }
    } }

    var colorInt: Int = 1 { didSet {
        switch colorInt {
        case 1: color = Colors.blue
        case 2: color = Colors.green
        case 3: color = Colors.red
        default:
            break
        }
    } }

    var symbolInt: Int = 1 { didSet {
        switch symbolInt {
        case 1: symbol = .circle
        case 2: symbol = .diamond
        case 3: symbol = .squiggle
        default: break
        }
    } }


    private enum Symbol: Int {
        case diamond
        case squiggle
        case circle
    }

    private enum Fill: Int {
        case empty
        case stripes
        case solid
    }


    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        UIColor.white.setFill()
        roundedRect.lineWidth = Constant.lineWidth
        roundedRect.stroke()
        roundedRect.fill()
        drawFrame()
    }


    private func drawFrame() {
        color.setFill()
        color.setStroke()
        let origin = CGPoint(x: faceFrame.minX, y: faceFrame.minY)
        let size = CGSize(width: faceFrame.width, height: faceFrame.height / CGFloat(number))

        switch number {
        case 1:
            let firstRect = CGRect(origin: origin, size: size)
            drawShape(in: firstRect)
        case 2:
            let firstRect = CGRect(origin: origin, size: size)
            drawShape(in: firstRect)
            let secondRect = firstRect.offsetBy(dx: 0, dy: faceFrame.height / CGFloat(number))
            drawShape(in: secondRect)
        case 3:
            let firstRect = CGRect(origin: origin, size: size)
            drawShape(in: firstRect)
            let secondRect = firstRect.offsetBy(dx: 0, dy: faceFrame.height / CGFloat(number))
            drawShape(in: secondRect)
            let thirdRect = secondRect.offsetBy(dx: 0, dy: faceFrame.height / CGFloat(number))
            drawShape(in: thirdRect)
        default:
            break
        }
    }

    private func configureState() {
        isOpaque = false
        contentMode = .redraw

        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureState()
    }

    /// Draws the outline for the shape and fills according to fill requirements
    private func drawShape(in rect: CGRect) {
        let path: UIBezierPath
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()

        defer { context.restoreGState() }

        switch symbol {
        case .circle:
            path = pathForCircle(in: rect)
        case .diamond:
            path = pathForDiamond(in: rect)
        case .squiggle:
            path = pathForSquiggle(in: rect)
        }

        switch fill {
        case .solid:
            path.fill()
        case .stripes:
            path.addClip()
            drawStripes(path: path, in: rect)
        default:
            break
        }

        context.addPath(path.cgPath)
        context.closePath()
        context.strokePath()
    }

    private func pathForCircle(in rect: CGRect) -> UIBezierPath {
        let circle = UIBezierPath(roundedRect: CGRect(x: rect.midX / 2, y: rect.midY - pipHeight / 2, width: rect.width * 0.8, height: pipHeight), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 20, height: 20))
        circle.close()
        return circle
    }

    private func pathForDiamond(in rect: CGRect) -> UIBezierPath {
        let diamond = UIBezierPath()
        diamond.move(to: CGPoint(x: rect.midX, y: rect.midY - (pipHeight / 2)))
        diamond.addLine(to: CGPoint(x: rect.midX / 3, y: rect.midY))
        diamond.addLine(to: CGPoint(x: rect.midX, y: rect.midY + (pipHeight / 2)))
        diamond.addLine(to: CGPoint(x: rect.midX + (rect.midX * 2 / 3), y: rect.midY))
        diamond.close()
        return diamond
    }

    private func pathForSquiggle(in rect: CGRect) -> UIBezierPath {
        let upperSquiggle = UIBezierPath()
        let sqdx = rect.width * 0.1
        let sqdy = rect.height * 0.2
        upperSquiggle.move(to: CGPoint(x: rect.minX,
            y: rect.midY))
        upperSquiggle.addCurve(to:
                CGPoint(x: rect.minX + rect.width * 1 / 2,
                    y: rect.minY + rect.height / 8),
            controlPoint1: CGPoint(x: rect.minX,
                y: rect.minY),
            controlPoint2: CGPoint(x: rect.minX + rect.width * 1 / 2 - sqdx,
                y: rect.minY + rect.height / 8 - sqdy))
        upperSquiggle.addCurve(to:
                CGPoint(x: rect.minX + rect.width * 4 / 5,
                    y: rect.minY + rect.height / 8),
            controlPoint1: CGPoint(x: rect.minX + rect.width * 1 / 2 + sqdx,
                y: rect.minY + rect.height / 8 + sqdy),
            controlPoint2: CGPoint(x: rect.minX + rect.width * 4 / 5 - sqdx,
                y: rect.minY + rect.height / 8 + sqdy))

        upperSquiggle.addCurve(to:
                CGPoint(x: rect.minX + rect.width,
                    y: rect.minY + rect.height / 2),
            controlPoint1: CGPoint(x: rect.minX + rect.width * 4 / 5 + sqdx,
                y: rect.minY + rect.height / 8 - sqdy),
            controlPoint2: CGPoint(x: rect.minX + rect.width,
                y: rect.minY))

        let lowerSquiggle = UIBezierPath(cgPath: upperSquiggle.cgPath)
        lowerSquiggle.apply(CGAffineTransform.identity.rotated(by: CGFloat.pi))
        lowerSquiggle.apply(CGAffineTransform.identity
                .translatedBy(x: bounds.width, y: bounds.height))
        upperSquiggle.move(to: CGPoint(x: rect.minX, y: rect.midY))
        upperSquiggle.append(lowerSquiggle)
        upperSquiggle.close()
        return upperSquiggle
    }



    // Draws vertical striped throughout bounds, works due to clipping of shape
    private func drawStripes(path: UIBezierPath, in rect: CGRect) -> UIBezierPath {
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        path.addClip()
        let lines = UIBezierPath()
        for xValues in stride(from: rect.minX, to: rect.maxX, by: 4.0) {
            lines.move(to: CGPoint(x: xValues, y: rect.minY))
            lines.addLine(to: CGPoint(x: xValues, y: rect.maxY))
        }
        lines.stroke()
        context?.restoreGState()
        return lines
    }

    // MARK: Constants

    private struct SizeRatio {
        static let pinFontSizeToBoundsHeight: CGFloat = 0.09
        static let maxFaceSizeToBoundsSize: CGFloat = 0.75
        static let pipHeightToFaceHeight: CGFloat = 0.25
        static let cornerRadiusToBoundsHeight: CGFloat = 0.15
        static let pinOffset: CGFloat = 0.03
    }

    private struct AspectRatio {
        static let faceFrame: CGFloat = 0.60
    }

    private var maxFaceFrame: CGRect {
        return bounds.zoomed(by: SizeRatio.maxFaceSizeToBoundsSize)
    }

    private var faceFrame: CGRect {
        let faceWidth = maxFaceFrame.height * AspectRatio.faceFrame
        return maxFaceFrame.insetBy(dx: (maxFaceFrame.width - faceWidth) / 2, dy: 0)
    }

    private var pipHeight: CGFloat {
        return faceFrame.height * SizeRatio.pipHeightToFaceHeight
    }

    private var pinFontSize: CGFloat {
        return bounds.size.height * SizeRatio.pinFontSizeToBoundsHeight
    }

    private var interPipHeight: CGFloat {
        return (faceFrame.height - (3 * pipHeight)) / 2
    }

    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }

    private let borderWidth: CGFloat = 5.0


    private struct Colors {
        static let green = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        static let blue = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        static let red = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    }

    private struct Constant {
        static let lineWidth: CGFloat = 0.0
        static let pipRatio: CGFloat = 0.3
    }
}

extension CGRect {
    func zoomed(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}
