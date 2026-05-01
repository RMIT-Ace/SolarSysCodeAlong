//
//  ContentView.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 15/9/2025.
//

// Beginner-01
// 1) Put basic entity (sphere) in your real world.
// 2) Create more spheres of various:
//      - sizes
//      - colors
//      - position (x, y, z)

import SwiftUI
import RealityKit

struct SolarSysCodeAlongView: View {
    var body: some View {
        RealityView { content in
            content.camera = .spatialTracking
            
            // Red sphere at center
            let redSphereEntity = ModelEntity(
                mesh: .generateSphere(radius: 0.25),
                materials: [SimpleMaterial(color: .red, isMetallic: true)]
            )
            content.add(redSphereEntity)
            
            // Blue sphere at center
            let blueSphereEntity = ModelEntity(
                mesh: .generateSphere(radius: 0.1),
                materials: [SimpleMaterial(color: .blue, isMetallic: true)]
            )
            blueSphereEntity.position = SIMD3(0, 0, -1)
            content.add(blueSphereEntity)
        }
        .ignoresSafeArea()
        
        
    }
}

#Preview {
    SolarSysCodeAlongView()
}
