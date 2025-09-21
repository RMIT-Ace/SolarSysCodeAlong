//
//  RotationComponent.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 16/9/2025.
//

import Foundation
import RealityKit

// (4a)
struct RotationComponent: Component {
    var rotationSpeed: Float = 0.0
    var rotationAxis: SIMD3<Float> = [0, 1, 0]
}
