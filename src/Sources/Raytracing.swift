@main
struct Raytracing {

    static func rayColor(r : Ray) -> Color {
        let unitDirection = Vector3.unitVector(v: r.direction)
        let a = 0.5 * (unitDirection.y + 1.0)
        return (1.0 - a) * Color(x: 1.0, y: 1.0, z: 1.0) + a * Color(x: 0.5, y: 0.7, z: 1.0)
    }

    static func main() {
    
        // Image

        let aspectRatio : Float = 16.0 / 9.0
        let imageWidth = 256

        // Calculate the image height, and ensure that it's at least 1.
        var imageHeight = Int((Float(imageWidth) / aspectRatio))
        imageHeight = (imageHeight < 1) ? 1 : imageHeight

        // Camera

        let focalLength : Float = 1.0
        let viewportHeight : Float = 2.0
        let viewportWidth = viewportHeight * (Float(imageWidth)/Float(imageHeight))
        let cameraCenter = Point3(x: 0, y: 0, z: 0)

        // Calculate the vectors across the horizontal and down the vertical viewport edges.
        let viewportU = Vector3(x: viewportWidth, y: 0, z: 0)
        let viewportV = Vector3(x: 0, y: -viewportHeight, z: 0)

        // Calculate the horizontal and vertical delta vectors from pixel to pixel.
        let pixelDeltaU = viewportU / Float(imageWidth)
        let pixelDeltaV = viewportV / Float(imageHeight)

        // Calculate the location of the upper left pixel.
        let viewportUpperLeft =
            cameraCenter - Vector3(x: 0, y: 0, z: focalLength) - viewportU / 2.0 - viewportV / 2.0
        let pixel00Loc = viewportUpperLeft + 0.5 * (pixelDeltaU + pixelDeltaV)

        // Render

        print("P3")
        print(imageWidth, imageHeight, separator: " ")
        print(255)

        for row in 1...imageHeight {
            for col in 1...imageWidth {
                let pixelCenter = pixel00Loc + (Float(col) * pixelDeltaU) + (Float(row) * pixelDeltaV)
                let rayDirection = pixelCenter - cameraCenter
                let r = Ray(origin: cameraCenter, direction: rayDirection);

                let pixelColor : Color = Raytracing.rayColor(r: r)
                printColor( pixelColor: pixelColor )
            }
        }
    }
}
