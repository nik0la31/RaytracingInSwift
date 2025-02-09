@main
struct Raytracing {

    static let infinity : Float = Float.greatestFiniteMagnitude
    static let pi : Float = 3.1415926535897932385

    static func degreesToRadians(degrees : Float) -> Float {
        return degrees * pi / 180
    }

    static func randomFloat() -> Float {
        return Float.random(in: 0.0 ..< 1.0)
    }

    static func randomFloat(min : Float, max : Float) -> Float {
        return Float.random(in: min ..< max)
    }

    static func main() {
    
        // World
        let world = HittableList()
        world.add(object: Sphere(center: Point3(x: 0, y: 0, z: -1), radius: 0.5))
        world.add(object: Sphere(center: Point3(x: 0, y: -100.5, z: -1), radius: 100))

        // Camera
        let cam = Camera()
        cam.aspectRatio = 16.0 / 9.0
        cam.imageWidth = 400
        cam.samplePerPixel = 100

        // Render
        cam.render(world: world)
    }
}
