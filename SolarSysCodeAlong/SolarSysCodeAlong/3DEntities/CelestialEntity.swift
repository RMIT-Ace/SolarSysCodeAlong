//
//  CelestialEntity.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 16/9/2025.
//

import Foundation
import RealityKit

/// Represent planets or stars. A body that rotates around itself and
/// orbits around its parent (i.e. Sun).
///
class CelestialEntity: Entity {
    
    required init() {
        super.init()
    }
    
    required init?(
        bundle: Bundle = .main,
        name: String,
        scale: Float = 1.0,
        distanceFromCenter: Float) async
    {
        super.init()
        
        guard let url = bundle.url(forResource: name, withExtension: "usdz"),
              let celestialObj = try? await ModelEntity(contentsOf: url) else {
            print("ERROR: loading model")
            return nil
        }
        // MainBody - Container for pivoting/orbiting.
        self.name = name
        celestialObj.name = "MainBody"
        celestialObj.transform = Transform(
            scale: SIMD3(repeating: scale),
            translation: .init(x: distanceFromCenter, y: 0, z: 0)
        )
        super.addChild(celestialObj)
        
        // For adding children. No Visual appearance..
        let nonRotatingMainBody = Entity()
        nonRotatingMainBody.name = "NonRotatingMainBody"
        nonRotatingMainBody.transform = Transform(
            translation: .init(x: distanceFromCenter, y: 0, z: 0)
        )
        super.addChild(nonRotatingMainBody)
    }
    
    func updateRotation(speed: Float) async {
        guard let entity = findEntity(named: name),
              let firstChild = entity.findEntity(named: "MainBody") else {
            print("ERROR: failed to find entity with name: \(name)")
            return
        }
        firstChild.components[RotationComponent.self] = RotationComponent(
            rotationSpeed: speed,
            rotationAxis: [0, 1, 0 ]
        )
    }
    
    func updateOrbit( speed: Float) async {
        components[RotationComponent.self] = RotationComponent(
            rotationSpeed: speed,
            rotationAxis: [0, 1, 0]
        )
    }
    
    /// Add and entity to the main body, not the pivot-point body.
    func addChild(_ child: Entity) {
        guard let mainBody = findEntity(named: "NonRotatingMainBody") else {
            print("WARN: Entity \(name) does not have main body.")
            super.addChild(child)
            return
        }
        
        mainBody.addChild(child)
    }
}
