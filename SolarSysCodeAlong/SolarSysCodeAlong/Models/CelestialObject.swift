//
//  StellarObject.swift
//  OrbitAnimationStudy
//
//  Created by Ace on 9/9/2025.
//
//  Notes:
//  (2) Create new type 'CelestialEntity' that hold necessary info for our celestial objects.
//      See: CelestialObject.swift. This file belongs to Model layer in MVVM

import Foundation

struct CelestialObject: Identifiable {
    let id: UUID = UUID()
    let name: String
    var scale: Float
    var distanceCenter: Float
    var rotationSpeed: Float
    var orbitalSpeed: Float
    var satellites: [CelestialObject] = []
}
