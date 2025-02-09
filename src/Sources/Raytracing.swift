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

        let materialGround = Lambertian(albedo: Color(x: 0.8, y: 0.8, z: 0.0))
        let materialCenter = Lambertian(albedo: Color(x: 0.1, y: 0.2, z: 0.5))
        let materialLeft   = Dielectric(refractionIndex: 1.50)
        let materialBubble = Dielectric(refractionIndex: 1.00 / 1.50)
        let materialRight  = Metal(albedo: Color(x: 0.8, y: 0.6, z: 0.2), fuzz: 1.0)

        let world = HittableList()
        world.add(object: Sphere(center: Point3(x:  0, y: -100.5, z: -1.0), radius: 100.0, material: materialGround))
        world.add(object: Sphere(center: Point3(x:  0, y:    0.0, z: -1.2), radius:   0.5, material: materialCenter))
        world.add(object: Sphere(center: Point3(x: -1, y:    0.0, z: -1.0), radius:   0.5, material: materialLeft))
        world.add(object: Sphere(center: Point3(x: -1, y:    0.0, z: -1.0), radius:   0.4, material: materialBubble))
        world.add(object: Sphere(center: Point3(x:  1, y:    0.0, z: -1.0), radius:   0.5, material: materialRight))

        // Camera
        let cam = Camera()
        cam.aspectRatio = 16.0 / 9.0
        cam.imageWidth = 400
        cam.samplePerPixel = 100
        cam.maxDepth = 50

        cam.vfov = 20
        cam.lookfrom = Point3(x:-2, y: 2, z: 1)
        cam.lookat = Point3(x: 0, y: 0, z: -1)
        cam.vup = Vector3(x: 0, y: 1, z: 0)

        cam.defocusAngle = 10.0
        cam.focusDist = 3.4

        // Render
        cam.render(world: world)
    }
}
