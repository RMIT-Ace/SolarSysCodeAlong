//
//  ContentView.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 15/9/2025.
//
//  Notes:
//  (1) Remove all codes from previous exercise, except skybox code.
//  (2) Refactor code that creates skybox into a resuable function.
//  (2a) Call skybox function to create skybox for our code.
//  (3) Create entities
//  (3a) Big blue box entity
//  (3b) Earth entity
//  (3c) Moon entity
//  (3d) Sun entity
//  (4) Adding Component and System - see:
//  (4a) RotationComponent and
//  (4b) RotationSystem
//  (4c) Register Rotation System
//  (5) Make entity rotates
//  (5a) Make blue box rotates
//  (5b) Make Earth rotates
//  (5c) Make Sun rotates
//
//  Exercises:
//  (E1) Make the blue box invisible!

import SwiftUI
import RealityKit
import SolarSysRealityKit

struct SolarSysCodeAlongView: View {
    
    let depth: Float = -3.0
    let boxSize: Float = 2.0
    
    var body: some View {
        RealityView { content in
            content.camera = .spatialTracking
            
            // (1) Exercise setup
            
            // (2a) _solarcallskyboxfunc
            
            // (3a) _solarbigbluebox
            
            // (5a) _solarblueboxrotate
            
            // (3b) _solarblueboxearth
            
            // (3d) _solarblueboxsun
        }
        // (4c) _solarregisterrotation
        
        .ignoresSafeArea()
    }
    
    // (2) _solarskyboxfunc
}

#Preview {
    SolarSysCodeAlongView()
}
