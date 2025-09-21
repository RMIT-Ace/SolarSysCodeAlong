//
//  ContentView.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 15/9/2025.
//
//  Notes:
//  (1) Simple Box shape with ModelEntity() - mesh and materials
//  (1a) Depth (meter) - distance away from camera for easy viewing
//  (2) Simple Sphere shape. Note on translation to move object from overlapping each others.
//  (3) Simple box entity with custom texture.
//  (3a) Import SolarSysRealityKet provides extra pre-made 3d assets and resources.
//  (4) Create 3D entity as Skybox! Note on a) Radius, b) Negative scale
//  (5) Load pre-made 3D model, i.e. Earth. Note on getting resource from SolarSysRealityKit package
//
//  Exercises:
//  (E1) Playaround with different textures
//  (E2) Experiment with different negative scale for skybox.

import SwiftUI
import RealityKit
import SolarSysRealityKit       // (3a)

struct SolarSysCodeAlongView: View {
    let depth: Float = -0.5     // (1a)
    
    var body: some View {
        RealityView { content in
            content.camera = .spatialTracking
            
            // (1) _solarsimplebox
            
            // (2) _solarsimplesphere
            
            // (3) _solarboxstar
           
            // (4) _solarsimpleskybox
           
            // (5) _solar3dmodel
            
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SolarSysCodeAlongView()
}
