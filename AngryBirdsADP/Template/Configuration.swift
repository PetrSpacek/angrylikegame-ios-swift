//
//  Configuration.swift
//  AngryBirdsADP
//
//  Created by Rostislav Babáček on 10/10/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import CoreGraphics

struct ZPosition {
    static let background: CGFloat = 0
    static let gameObjects: CGFloat = 1
    static let bird: CGFloat = 2
    static let levelButton: CGFloat = 10
    static let levelButtonLabel: CGFloat = 11
}

struct PhysicsCategory {
    static let all: UInt32 = UInt32.max
    static let edge: UInt32 = 0x1
    static let bird: UInt32 = 0x1 << 1
    static let block: UInt32 = 0x1 << 2
    static let enemy: UInt32 = 0x1 << 3
}

extension CGPoint {
    static public func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static public func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static public func * (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }
}
