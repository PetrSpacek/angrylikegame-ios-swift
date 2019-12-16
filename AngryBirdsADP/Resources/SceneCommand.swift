//
//  SceneCommand.swift
//  AngryBirdsADP
//
//  Created by Rostislav Babáček on 21/11/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import SpriteKit

protocol SceneCommand {
    func execute()
}

final class SetNewBirdCommand: SceneCommand {
    func execute() {
        GameModel.shared.nextBird()
    }
}

final class StepBackCommand: SceneCommand {
    func execute() {
        GameModel.shared.loadState()
    }
}

final class SceneOperations {
    let setNewBirdCommand: SceneCommand
    let stepBackCommand: SceneCommand
    
    init() {
        setNewBirdCommand = SetNewBirdCommand()
        stepBackCommand = StepBackCommand()
    }
    
    func setNewBird() {
        return setNewBirdCommand.execute()
    }
    
    func stepBack() {
        return stepBackCommand.execute()
    }
}
