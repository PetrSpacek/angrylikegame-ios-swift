//
//  GameObject.swift
//  AngryBirdsADP
//
//  Created by Rostislav Babáček on 24/11/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import SpriteKit

class GameObject: NSObject, NSCopying {
    var size: CGSize = .zero
    var position: CGPoint = .zero
    var zRotation: CGFloat = .zero
    var name: String = ""
    var health: Int = -1
    var score = 0
    
    func copy(with zone: NSZone? = nil) -> Any {
        let theCopy = type(of: self)
        return theCopy
    }
    
    func getPosition() -> CGPoint {
        return position
    }
    
    func getConfiguration() -> ObjectConfiguration {
        return ObjectConfiguration(size: size, position: position, zRotation: zRotation, name: name, health: health)
    }
}
