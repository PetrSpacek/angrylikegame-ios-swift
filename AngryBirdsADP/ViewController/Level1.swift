//
//  Level1.swift
//  AngryBirdsADP
//
//  Created by Rostislav Babáček on 24/11/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import SpriteKit

struct Level1 {
    var blocks: [ObjectConfiguration] = [
        ObjectConfiguration(size: CGSize(width: 78.0, height: 35.0), position: CGPoint(x: 501.0002746582031, y: 67.68267822265625), zRotation: 1.5707963705062866, name: "A", health: 100),
        ObjectConfiguration(size: CGSize(width: 78.0, height: 35.0), position: CGPoint(x: 641.0372924804688, y: 68.53501892089844), zRotation: 1.5707963705062866, name: "B", health: 100),
        ObjectConfiguration(size: CGSize(width: 78.0, height: 35.0), position: CGPoint(x: 500.63299560546875, y: 144.95147705078125), zRotation: -1.5707963705062866, name: "C", health: 100),
        ObjectConfiguration(size: CGSize(width: 81.0, height: 38.0), position: CGPoint(x: 639.1559448242188, y: 147.11727905273438), zRotation: -1.5707963705062866, name: "D", health: 100),
        ObjectConfiguration(size: CGSize(width: 80.0, height: 39.0), position: CGPoint(x: 568.9080810546875, y: 48.26493835449219), zRotation: -3.1415927410125732, name: "E", health: 100),
        ObjectConfiguration(size: CGSize(width: 77.83203887939453, height: 39.0), position: CGPoint(x: 566.8956298828125, y: 243.40380859375), zRotation: 3.1415927410125732, name: "F", health: 80),
        ObjectConfiguration(size: CGSize(width: 77.83203887939453, height: 39.0), position: CGPoint(x: 500.35357666015625, y: 203.7181396484375), zRotation: -3.1415927410125732, name: "G", health: 80),
        ObjectConfiguration(size: CGSize(width: 80.0, height: 39.0), position: CGPoint(x: 633.34912109375, y: 204.35540771484375), zRotation: 0.0, name: "H", health: 150)
    ]

    var enemies: [ObjectConfiguration] = [
        ObjectConfiguration(size: CGSize(width: 50.0, height: 38.0), position: CGPoint(x: 568.6444702148438, y: 103.82498931884766), zRotation: 0.0, name: "enemy", health: 100),
        ObjectConfiguration(size: CGSize(width: 50.0, height: 38.0), position: CGPoint(x: 590.6444702148438, y: 103.82498931884766), zRotation: 0.0, name: "enemy", health: 100)
    ]
}
