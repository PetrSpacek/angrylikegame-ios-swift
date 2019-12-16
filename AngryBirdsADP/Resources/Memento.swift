//
//  Mementi.swift
//  AngryBirdsADP
//
//  Created by Rostislav Babáček on 21/11/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import UIKit

typealias Memento = [String: Any]

protocol MementoConvertible {
    var memento: Memento { get }
    init?(memento: Memento)
}

struct GameState: MementoConvertible {
    private enum Keys {
        static let enemy = "enemy"
        static let score = "score"
        static let block = "block"
        static let birds = "birds"
        static let slingshotState = "slingshotState"
    }

    var birds: [BirdConfiguration]
    var block: [ObjectConfiguration]
    var enemy: [ObjectConfiguration]
    var score: Int
    var slingshotState: SlingshotState

    init(birds: [BirdConfiguration], block: [ObjectConfiguration], enemy: [ObjectConfiguration], slingshotState: SlingshotState, score: Int) {
        self.birds = birds
        self.enemy = enemy
        self.score = score
        self.slingshotState = slingshotState
        self.block = block
    }

    init?(memento: Memento) {
        birds = memento[Keys.birds] as! [BirdConfiguration]
        enemy = memento[Keys.enemy] as! [ObjectConfiguration]
        score = memento[Keys.score] as! Int
        block = memento[Keys.block] as! [ObjectConfiguration]
        slingshotState = memento[Keys.slingshotState] as! SlingshotState
    }

    var memento: Memento {
        return [ Keys.enemy: enemy, Keys.score: score, Keys.block: block, Keys.birds: birds, Keys.slingshotState: slingshotState ]
    }
}

enum Caretaker {
    static func save(_ state: MementoConvertible) {
        GameModel.shared.levelHistory.append(state.memento)
    }

    static func restore() -> Any? {
        return GameModel.shared.levelHistory.popLast() ?? nil
    }
}
