@main
struct Raytracing {
    static func main() {
    
        // Image

        let imageWidth = 256
        let imageHeight = 256

        // Render

        print("P3")
        print(imageWidth, imageHeight, separator: " ")
        print(255)

        for row in 1...imageHeight {
            for col in 1...imageWidth {
                let pixelColor = Color( x: Float(col) / Float(imageWidth),  y: Float(row) / Float(imageHeight), z: 0.0)
                printColor( pixelColor: pixelColor )
            }
        }
    }
}