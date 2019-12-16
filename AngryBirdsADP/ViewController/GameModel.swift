//
//  GameModel.swift
//  AngryBirdsADP
//
//  Created by Rostislav Babáček on 22/10/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import SpriteKit

struct ObjectConfiguration {
    let size: CGSize
    let position: CGPoint
    let zRotation: CGFloat
    let name: String
    let health: Int
}

struct BirdConfiguration {
    let name: String
    let type: BirdType
}

protocol GameModelDelegate {
    func gameOver()
    func removeBird(name: String)
    func removeBlock(name: String)
    func removeEnemy(index: Int)
    func setSlingshotPosition(position: CGPoint)
    func birdFly(name: String, vector: CGVector, gravity: Bool)
    func clearMap()
    func nextBird()
}

protocol GameControllerDelegate {
    func updateScore(value: Int)
    func gameOver()
}

enum ObserverTypes {
    case score
}

protocol PropertyObserver : class {
    func didChange(propertyType: ObserverTypes, value: Any?)
}

@objc final class GameModel: NSObject {
    static let shared: GameModel = GameModel()
    
    var delegate: GameModelDelegate?
    var controllerDelegate: GameControllerDelegate?
    weak var observer: PropertyObserver?
    
    var scene: GameScene!
    // MARK: - Game objects
    private var blockArray = [Block]()
    private var enemyArray = [Enemy]()
    private var birdArray = [Bird]()
    private var bird: Bird?
    private var slingshot: ProxySlingshot!
    private var gameCamera: GameCamera?
    // MARK: - Factory
    var factory: GameObjectsFactory?
    // MARK: - Memento
    var levelHistory = [Memento]()
    
    var birds = [BirdConfiguration]()
    var score: Int = 0 {
        didSet {
            observer?.didChange(propertyType: .score, value: score)
        }
    }
    
    private override init() {}
    
    func setupScene(scene: GameScene) {
        self.scene = scene
        createSlingshot()
        createCamera()
    }
    
    func buildMap(builder: GameBuilder) {
        setupBlocks(blocks: builder.buildBlocks())
        createEnemy(enemies: builder.newEnemies)
        birds = builder.birds
        
        createBird()
    }
    
    func restartGame() {
        blockArray.removeAll()
        enemyArray.removeAll()
        birdArray.removeAll()
        birds.removeAll()
        score = 0
    }
    
    func setupBlocks(blocks: [Block]) {
        self.blockArray = blocks
        _ = blocks.map {
            $0.delegate = self
            $0.accept(visitor: scene)
        }
    }
    
    func createEnemy(enemies: [ObjectConfiguration]) {
        // MARK: Prototype pattern
        let prototype = Enemy()
        prototype.delegate = self
        
        for objectConfiguration in enemies {
            let enemy = prototype.clone()
            enemy.setPosition(position: objectConfiguration.position)
            enemy.name = objectConfiguration.name
            enemy.health = objectConfiguration.health
            enemy.accept(visitor: scene)
            enemyArray.append(enemy)
        }
    }

    // MARK: - Bird Helpers
    func createBird() {
        if birds.isEmpty {
            controllerDelegate?.gameOver()
            return
        }
        
        guard let birdConfiguration = birds.first else { return }
        let bird = factory?.createBird(name: birdConfiguration.name, type: birdConfiguration.type)
        bird?.delegate = self
        birdArray.append(bird!)
        self.bird = bird
        bird?.accept(visitor: scene)
    }

    func setBirdPosition(on position: CGPoint, name: String) {
        guard let bird = getBirdByName(name: name) else { return }
        return bird.setPosition(position: position)
    }
    
    func isBirdGrabbed(name: String) -> Bool {
        guard let bird = getBirdByName(name: name) else { return false }
        return bird.isGrabbed()
    }
    
    func stopBird(with name: String) {
        guard let bird = birdArray.first(where: {$0.name == name}) else { return }
        bird.setFlying(false)
    }
    
    func getReadyBird() {
        bird?.getReady()
    }
    
    func removeBird(name: String) {
        guard let bird = getBirdByName(name: name) else { return }
        guard let birdIndex = birdArray.firstIndex(of: bird) else { return }
        birdArray.remove(at: birdIndex)
    }
    
    func isBirdFlying(name: String) -> Bool {
        return birdArray.first { bird -> Bool in
            bird.name == name
            }?.isFlying() ?? false
    }
    
    func getBirdByName(name: String) -> Bird? {
        return birdArray.first { bird -> Bool in
            bird.name == name
        }
    }
    
    func getBird() -> Bird? {
        return bird
    }
    
    func nextBird() {
        delegate?.nextBird()
    }
    // MARK: - Enemy Helpers
    
    func setEnemyPosition(on position: CGPoint, index: Int) {
        enemyArray[index].setPosition(position: position)
    }
    
    func damageToEnemy(index: Int, impact: Int) {
        enemyArray[index].impact(to: index, with: impact)
    }
    // MARK: - Slingshot Helpers
    
    func createSlingshot() {
        let slingshot = ProxySlingshot()
        self.slingshot = slingshot
        slingshot.accept(visitor: scene)
    }
    
    func setSlingshotPosition(on position: CGPoint) {
        self.slingshot?.setPosition(position: position)
    }
    
    func slingshotFire(location: CGPoint) {
        saveState()
        
        birds.remove(at: 0)
        slingshot?.shoot(location: location, bird: bird!)
    }
    
    // MARK: - Camera Helpers
    
    func createCamera() {
        let gameCamera = Camera()
        self.gameCamera = gameCamera
        gameCamera.accept(visitor: scene)
    }
    
    func setCameraPosition(position: CGPoint, camera: Camera) {
        camera.setPosition(position: position)
    }
    
    func getCamera() -> GameCamera? {
        return gameCamera
    }
    
    // MARK: - Block Helpers
    
    func getBlockByName(name: String) -> Block? {
        return blockArray.first { block -> Bool in
            block.name == name
        }
    }
    
    func damageToBlock(name: String, impact: Int) {
        guard let block = getBlockByName(name: name) else { return }
        block.impact(with: impact)
    }
    
    func setBlockPosition(on position: CGPoint, with zRotation: CGFloat, index: Int) {
        blockArray[index].setPosition(position: position)
        blockArray[index].setRotation(zRotation: zRotation)
     }
    
    // MARK: - Score Helpers
    
    func addScore(value: Int) {
        score += value
    }
    
    // MARK: - Memento
    
    func saveState() {
        let enemies = enemyArray.map { $0.getConfiguration() }
        let block = blockArray.map { $0.getConfiguration() }
        
        let gameState = GameState(birds: birds, block: block, enemy: enemies, slingshotState: slingshot.getState(), score: score)
        Caretaker.save(gameState)
    }
    
    func loadState() {
        if let memento = Caretaker.restore() as? Memento {
            guard let restoredState = GameState(memento: memento) else { return }
            enemyArray.removeAll()
            blockArray.removeAll()
            delegate?.clearMap()
            
            if restoredState.slingshotState is DoubleSlingshotState {
                slingshot.doubleShoot()
            }
            
            let builder = GameBuilder(newBlocks: restoredState.block, newEnemies: restoredState.enemy)
            builder.birds = restoredState.birds
            score = restoredState.score
            
            buildMap(builder: builder)
        }
    }
}

// MARK: - GameModel Extensions
extension GameModel: BirdDelegate {
    func birdFly(_ bird: Bird, impulse: CGVector, gravity: Bool) {
        delegate?.birdFly(name: bird.name, vector: impulse, gravity: gravity)
    }
}

extension GameModel: EnemyDelegate {
    func removeEnemy(_ enemy: Enemy) {
        guard let index = enemyArray.firstIndex(of: enemy) else { return }
        enemyArray.remove(at: index)
        slingshot?.doubleShoot()
        delegate?.removeEnemy(index: index)
        addScore(value: enemy.getScore())
        
        if enemyArray.isEmpty {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.controllerDelegate?.gameOver()
            }
        }
    }
}

extension GameModel: BlockDelegate {
    func blockDestroyed(block: Block) {
        guard let index = blockArray.firstIndex(of: block) else { return }
        blockArray.remove(at: index)
        
        delegate?.removeBlock(name: block.name)
        addScore(value: block.getScore())
    }
}
