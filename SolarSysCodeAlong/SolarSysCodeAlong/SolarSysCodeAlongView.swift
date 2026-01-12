//
//  ContentView.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 06/01/2026
//
//  Notes:
//  Implementing basic animation without using ECS.
//

import SwiftUI
import RealityKit
import SolarSysRealityKit

struct SolarSysCodeAlongView: View {
    
    let depth: Float = -2.0
    let boxSize: Float = 0.5
    let verticalSpacing: Float = 0.2
    
    var body: some View {
        RealityView { content in
            content.camera = .spatialTracking
            
            let blueBox = makeBoxEntity(name: "BlueBox", color: .blue, position: [0, 0, depth])
            let redBox = makeBoxEntity(name: "Redbox", color: .red, position: [boxSize + verticalSpacing, 0, depth])
            let greenBox = makeBoxEntity(name: "GreenBox", color: .green, position: [-(boxSize +  verticalSpacing), 0, depth])
            
            content.add(blueBox)
            content.add(redBox)
            content.add(greenBox)
            
            blueBox.components.set(RotationComponent(rotationSpeed: 10.0, rotationAxis: [0, -1, 0]))
            redBox.components.set(RotationComponent(rotationSpeed: 1.0, rotationAxis: [0, 1, 0]))
            greenBox.components.set(RotationComponent(rotationSpeed: 5.0, rotationAxis: [1, 0, 0]))
        }
        .ignoresSafeArea()
        .onAppear(){
            RotationSystem.registerSystem()
        }
    }
    
    private func makeBoxEntity(name: String, color: UIColor, position: SIMD3<Float>) -> ModelEntity {
        let boxEntity = ModelEntity(
            mesh: .generateBox(size: boxSize),
            materials: [SimpleMaterial(color: color, isMetallic: true)]
        )
        boxEntity.name = name
        boxEntity.transform = Transform(translation: position)
        return boxEntity
    }
    
}

#Preview {
    SolarSysCodeAlongView()
}
