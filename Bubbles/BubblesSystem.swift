//
//  BubblesSystem.swift
//  Bubbles
//
//  Created by Sarang Borude on 7/27/24.
//

import RealityKit
import RealityKitContent

class BubblesSystem: System {
    let query = EntityQuery(where: .has(BubbleComponent.self))
    let speed: Float = 0.0001
    
    required init(scene: Scene) {
        
    }
    
    func update(context: SceneUpdateContext) {
        context.scene.performQuery(query).forEach { bubble in
            guard let bubbleComponent = bubble.components[BubbleComponent.self] else {return}
            
            bubble.position += bubbleComponent.direction * speed
        }
    }
}
