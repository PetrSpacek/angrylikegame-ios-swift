//
//  BirdStrategy.swift
//  AngryBirdsADP
//
//  Created by Rostislav Babáček on 09/11/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import SpriteKit

protocol BirdStrategy {
    func fly(_ bird: Bird, impulse: CGVector)
}

class SpaceBird: BirdStrategy {
    func fly(_ bird: Bird, impulse: CGVector) {
        bird.delegate?.birdFly(bird, impulse: impulse, gravity: false)
    }
}

class EarthBird: BirdStrategy {
    func fly(_ bird: Bird, impulse: CGVector) {
        bird.delegate?.birdFly(bird, impulse: impulse, gravity: true)
    }
}
