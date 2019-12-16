//
//  GameScene.swift
//  AngryBirdsADP
//
//  Created by Rostislav Babáček on 10/10/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import SpriteKit
import GameplayKit

extension SKNode {
    func aspectScale(to size: CGSize, width: Bool, multiplier: CGFloat) {
        let scale = width ? (size.width * multiplier) / self.frame.size.width : (size.height * multiplier) / self.frame.size.height
        self.setScale(scale)
    }
}

enum RoundState {
    case ready, flying, finished, gameOver
}

final class GameScene: SKScene, GameObjectVisitor {
    var sceneManagerDelegate: SceneManagerDelegate?
    
    private var mapNode = SKTileMapNode()
    private var panRecognizer = UIPanGestureRecognizer()
    private var maxScale: CGFloat = 0
    
    private var slingshot: SKSpriteNode?
    private var enemyArray: [SKSpriteNode] = [SKSpriteNode]()
    private var birdArray: [SKSpriteNode] = [SKSpriteNode]()
    private var currentBird: SKNode!
    private var blocks: [SKSpriteNode] = [SKSpriteNode]()
    
    private var enemies = 0 {
        didSet {
            if enemies < 1 {
                roundState = .gameOver
            }
        }
    }
    
    private let anchor = SKNode()
    private var roundState = RoundState.ready
    
    // MARK: - Scene states
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        physicsWorld.contactDelegate = self
        roundState = .ready
        GameModel.shared.delegate = self

        setupLevel()
        setupGestureRecognizers()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(GameModel.shared.score)
        switch roundState {
        case .ready:
            if let touch = touches.first {
                let location = touch.location(in: self)
                if birdArray[0].contains(location) {
                    GameModel.shared.getReadyBird()
                }
                panRecognizer.isEnabled = false
            }
        case .flying:
            break
        case .finished:
            
            blocks.enumerated().forEach {
                GameModel.shared.setBlockPosition(on: $0.element.position, with: $0.element.zRotation, index: $0.offset)
            }
            
            enemyArray.enumerated().forEach {
                GameModel.shared.setEnemyPosition(on: $0.element.position, index: $0.offset)
            }
            
            addBird()
        case .gameOver:
            break
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            guard let bird = birdArray.first else { return }
            guard let birdNodeName = bird.name else { return }
            if GameModel.shared.isBirdGrabbed(name: birdNodeName) {
                let location = touch.location(in: self)
                GameModel.shared.setBirdPosition(on: location, name: birdNodeName)
                bird.position = location
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if GameModel.shared.getBird()?.isGrabbed() ?? false {
            roundState = .flying
            constraintToAnchor(active: false)
            GameModel.shared.slingshotFire(location: CGPoint(x: anchor.position.x, y: anchor.position.y))
        }
    }
    
    // MARK: - Setup helpers
    
    func setupGestureRecognizers() {
        guard let view = view else { return }
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan))
        view.addGestureRecognizer(panRecognizer)
    }
    
    func setupLevel() {
        if let mapNode = childNode(withName: "Tile Map Node") as? SKTileMapNode {
            self.mapNode = mapNode
            maxScale = mapNode.mapSize.width/frame.size.width
        }
        
        for child in mapNode.children {
            if let child = child as? SKSpriteNode {
                guard let name = child.name else { continue }
                switch name {
                case "wood","stone","glass":
                    print("ObjectConfiguration(size: CGSize(width: \(child.size.width), height: \(child.size.height)), position: CGPoint(x: \(child.position.x), y: \(child.position.y)), zRotation: \(child.zRotation), name: \"\(name)\"),")
                    child.removeFromParent()
                case "enemy":
                     print("ObjectConfiguration(size: CGSize(width: \(child.size.width), height: \(child.size.height)), position: CGPoint(x: \(child.position.x), y: \(child.position.y)), zRotation: \(child.zRotation), name: \"\(name)\"),")
                    child.removeFromParent()
                default:
                    break
                }
            }
        }
        
        let physicsRect = CGRect(x: 0, y: mapNode.tileSize.height, width: mapNode.frame.size.width, height: mapNode.frame.size.height-mapNode.tileSize.height)
        physicsBody = SKPhysicsBody(edgeLoopFrom: physicsRect)
        physicsBody?.categoryBitMask = PhysicsCategory.edge
        physicsBody?.contactTestBitMask = PhysicsCategory.bird | PhysicsCategory.block
        physicsBody?.collisionBitMask = PhysicsCategory.all
        
        anchor.position = CGPoint(x: mapNode.frame.midX/2, y: mapNode.frame.midY/2 + 30)
        addChild(anchor)
    }

    
    // MARK: - Add methods
    func addBird() {
        for it in birdArray {
            it.removeFromParent()
            GameModel.shared.removeBird(name: it.name ?? "")
        }
        birdArray.removeAll()
        roundState = .finished
        panRecognizer.isEnabled = true
        
        GameModel.shared.createBird()
    }
    
    
    // MARK: - Visit methods
    
    func visit(block: Block) {
        let texture = SKTexture(imageNamed: "woodBlock")
        let blockNode = SKSpriteNode(texture: texture, color: .clear, size: block.size)
        blockNode.name = block.name
            
        blockNode.zPosition = ZPosition.gameObjects
        blockNode.physicsBody = SKPhysicsBody(rectangleOf: blockNode.size)
        blockNode.physicsBody?.isDynamic = true
        blockNode.physicsBody?.categoryBitMask = PhysicsCategory.block
        blockNode.physicsBody?.contactTestBitMask = PhysicsCategory.all
        blockNode.physicsBody?.collisionBitMask = PhysicsCategory.all
        blockNode.position = block.position
        blockNode.zRotation = block.zRotation
        
        mapNode.addChild(blockNode)
        blocks.append(blockNode)
    }
    
    func visit(enemy: Enemy) {
        let texture = SKTexture(imageNamed: enemy.name)
        let enemyNode = SKSpriteNode(texture: texture, color: UIColor.clear, size: texture.size())

        enemyNode.zPosition = ZPosition.gameObjects
        enemyNode.physicsBody = SKPhysicsBody(rectangleOf: enemyNode.size)
        enemyNode.physicsBody?.isDynamic = true
        enemyNode.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        enemyNode.physicsBody?.contactTestBitMask = PhysicsCategory.all
        enemyNode.physicsBody?.collisionBitMask = PhysicsCategory.all
        enemyNode.position = enemy.position
        
        mapNode.addChild(enemyNode)
        enemyArray.append(enemyNode)
    }
    
    func visit(bird: Bird) {
        let texture = SKTexture(imageNamed: bird.birdType.texture)
        let birdNode = SKSpriteNode(texture: texture, color: UIColor.clear, size: CGSize(width: 50, height: 50))
        birdNode.name = bird.name
        
        if bird.name != "birdTwin" {
            roundState = .ready
        }
        
        birdNode.physicsBody = SKPhysicsBody(rectangleOf: birdNode.size)
        birdNode.physicsBody?.categoryBitMask = PhysicsCategory.bird
        birdNode.physicsBody?.contactTestBitMask = PhysicsCategory.all
        birdNode.physicsBody?.collisionBitMask = PhysicsCategory.block | PhysicsCategory.edge
        birdNode.physicsBody?.isDynamic = false
        birdNode.physicsBody?.affectedByGravity = bird.hasGravity()
        birdNode.zPosition = ZPosition.bird
        birdNode.position = anchor.position
        
        mapNode.addChild(birdNode)
        birdArray.append(birdNode)
        
        GameModel.shared.setBirdPosition(on: anchor.position, name: bird.name)
    }
    
    func visit(slingshot: RealSlingshot) {
        let texture = SKTexture(imageNamed: slingshot.name)
        let slingshotNode = SKSpriteNode(texture: texture, color: UIColor.clear, size: slingshot.size)
        slingshotNode.zPosition = ZPosition.gameObjects
        slingshotNode.position = CGPoint(x: anchor.position.x, y: mapNode.tileSize.height + 70)
        
        mapNode.addChild(slingshotNode)
        self.slingshot = slingshotNode
        
        GameModel.shared.setSlingshotPosition(on: position)
    }
    
    func visit(camera: Camera) {
        addChild(camera)
        
        GameModel.shared.setCameraPosition(position: position, camera: camera)
    }
    
    func constraintToAnchor(active: Bool) {
        if active {
            let slingRange = SKRange(lowerLimit: 0.0, upperLimit: ((birdArray.first?.size.width ?? 0)*3))
            let positionConstraint = SKConstraint.distance(slingRange, to: anchor)
            birdArray[0].constraints = [positionConstraint]
        } else {
            birdArray[0].constraints?.removeAll()
        }
    }
    
    override func didSimulatePhysics() {
        if birdArray.count > 0 && roundState == .flying {
            if birdArray.allSatisfy({ node -> Bool in
                return node.physicsBody?.isResting ?? false
            }) { roundState = .finished }
        }
    }
}

// MARK: - Extensions
extension GameScene: GameModelDelegate {
    func setSlingshotPosition(position: CGPoint) {
        slingshot?.position = position
    }
    
    func removeBird(name: String) {
        
    }
    
    func removeBlock(name: String) {
        guard let blockNodeIndex = blocks.firstIndex(where: { blockNode -> Bool in
            blockNode.name == name
        }) else { return }
        blocks[blockNodeIndex].removeFromParent()
        blocks.remove(at: blockNodeIndex)
    }
    
    func removeEnemy(index: Int) {
        enemyArray[index].removeFromParent()
        enemyArray.remove(at: index)
    }
    
    func clearMap() {
        _ = enemyArray.map { $0.removeFromParent() }
        enemyArray.removeAll()
        _ = blocks.map { $0.removeFromParent() }
        blocks.removeAll()
        _ = birdArray.map { $0.removeFromParent() }
        birdArray.removeAll()
    }
    
    func gameOver() {
        roundState = .gameOver
    }
    
    func birdFly(name: String, vector: CGVector, gravity: Bool) {
        let bird = birdArray.first { node -> Bool in
            return node.name == name
        }
        
        guard let sceneBird = bird else { return }
        sceneBird.physicsBody?.isDynamic = true
        sceneBird.physicsBody?.affectedByGravity = gravity
        sceneBird.physicsBody?.applyImpulse(vector)
        sceneBird.isUserInteractionEnabled = false
    }
    
    func nextBird() {
        roundState = .finished
        addBird()
    }
}

// MARK: Contacts
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let mask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch mask {
        case PhysicsCategory.bird | PhysicsCategory.block:
            if let block = contact.bodyB.node as? SKSpriteNode, let _ = blocks.firstIndex(of: block) {
                GameModel.shared.damageToBlock(name: block.name ?? "", impact: Int(contact.collisionImpulse))
            } else if let block = contact.bodyA.node as? SKSpriteNode, let _ = blocks.firstIndex(of: block) {
                GameModel.shared.damageToBlock(name: block.name ?? "", impact: Int(contact.collisionImpulse))
            }
            
            if let bird = contact.bodyA.node as? SKSpriteNode, let birdIndex = birdArray.firstIndex(of: bird) {
                GameModel.shared.stopBird(with: birdArray[birdIndex].name ?? "")
            } else if let bird = contact.bodyB.node as? SKSpriteNode, let birdIndex = birdArray.firstIndex(of: bird) {
                GameModel.shared.stopBird(with: birdArray[birdIndex].name ?? "")
            }
        case PhysicsCategory.bird | PhysicsCategory.edge:
            if let bird = contact.bodyA.node as? SKSpriteNode, let birdIndex = birdArray.firstIndex(of: bird) {
                GameModel.shared.stopBird(with: birdArray[birdIndex].name ?? "")
            } else if let bird = contact.bodyB.node as? SKSpriteNode, let birdIndex = birdArray.firstIndex(of: bird) {
                GameModel.shared.stopBird(with: birdArray[birdIndex].name ?? "")
            }
        case PhysicsCategory.bird | PhysicsCategory.enemy:
            
            if let enemy = enemyArray.firstIndex(of: contact.bodyA.node as! SKSpriteNode) {
                GameModel.shared.damageToEnemy(index: enemy, impact: Int(contact.collisionImpulse))
            } else if let enemy = enemyArray.firstIndex(of: contact.bodyB.node as! SKSpriteNode) {
                GameModel.shared.damageToEnemy(index: enemy, impact: Int(contact.collisionImpulse))
            }
            
            if let bird = contact.bodyA.node as? SKSpriteNode, let birdIndex = birdArray.firstIndex(of: bird) {
                GameModel.shared.stopBird(with: birdArray[birdIndex].name ?? "")
            } else if let bird = contact.bodyB.node as? SKSpriteNode, let birdIndex = birdArray.firstIndex(of: bird) {
                GameModel.shared.stopBird(with: birdArray[birdIndex].name ?? "")
            }
        default:
            break
        }
    }
}

extension GameScene {
    @objc func pan(sender: UIPanGestureRecognizer) {
        guard let view = view else { return }
        guard let camera = GameModel.shared.getCamera() else { return }
        let translation = sender.translation(in: view) * camera.yScale
        camera.position = CGPoint(x: camera.position.x - translation.x, y: camera.position.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
}
