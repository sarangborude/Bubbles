//
//  ImmersiveView.swift
//  Bubbles
//
//  Created by Sarang Borude on 7/21/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    // This Query predicate is to look for any entities that have a model component. In the Bubble Scene, only the bubbles have model component.
    @State private var predicate = QueryPredicate<Entity>.has(ModelComponent.self)
    
    @State private var timer: Timer?
    
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "BubbleScene", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)
            }
        }
        .gesture(SpatialTapGesture().targetedToEntity(where: predicate).onEnded({ value in
            let entity = value.entity
            
            // Get the bubble material from the model component of the bubble entity
            var mat = entity.components[ModelComponent.self]?.materials.first as! ShaderGraphMaterial
            
            let frameRate: TimeInterval = 1.0/60.0 // 60FPS
            let duration: TimeInterval = 0.25
            let targetValue: Float = 1
            let totalFrames = Int(duration / frameRate)
            var currentFrame = 0
            var popValue: Float = 0
            
            timer?.invalidate()
            
            // The timer updates the popValue each time it fires.
            timer = Timer.scheduledTimer(withTimeInterval: frameRate, repeats: true, block: { timer in
                currentFrame += 1
                let progress = Float(currentFrame) / Float(totalFrames)
                
                popValue = progress * targetValue
                
                // set the parameter value and then assign the material back to the model component
                do {
                    try mat.setParameter(name: "Pop", value: .float(popValue))
                    entity.components[ModelComponent.self]?.materials = [mat]
                }
                catch {
                    print(error.localizedDescription)
                }
                
                if currentFrame >= totalFrames {
                    timer.invalidate()
                    entity.removeFromParent()
                }
            })
        }))
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
