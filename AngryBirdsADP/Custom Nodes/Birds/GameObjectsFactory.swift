//
//  GameObjectsFactory.swift
//  AngryBirdsADP
//
//  Created by Rostislav Babáček on 09/11/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import Foundation

protocol GameObjectsFactory {
    func createBird(name: String, type: BirdType) -> Bird
}

final class NormalBirdsFactory: GameObjectsFactory {
    func createBird(name: String, type: BirdType) -> Bird {
        return Bird(name: name, type: type, strategy: EarthBird())
    }
}

final class SpaceBirdsFactory: GameObjectsFactory {
    func createBird(name: String, type: BirdType) -> Bird {
        return Bird(name: name, type: type, strategy: SpaceBird())
    }
}
