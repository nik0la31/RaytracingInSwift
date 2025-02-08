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
            let r = Float(col) / Float(imageWidth);
            let g = Float(row) / Float(imageHeight);
            let b = 0.0;

            let ir = Int(255.999 * r);
            let ig = Int(255.999 * g);
            let ib = Int(255.999 * b);

            print(ir, ig, ib, separator: " ")
        }
    }
  }
}