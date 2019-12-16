//
//  LevelScene.swift
//  AngryBirdsADP
//
//  Created by Rostislav Babáček on 21/10/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import SpriteKit

class LevelScene: SKScene {
    weak var sceneManagerDelegate: SceneManagerDelegate?
    
    override func didMove(to view: SKView) {
        setupLevelSelection()
    }
    
    func setupLevelSelection() {
        var level = 1
        let columnStartingPoint = frame.midX/1.5
        for column in 0..<2 {
            let levelBoxButton = SpriteKitButton(defaultButtonImage: "levelMenuButton", action: goToGameScene, index: level)
            levelBoxButton.position = CGPoint(x: columnStartingPoint + CGFloat(column) * columnStartingPoint, y: frame.midY)
            levelBoxButton.zPosition = ZPosition.background
            addChild(levelBoxButton)
            
            let levelLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
            levelLabel.fontSize = 120.0
            levelLabel.verticalAlignmentMode = .center
            levelLabel.text = "\(level)"
            levelLabel.zPosition = ZPosition.levelButton
            levelBoxButton.addChild(levelLabel)
            
            level += 1
        }
    }
    
    func goToGameScene(level: Int) {
        sceneManagerDelegate?.presentGameSceneFor(level: level)
    }
}
