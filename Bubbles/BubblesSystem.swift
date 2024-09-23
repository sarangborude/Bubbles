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
    let speed: Float = 0.1// 0.0001
    
    required init(scene: Scene) {
        
    }
    
    func update(context: SceneUpdateContext) {
        
        let entities = context.entities(matching: query, updatingSystemWhen: .rendering)
        
        for bubble in entities  {
            guard let bubbleComponent = bubble.components[BubbleComponent.self] else {return}
            
            bubble.position += bubbleComponent.direction * speed * Float(context.deltaTime)
        }
        
        /// For some reason this make the bubbles stop moving  so the above method works better when updating the system
//        context.scene.performQuery(query).forEach { bubble in
//            guard let bubbleComponent = bubble.components[BubbleComponent.self] else {return}
//            
//            bubble.position += bubbleComponent.direction * speed
//        }
    }
}
