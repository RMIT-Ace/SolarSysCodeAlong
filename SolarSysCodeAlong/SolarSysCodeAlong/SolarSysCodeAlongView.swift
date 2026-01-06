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
    
    let depth: Float = -3.0
    let boxSize: Float = 2.0
    
    @State private var redBoxRotation: simd_quatf = .init()
    
    var body: some View {
        RealityView { content in
            content.camera = .spatialTracking
            
            let redBox = ModelEntity(
                mesh: .generateBox(size: boxSize),
                materials: [
                    SimpleMaterial(
                        color: .red.withAlphaComponent(0.2), isMetallic: false
                    )
                ]
            )
            redBox.name = "RedBox"
            redBox.transform = Transform(translation: SIMD3(0, 0, depth))
            content.add(redBox)
            self.redBoxRotation = redBox.transform.rotation
        } update: { content in
            if let redBox = content.entities.first(where: {$0.name == "RedBox"}) {
                redBox.transform.rotation = redBoxRotation
            }
        }
        .task {
            await foreverRunloop()
        }
        .ignoresSafeArea()
    }
    
    // Animation-loop without using ECS
    private func foreverRunloop() async {
        let angle: Float = 5 * .pi / 180
        while true {
            try? await Task.sleep(for: .milliseconds(100))
            redBoxRotation *= simd_quatf(angle: angle, axis: [0, 1, 0])
        }
    }
}

#Preview {
    SolarSysCodeAlongView()
}
