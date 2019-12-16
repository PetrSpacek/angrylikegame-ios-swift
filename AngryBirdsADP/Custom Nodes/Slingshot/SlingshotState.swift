//
//  SlingshotState.swift
//  AngryBirdsADP
//
//  Created by Rostislav Babáček on 10/11/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import SpriteKit

protocol SlingshotState {
    func fire(bird: Bird, from slingshot: RealSlingshot, to location: CGPoint)
}

class SingleSlingshotState: SlingshotState {
    /// Fires given bird from given slingshot to given location
    /// - Parameters:
    ///   - bird: given bird
    ///   - slingshot: given slingshot
    ///   - location: given location
    func fire(bird: Bird, from slingshot: RealSlingshot, to location: CGPoint) {
        bird.fly(to: location)
    }
}

class DoubleSlingshotState: SlingshotState {
    /// Fires given bird and his twin from given slingshot to given location
    /// - Parameters:
    ///   - bird: given bird
    ///   - slingshot: given slingshot
    ///   - location: given location
    func fire(bird: Bird, from slingshot: RealSlingshot, to location: CGPoint) {
        let birdSecond = GameModel.shared.factory?.createBird(name: "birdTwin", type: bird.birdType)
        birdSecond?.position = bird.position
        birdSecond?.delegate = bird.delegate
        birdSecond?.accept(visitor: GameModel.shared.scene)
        bird.fly(to: location)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
           birdSecond?.fly(to: location)
        }
    }
}
