import Foundation

class Camera {

    var aspectRatio : Float = 16.0 / 9.0    // Ratio of image width over height
    var imageWidth = 256                    // Rendered image width in pixel count
    var samplePerPixel = 10                 // Count of random samples for each pixel
    var maxDepth = 10                       // Maximum number of ray bounces into scene
    var vfov : Float = 90                   // Vertical view angle (field of view)
    var lookfrom = Point3(x: 0, y: 0, z: 0) // Point camera is looking from
    var lookat = Point3(x: 0, y: 0, z: -1)  // Point camera is looking at
    var vup = Vector3(x: 0, y: 1, z: 0)     // Camera-relative "up" direction
    var defocusAngle : Float = 0            // Variation angle of rays through each pixel
    var focusDist : Float = 10              // Distance from camera lookfrom point to plane of perfect focus

    private var imageHeight = 0             // Rendered image height
    private var center = Point3()           // Camera center
    private var pixel00Loc = Point3()       // Location of pixel 0, 0
    private var pixelDeltaU = Vector3()     // Offset to pixel to the right
    private var pixelDeltaV = Vector3()     // Offset to pixel below
    private var u = Vector3()               // Camera frame basis vectors
    private var v = Vector3()
    private var w = Vector3()
    private var defocusDiskU = Vector3()    // Defocus disk horizontal radius
    private var defocusDiskV = Vector3()    // Defocus disk vertical radius
    private var pixelSamplesScale = Float(1)// Color scale factor for a sum of pixel samples
    
    private func initialize() {
        imageHeight = Int((Float(imageWidth) / aspectRatio))
        imageHeight = (imageHeight < 1) ? 1 : imageHeight

        pixelSamplesScale = 1.0 / Float(samplePerPixel)

        center = lookfrom

        // Determine viewport dimensions.
        let theta : Float = Raytracing.degreesToRadians(degrees: vfov)
        let h : Float = tan(theta / 2)
        let viewportHeight = 2 * h * focusDist
        let viewportWidth = viewportHeight * (Float(imageWidth)/Float(imageHeight))

        // Calculate the u,v,w unit basis vectors for the camera coordinate frame.
        w = Vector3.unitVector(v: lookfrom - lookat)
        u = Vector3.unitVector(v: Vector3.cross(u: vup, v: w))
        v = Vector3.cross(u: w, v: u)

        // Calculate the vectors across the horizontal and down the vertical viewport edges.
        let viewportU = viewportWidth * u       // Vector across viewport horizontal edge
        let viewportV = viewportHeight * (-v)   // Vector down viewport vertical edge

        // Calculate the horizontal and vertical delta vectors from pixel to pixel.
        pixelDeltaU = viewportU / Float(imageWidth)
        pixelDeltaV = viewportV / Float(imageHeight)

        // Calculate the location of the upper left pixel.
        let viewportUpperLeft =
            center - focusDist * w - viewportU / 2.0 - viewportV / 2.0
        pixel00Loc = viewportUpperLeft + 0.5 * (pixelDeltaU + pixelDeltaV)

        // Calculate the camera defocus disk basis vectors.
        let defocusRadius = focusDist * tan(Raytracing.degreesToRadians(degrees: defocusAngle / 2))
        defocusDiskU = u * defocusRadius
        defocusDiskV = v * defocusRadius
    }

    private func rayColor(ray : Ray, depth: Int, world : Hittable) -> Color {
        if (depth <= 0) {
            // If we've exceeded the ray bounce limit, no more light is gathered.
            return Color()
        }

        var hit = HitRecord()
        if (world.hit(ray: ray, t: Interval(min: 0.001, max: Raytracing.infinity), hit: &hit)) {
            var scattered = Ray()
            var attenuation = Color()
            if (hit.material!.scatter(rayIn: ray, hit: hit, attenuation: &attenuation, scatteredRay: &scattered)) {
                return attenuation * rayColor(ray: scattered, depth: depth-1, world: world)
            }
            return Color()
        }

        let unitDirection = Vector3.unitVector(v: ray.direction)
        let a = 0.5 * (unitDirection.y + 1.0)
        return (1.0 - a) * Color(x: 1.0, y: 1.0, z: 1.0) + a * Color(x: 0.5, y: 0.7, z: 1.0)
    }

    private func getRay(row: Int, col: Int) -> Ray {
        // Construct a camera ray originating from the origin and directed at randomly sampled
        // point around the pixel location row, col.

        let offset : Vector3 = sampleSquare();
        let pixelSample : Vector3 = pixel00Loc
                          + ((Float(col) + offset.x) * pixelDeltaU)
                          + ((Float(row) + offset.y) * pixelDeltaV)

        let rayOrigin : Vector3 = (defocusAngle <= 0) ? center : defocusDiskSample() 
        let rayDirection : Vector3 = pixelSample - rayOrigin

        return Ray(origin: rayOrigin, direction: rayDirection)
    }

    private func sampleSquare() -> Vector3 {
        // Returns the vector to a random point in the [-.5,-.5]-[+.5,+.5] unit square.
        return Vector3(x: Raytracing.randomFloat() - 0.5, y: Raytracing.randomFloat() - 0.5, z: 0)
    }

    private func defocusDiskSample() -> Point3 {
        // Returns a random point in the camera defocus disk.
        let p = Vector3.randomInUnitDisk()
        return center + (p.x * defocusDiskU) + (p.y * defocusDiskV)
    }

    func render(world : Hittable) {
        initialize()

        print("P3")
        print(imageWidth, imageHeight, separator: " ")
        print(255)

        for row in 1...imageHeight {
            for col in 1...imageWidth {
                var pixelColor = Color()
                for _ in 1...samplePerPixel {
                    let ray : Ray = getRay(row: row, col: col)
                    pixelColor += rayColor(ray: ray, depth: maxDepth, world: world)
                }

                printColor( pixelColor: pixelSamplesScale * pixelColor )
            }
        }
    }
}
