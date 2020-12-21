//
//  Utils.swift
//  AmongUs
//
//  Created by John Martin on 20/12/2020.
//

import SwiftUI

extension UIColor {
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func darkened(by amount: CGFloat) -> UIColor {
        let (red, green, blue, alpha) = rgba
        return UIColor(
            red: red * (1.0 - amount),
            green: green * (1.0 - amount),
            blue: blue * (1.0 - amount),
            alpha: alpha
        )
    }
    
    func lightened(by amount: CGFloat) -> UIColor {
        let (red, green, blue, alpha) = rgba
        return UIColor(
            red: red * (1.0 + amount),
            green: green * (1.0 + amount),
            blue: blue * (1.0 + amount),
            alpha: alpha
        )
    }

}


extension CGPoint {
    
    func offset(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
    
}


extension Path {

    mutating func addLine(toX x: CGFloat) {
        guard let p = currentPoint else { return }
        addLine(to: CGPoint(x: x, y: p.y))
    }
    
    mutating func addLine(dx: CGFloat, dy: CGFloat) {
        guard let p = currentPoint else { return }
        addLine(to: CGPoint(x: p.x + dx, y: p.y + dy))
    }
    
    mutating func move(dx: CGFloat, dy: CGFloat) {
        guard let p = currentPoint else { return }
        move(to: CGPoint(x: p.x + dx, y: p.y + dy))
    }
    
    mutating func move(toX x: CGFloat) {
        guard let p = currentPoint else { return }
        move(to: CGPoint(x: x, y: p.y))
    }
    
}


