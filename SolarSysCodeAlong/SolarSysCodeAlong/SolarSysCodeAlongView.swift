//
//  ContentView.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 15/9/2025.
//

// Beginner-04
// 1) Make them move!

import SwiftUI
import RealityKit

struct SolarSysCodeAlongView: View {
    let trackingSession = SpatialTrackingSession()
    let colors: [SimpleMaterial.Color] = [
        .red, .green, .blue, .brown, .yellow
    ]
    
    let rotationAxises: [SIMD3<Float>] = [
        [1, 0, 0],
        [0, 1, 0],
        [0, 0, 1],
    ]

    var body: some View {
        RealityView { content in
            // Turn on camerat tracking
            
            let center = ModelEntity(
                mesh: .generateSphere(radius: 0.1),
                materials: [SimpleMaterial(color: .red, isMetallic: true)]
            )
            center.components.set(
                RotationComponent(rotationSpeed: 1.0)
            )
            content.add(center)
            
            
            // Add random spheres
            for _ in 1...10 {
                let sphere = ModelEntity(
                    mesh: .generateBox(size: 0.3),
                    materials: [SimpleMaterial(
                        color: colors.randomElement()!,
                        isMetallic: true
                    )]
                )
                sphere.position.z = Float.random(in: -0.5...0.5)
                sphere.position.x = Float.random(in: -0.5...0.5)
                sphere.position.y = Float.random(in: -1.0...1.0)
                let rotationSpeed = Float.random(in: -1.0...1.0)
                let rotationComp = RotationComponent(
                    rotationSpeed: Float.random(in: 0.5...3.0),
                    rotationAxis: rotationAxises.randomElement()!
                )
                sphere.components.set(rotationComp)
                center.addChild(sphere)
            }
        }
        .ignoresSafeArea()
        .task {
            RotationSystem.registerSystem()
        }
    }
}

#Preview {
    SolarSysCodeAlongView()
}
