//
//  SolarSysViewModel.swift
//  OrbitAnimationStudy
//
//  Created by Ace on 9/9/2025.
//
//  Notes:
//  (8) Refactor functions into ViewModel - See 'SolarSysViewModel.swift'
//
//  Exercise:
//  (8b) Exercise - Adding Mars planet

import Foundation
import RealityKit
import SolarSysRealityKit

@Observable
class SolarSysViewModel {
    
    let celestialObjects: [CelestialObject] = [
        CelestialObject(
            name: "Sun",
            scale: 3.0,
            distanceCenter: 0.0,
            rotationSpeed: 27.0,
            orbitalSpeed: 0.0,
            satellites: [
                CelestialObject(
                    name: "Earth",
                    scale: 1.0,
                    distanceCenter: 1.0,
                    rotationSpeed: 3.0,
                    orbitalSpeed: 10.0,
                    satellites: [
                        CelestialObject(
                            name: "Moon",
                            scale: 1.0 / 2.0,
                            distanceCenter: 0.2,
                            rotationSpeed: 2.0,
                            orbitalSpeed: 1.0,
                        )
                    ]
                ),
                // (8b) _solarvmmars
            ]
        )
    ]
    
    func setupCelestialSystem(
        for parent: CelestialEntity,
        celestialObj: CelestialObject? = nil
    ) async {
        guard let celestialObj = celestialObj ?? celestialObjects.first
        else { return }
        guard let newCelestialEntity = await CelestialEntity(
            bundle: SolarSysRealityKitResources.bundle,
            name: celestialObj.name,
            scale: celestialObj.scale,
            distanceFromCenter: celestialObj.distanceCenter
        )  else {
            print(">> WARN: Could not create model for \(celestialObj.name)")
            return
        }
        parent.addChild(newCelestialEntity)
        for child in celestialObj.satellites {
            await setupCelestialSystem(
                for: newCelestialEntity,
                celestialObj: child
            )
        }
    }
    
    func updateCelestialMovements(
        in parent: CelestialEntity,
        for celestialObj: CelestialObject?,
        standardSpeed: Float
    ) async {
        guard let celestialObj = celestialObj ?? celestialObjects.first
        else { return }
        guard let celestialEntity = parent.findEntity(named: celestialObj.name) as? CelestialEntity else {
            print(">> WARN: Could not find model for \(celestialObj.name)")
            return
        }
        await celestialEntity.updateRotation(speed: standardSpeed / celestialObj.rotationSpeed)
        await celestialEntity.updateOrbit(speed: standardSpeed / celestialObj.orbitalSpeed)
        for child in celestialObj.satellites {
            await updateCelestialMovements(in: celestialEntity, for: child, standardSpeed: standardSpeed)
        }
    }
}
