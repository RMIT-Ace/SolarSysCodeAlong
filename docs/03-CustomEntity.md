# RealityKit Code Along - Custom Entity

In our previous post, we learned how Entity, Component, and System (ECS) helps simplifying coding our immersive applications. However, we did see 2 problems: 

1. repetition of codes, and
2. a child entity does not rotate independently of its parent rotation

# DRY - Don't Repeat Yourself

Creating multiple celestrial objects used similar repeating coding pattern. We will create a custom class that constructs and returns an entity that represents our celestrial body.

```swift
class CelestialEntity: Entity {
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    required init?(
        bundle: Bundle = .main,
        name: String,
        scale: Float = 1.0,
        distanceFromCenter: Float) async
    {
        super.init()
        ...
    }
    ...
}
```

The first initialiser simply prevents us from calling it without specifying all the required arguments.

We will use the second initialiser to create our solar objects. For example.

```swift
let sun = CelestrialEntity("Sun", distanceFromCenter: 0.0)      // Sun is at the center.
let earth = CelestrialEntity("Earth", distaneFromCenter: 1.0)   // i.e. 1 meter from the sun.
```

# Double Bodies

How to we solve our second problem? How can we rotate parent entity without causing child entities to be rotated along its parent?

One way to implement this is to use double bodies. 

```
- Celestrial Object
    |
    |- Main body - body that has appearance and spinning
    |
    `- Rigid body - body with no appearance and does not spin
```

We attach `RotationComponent` and materials to the `main body`.

We attach any child satellite the `Rigid body`.

```swift
required init?(
        bundle: Bundle = .main,
        name: String,
        scale: Float = 1.0,
        distanceFromCenter: Float) async
    {
        super.init()
        
        // MainBody - The body that spins. Also this body has visual apperance, i.e. materials.
        guard let url = bundle.url(forResource: name, withExtension: "usdz"),
              let celestialObj = try? await ModelEntity(contentsOf: url) else {
            print("ERROR: loading model")
            return nil
        }
        self.name = name
        celestialObj.name = "MainBody"
        celestialObj.transform = Transform(
            scale: SIMD3(repeating: scale),
            translation: .init(x: distanceFromCenter, y: 0, z: 0)
        )
        addChild(celestialObj)
        
        // The rigid body (doesn't spin) - for adding children. No Visual appearance..
        let nonRotatingMainBody = Entity()
        nonRotatingMainBody.name = "NonRotatingMainBody"
        nonRotatingMainBody.transform = Transform(
            translation: .init(x: distanceFromCenter, y: 0, z: 0)
        )
        addChild(nonRotatingMainBody)
    }
```

We need to modify `addChild()` function so that the child is attached to to right body.

```swift
func addChild(_ child: Entity) {
        guard let mainBody = findEntity(named: "NonRotatingMainBody") else {
            print("WARN: Entity \(name) does not have main body.")
            super.addChild(child)
            return
        }
        
        mainBody.addChild(child)
}
```

There are 2 movements for our celestrial object, one is to rotate around itself, and another is to orbit around the center.

```swift
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
```

# Creating Celestrial Bodies

```swift
if let sun = await CelestialEntity(name: "Sun", scale: 4.5, distanceFromCenter: 0.0) {
    root.addChild(sun)

    let earth = await CelestialEntity(name: "Earth", scale: 1.0, distanceFromCenter: 1.0) {
        sun.addChild(earth)
    }
}
```

And to make them rotate, we need to call `updateRotation()` and `updateOrbit()` for each object.

```swift
var body: some View {
    RealityView { content in
    ...
    } update: { content in
        Task {
            await sun.updateRotation(speed: standardSpeed / 27.0) 
            await earth.updateRotation(speed: standardSpeed / 1.0)
            await earth.updateOrbit(speed: standardSpeed / 10)    
        }
    }
}
```