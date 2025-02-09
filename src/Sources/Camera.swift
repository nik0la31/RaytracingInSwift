class Camera {

    var aspectRatio : Float = 16.0 / 9.0    // Ratio of image width over height
    var imageWidth = 256                    // Rendered image width in pixel count

    private var imageHeight = 0             // Rendered image height
    private var center = Point3()           // Camera center
    private var pixel00Loc = Point3()       // Location of pixel 0, 0
    private var pixelDeltaU = Vector3()     // Offset to pixel to the right
    private var pixelDeltaV = Vector3()     // Offset to pixel below

    private func initialize() {
        imageHeight = Int((Float(imageWidth) / aspectRatio))
        imageHeight = (imageHeight < 1) ? 1 : imageHeight

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

    private func rayColor(ray : Ray, world : Hittable) -> Color {
        var hit = HitRecord()
        if (world.hit(ray: ray, t: Interval(min: 0, max: Raytracing.infinity), hit: &hit)) {
            return 0.5 * (hit.normal + Color(x: 1.0, y: 1, z: 1))
        }

        let unitDirection = Vector3.unitVector(v: ray.direction)
        let a = 0.5 * (unitDirection.y + 1.0)
        return (1.0 - a) * Color(x: 1.0, y: 1.0, z: 1.0) + a * Color(x: 0.5, y: 0.7, z: 1.0)
    }

    func render(world : Hittable) {
        initialize()

        print("P3")
        print(imageWidth, imageHeight, separator: " ")
        print(255)

        for row in 1...imageHeight {
            for col in 1...imageWidth {
                let pixelCenter = pixel00Loc + (Float(col) * pixelDeltaU) + (Float(row) * pixelDeltaV)
                let rayDirection = pixelCenter - center
                let ray = Ray(origin: center, direction: rayDirection);

                let pixelColor : Color = rayColor(ray: ray, world: world)
                printColor( pixelColor: pixelColor )
            }
        }
    }
}