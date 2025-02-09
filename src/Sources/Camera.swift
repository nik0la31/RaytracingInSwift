class Camera {

    var aspectRatio : Float = 16.0 / 9.0    // Ratio of image width over height
    var imageWidth = 256                    // Rendered image width in pixel count
    var samplePerPixel = 10                 // Count of random samples for each pixel
    var maxDepth = 10                       // Maximum number of ray bounces into scene

    private var imageHeight = 0             // Rendered image height
    private var center = Point3()           // Camera center
    private var pixel00Loc = Point3()       // Location of pixel 0, 0
    private var pixelDeltaU = Vector3()     // Offset to pixel to the right
    private var pixelDeltaV = Vector3()     // Offset to pixel below
    private var pixelSamplesScale = Float(1)// Color scale factor for a sum of pixel samples

    private func initialize() {
        imageHeight = Int((Float(imageWidth) / aspectRatio))
        imageHeight = (imageHeight < 1) ? 1 : imageHeight

        pixelSamplesScale = 1.0 / Float(samplePerPixel)

        center = Point3(x: 0, y: 0, z: 0)

        // Determine viewport dimensions.
        let focalLength : Float = 1.0
        let viewportHeight : Float = 2.0
        let viewportWidth = viewportHeight * (Float(imageWidth)/Float(imageHeight))

        // Calculate the vectors across the horizontal and down the vertical viewport edges.
        let viewportU = Vector3(x: viewportWidth, y: 0, z: 0)
        let viewportV = Vector3(x: 0, y: -viewportHeight, z: 0)

        // Calculate the horizontal and vertical delta vectors from pixel to pixel.
        pixelDeltaU = viewportU / Float(imageWidth)
        pixelDeltaV = viewportV / Float(imageHeight)

        // Calculate the location of the upper left pixel.
        let viewportUpperLeft =
            center - Vector3(x: 0, y: 0, z: focalLength) - viewportU / 2.0 - viewportV / 2.0
        pixel00Loc = viewportUpperLeft + 0.5 * (pixelDeltaU + pixelDeltaV)

    }

    private func rayColor(ray : Ray, depth: Int, world : Hittable) -> Color {
        if (depth <= 0) {
            // If we've exceeded the ray bounce limit, no more light is gathered.
            return Color()
        }

        var hit = HitRecord()
        if (world.hit(ray: ray, t: Interval(min: 0.001, max: Raytracing.infinity), hit: &hit)) {
            let direction = hit.normal + Vector3.randomUnitVector()
            return 0.5 * rayColor(ray: Ray(origin: hit.point, direction: direction), depth: depth - 1, world: world)
        }

        let unitDirection = Vector3.unitVector(v: ray.direction)
        let a = 0.5 * (unitDirection.y + 1.0)
        return (1.0 - a) * Color(x: 1.0, y: 1.0, z: 1.0) + a * Color(x: 0.5, y: 0.7, z: 1.0)
    }

    private func getRay(row: Int, col: Int) -> Ray {
        // Construct a camera ray originating from the origin and directed at randomly sampled
        // point around the pixel location i, j.

        let offset : Vector3 = sampleSquare();
        let pixelSample : Vector3 = pixel00Loc
                          + ((Float(col) + offset.x) * pixelDeltaU)
                          + ((Float(row) + offset.y) * pixelDeltaV);

        let rayOrigin : Vector3 = center;
        let rayDirection : Vector3 = pixelSample - rayOrigin;

        return Ray(origin: rayOrigin, direction: rayDirection);
    }

    private func sampleSquare() -> Vector3 {
        // Returns the vector to a random point in the [-.5,-.5]-[+.5,+.5] unit square.
        return Vector3(x: Raytracing.randomFloat() - 0.5, y: Raytracing.randomFloat() - 0.5, z: 0);
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
