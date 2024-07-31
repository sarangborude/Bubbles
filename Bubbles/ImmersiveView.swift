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
    
    @State private var bubble = Entity()
    
    let bubbleCount = 50
    
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "BubbleScene", in: realityKitContentBundle) {
                
                
                bubble = immersiveContentEntity.findEntity(named: "Bubble")!
                
                for _ in 1...bubbleCount {
                    var bubbleClone = bubble.clone(recursive: true)
                    let x = Float.random(in: -1.5...1.5)
                    let y = Float.random(in: 1...1.5)
                    let z = Float.random(in: -1.5...1.5)
                    bubbleClone.position = [x, y, z]
      
                    /// Uncomment the code below if you want to enable the system to move the bubbles.
                    ///
                    /// Also uncomment the register system line in BubblesApp file
//                    guard var bubbleComponent = bubbleClone.components[BubbleComponent.self] else { return }
//                    bubbleComponent.direction = [
//                        Float.random(in: -1...1),
//                        Float.random(in: -1...1),
//                        Float.random(in: -1...1)
//                    ]
//                    bubbleClone.components[BubbleComponent.self] = bubbleComponent
                    
                    // comment out addind the pb and pm  when you want to enable the system
                    
                    var pb = PhysicsBodyComponent()
                    pb.isAffectedByGravity = false
                    pb.linearDamping = 0
                    
                    let linearVelX = Float.random(in: -0.05...0.05)
                    let linearVelY = Float.random(in: -0.05...0.05)
                    let linearVelZ = Float.random(in: -0.05...0.05)
                    
                    var pm = PhysicsMotionComponent(linearVelocity: [linearVelX, linearVelY, linearVelZ])
                    
                    bubbleClone.components[PhysicsBodyComponent.self] = pb
                    bubbleClone.components[PhysicsMotionComponent.self] = pm
                    
                    content.add(bubbleClone)
                }
                                
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
