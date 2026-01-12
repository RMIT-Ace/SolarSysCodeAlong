//
//  RotationSystem.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 16/9/2025.
//

import Foundation
import RealityKit

struct RotationSystem: System {
    static let query = EntityQuery(where: .has(RotationComponent.self))
    
    init(scene: Scene) { }
    
    func update(context: SceneUpdateContext) {
        for entity in context.scene.performQuery(Self.query) {
            guard let rotationComponent = entity.components[RotationComponent.self] else { continue }
            
            let rotationAngle = rotationComponent.rotationSpeed * Float(context.deltaTime)
            let rotation = simd_quatf(angle: rotationAngle, axis: rotationComponent.rotationAxis)
            entity.transform.rotation *= rotation
        }
    }
}
