//
//  GameCamera.swift
//  AngryBirdsADP
//
//  Created by Rostislav Babáček on 10/10/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import SpriteKit

class GameCamera: SKCameraNode {
    
    /// Sets camera constraints only insice feame of our map
    /// - Parameter scene: given SKScene
    /// - Parameter frame: give frame
    /// - Parameter node: given node
    func setConstraints(with scene: SKScene, and frame: CGRect, to node: SKNode?) {
        // xScale, yScale is zoom factor
        let scaledSize = CGSize(width: scene.size.width * xScale, height: scene.size.height * yScale)
        let boardContentRect = frame
        
        let xInset = min(scaledSize.width / 2, boardContentRect.width / 2)
        let yInset = min(scaledSize.height / 2, boardContentRect.height / 2)
        let insetContentRect = boardContentRect.insetBy(dx: xInset, dy: yInset)
        
        // create scene limits
        let xRange = SKRange(lowerLimit: insetContentRect.minX, upperLimit: insetContentRect.maxX)
        let yRange = SKRange(lowerLimit: insetContentRect.minY, upperLimit: insetContentRect.maxY)
        // setup contraints - camera should not be able to move close to the borders of our map
        let levelEdgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        
        if let node = node {
            let zeroRange = SKRange(constantValue: 0.0)
            let positionConstraints = SKConstraint.distance(zeroRange, to: node)
            constraints = [positionConstraints, levelEdgeConstraint]
        } else {
            constraints = [levelEdgeConstraint]
        }
    }
}
