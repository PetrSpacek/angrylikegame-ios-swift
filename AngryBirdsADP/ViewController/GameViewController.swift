//
//  GameViewController.swift
//  AngryBirdsADP
//
//  Created by Rostislav Babáček on 10/10/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import SnapKit

protocol SceneManagerDelegate: class {
    func presentGameSceneFor(level: Int)
    func presentLevelScene()
}

final class GameViewController: UIViewController {
    private weak var scoreLabel: UILabel?
    private weak var backButton: UIButton!
    private weak var nextButton: UIButton!
    private weak var menuButton: UIButton!
    private var sceneOperations: SceneOperations?
    private weak var currentGamescene: GameScene!
    private var score: Int = 0 {
        didSet {
            scoreLabel?.text = "Score: \(score)"
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        GameModel.shared.controllerDelegate = self
        GameModel.shared.observer = self
        
        let sceneOperations = SceneOperations()
        self.sceneOperations = sceneOperations
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentLevelScene()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: SceneManagerDelegate {
    func presentLevelScene() {
        let levelScene = LevelScene()
        levelScene.sceneManagerDelegate = self
        present(scene: levelScene)
    }
    
    func presentGameSceneFor(level: Int) {
        let sceneName = "GameScene_\(level)"
        if let gameScene = SKScene(fileNamed: sceneName) as? GameScene {
            GameModel.shared.restartGame()
            
            currentGamescene = gameScene
            gameScene.sceneManagerDelegate = self
            
            present(scene: gameScene)
            
            GameModel.shared.setupScene(scene: gameScene)
            if level == 1 {
                let levelData = Level1()
                GameModel.shared.factory = NormalBirdsFactory()
                GameModel.shared.buildMap(builder: GameBuilder(newBlocks: levelData.blocks, newEnemies: levelData.enemies))
            } else {
                let levelData = Level2()
                GameModel.shared.factory = SpaceBirdsFactory()
                GameModel.shared.buildMap(builder: GameBuilder(newBlocks: levelData.blocks, newEnemies: levelData.enemies))
            }
            
            let label = UILabel()
            label.textColor = .white
            label.text = "Score: 0"
            gameScene.view!.addSubview(label)
            
            label.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(20)
                make.trailing.equalToSuperview().inset(20)
            }
            scoreLabel = label
            
            let menuButton = UIButton(type: .system)
            menuButton.setImage(UIImage.init(named: "menu"), for: .normal)
            gameScene.view?.addSubview(menuButton)
            menuButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
            self.menuButton = menuButton
            
            menuButton.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(20)
                make.leading.equalToSuperview().inset(20)
            }
            
            let backButton = UIButton(type: .system)
            backButton.setImage(UIImage.init(named: "back"), for: .normal)
            gameScene.view?.addSubview(backButton)
            self.backButton = backButton
            backButton.addTarget(self, action: #selector(restoreRound), for: .touchUpInside)
            
            backButton.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(20)
                make.leading.equalTo(menuButton.snp.trailing).offset(10)
            }
            
            let nextButton = UIButton(type: .system)
            nextButton.setImage(UIImage.init(named: "next"), for: .normal)
            gameScene.view?.addSubview(nextButton)
            self.nextButton = nextButton
            nextButton.addTarget(self, action: #selector(nextRound), for: .touchUpInside)
            
            nextButton.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(20)
                make.leading.equalTo(backButton.snp.trailing).offset(10)
            }
        }
    }
    
    @objc
    private func showMenu() {
        presentLevelScene()
        backButton.isHidden = true
        menuButton.isHidden = true
    }
    
    @objc
    private func nextRound(_ sender: UIButton) {
        sceneOperations?.setNewBird()
    }
    
    @objc
    private func restoreRound(_ sender: UIButton) {
        sceneOperations?.stepBack()
    }
    
    func present(scene: SKScene) {
        view.subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        if let view = self.view as! SKView? {
            if let gestureRecognizers = view.gestureRecognizers {
                for recognizer in gestureRecognizers {
                    view.removeGestureRecognizer(recognizer)
                }
            }
            
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
        }
    }
}

extension GameViewController: GameControllerDelegate {
    func updateScore(value: Int) {
        score = value
    }
    
    func gameOver() {
        showMenu()
    }
}

extension GameViewController: PropertyObserver {
    func didChange(propertyType: ObserverTypes, value: Any?) {
        switch propertyType {
        case .score:
            updateScore(value: value as! Int)
        }
    }
}
