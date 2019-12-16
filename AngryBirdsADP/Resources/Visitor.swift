//
//  Visitor.swift
//  AngryBirdsADP
//
//  Created by Rostislav Babáček on 24/11/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import SpriteKit

protocol GameObjectVisitor {
    func visit(enemy: Enemy)
    func visit(bird: Bird)
    func visit(slingshot: RealSlingshot)
    func visit(camera: Camera)
    func visit(block: Block)
}

protocol GameObjectCommonVisitor {
    func accept(visitor: GameObjectVisitor)
    func setPosition(position: CGPoint)
}
